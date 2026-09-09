#!/usr/bin/env python3
"""Regenera visor_lijador.html: renderiza las piezas que falten, las empaqueta
en web/meshes.js y las inyecta en web/plantilla.html.

    python3 web/_empaquetar.py              # sólo lo que falte en meshes.js
    python3 web/_empaquetar.py v6 v7        # fuerza esas versiones
    python3 web/_empaquetar.py --todo       # todas, desde cero

Las mallas van cuantizadas a 16 bits y comprimidas (~5 KB por cabezal), porque
la CSP de un artefacto no deja cargar STL por fetch: tienen que ir empotradas.
"""
import base64, json, os, re, subprocess, sys, tempfile, zlib
import numpy as np, trimesh

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
OPENSCAD = os.environ.get("OPENSCAD", "openscad")
XVFB = ["xvfb-run", "-a"] if os.environ.get("XVFB", "1") == "1" else []
FN = 48

VERSIONES = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10"]
CON_PIEZA_SUELTA = {"v8", "v9"}

def scad(v):
    return os.path.join(RAIZ, "scad", "sanding_stick.scad" if v == "v1"
                        else f"sanding_stick_{v}.scad")

def piezas(v):
    """(clave, [-D ...]) de todo lo que el visor necesita de esta versión."""
    out = [("mango_recta", ['pieza="mango"', 'variante_mango="recta"']),
           ("test_ajuste", ['pieza="test_ajuste"'])]
    if v == "v1":
        out += [("mango_ergonomica", ['pieza="mango"', 'variante_mango="ergonomica"']),
                ("mango_doble",      ['pieza="mango"', 'variante_mango="doble"'])]
    for anc in (16, 8):
        for ang in (0, 45, 90):
            out.append((f"cabezal_pala_{anc}_{ang}",
                        ['pieza="cabezal"', 'tipo="pala"', f"ancho={anc}", f"angulo={ang}"]))
        for t in ("triangulo", "prisma_tri", "medio_tubo_convexo", "medio_tubo_concavo"):
            out.append((f"cabezal_{t}_{anc}",
                        ['pieza="cabezal"', f'tipo="{t}"', f"ancho={anc}"]))
    if v in CON_PIEZA_SUELTA:
        # Cuatro colocaciones: la pieza suelta cuelga del marco de la junta, y
        # ese marco se mueve con el ángulo del cabezal (y con su ancho a 90°).
        for tag, extra in (("a0",     ["angulo=0"]),
                           ("a45",    ["angulo=45"]),
                           ("a90w16", ["angulo=90", "ancho=16"]),
                           ("a90w8",  ["angulo=90", "ancho=8"])):
            out.append((f"extra_{tag}", ['pieza="extra_puesto"', 'tipo="pala"'] + extra))
    return out

def render(v, defs, destino):
    cmd = XVFB + [OPENSCAD, "--export-format", "binstl", "-o", destino,
                  "-D", f"$fn={FN}"]
    for d in defs:
        cmd += ["-D", d]
    cmd.append(scad(v))
    r = subprocess.run(cmd, capture_output=True, text=True)
    if not os.path.exists(destino) or os.path.getsize(destino) < 200:
        raise RuntimeError(f"render vacío: {v} {defs}\n{r.stderr[-400:]}")

def pack(path):
    m = trimesh.load(path)
    m.vertices = np.round(m.vertices, 3); m.merge_vertices()
    m.update_faces(m.nondegenerate_faces()); m.merge_vertices()
    v, fa = m.vertices, m.faces
    lo = v.min(0); rng = np.maximum(v.max(0) - lo, 1e-6)
    q = np.round((v - lo) / rng * 65535).astype(np.uint16)
    blob = zlib.compress(q.tobytes() + fa.astype(np.uint32).tobytes(), 9)
    return {"lo": [round(float(x), 3) for x in lo],
            "rng": [round(float(x), 4) for x in rng],
            "nv": int(len(v)), "nf": int(len(fa)),
            "d": base64.b64encode(blob).decode()}

def cargar_meshes():
    p = os.path.join(AQUI, "meshes.js")
    if not os.path.exists(p):
        return {}
    txt = open(p, encoding="utf-8").read()
    return json.loads(txt[txt.index("{"):txt.rindex("}") + 1])

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    todo = "--todo" in sys.argv
    M = {} if todo else cargar_meshes()
    objetivo = args or VERSIONES
    tmp = tempfile.mkdtemp()
    nuevas = 0
    for v in objetivo:
        for clave, defs in piezas(v):
            k = f"{v}_{clave}"
            if k in M and not todo and not args:
                continue
            dst = os.path.join(tmp, k + ".stl")
            print(f"  · {k}", flush=True)
            render(v, defs, dst)
            M[k] = pack(dst)
            nuevas += 1
    orden = {v: i for i, v in enumerate(VERSIONES)}
    M = dict(sorted(M.items(), key=lambda kv: (orden.get(kv[0].split("_")[0], 99), kv[0])))
    js = "var MESHES=" + json.dumps(M, separators=(",", ":")) + ";"
    open(os.path.join(AQUI, "meshes.js"), "w", encoding="utf-8", newline="\n").write(js)
    plantilla = open(os.path.join(AQUI, "plantilla.html"), encoding="utf-8").read()
    salida = plantilla.replace("/*__MESHES__*/", js)
    open(os.path.join(RAIZ, "visor_lijador.html"), "w", encoding="utf-8", newline="\n").write(salida)
    print(f"\n{nuevas} mallas nuevas · {len(M)} en total · "
          f"visor_lijador.html {len(salida)/1024:.0f} KB")

if __name__ == "__main__":
    main()
