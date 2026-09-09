#!/usr/bin/env bash
# =====================================================================
#  TEST RÁPIDO — kit mínimo para decidir enganche y forma antes de
#  imprimir el juego completo.
#
#    ./test_rapido.sh            → los diez enganches + formas en v2
#    ./test_rapido.sh v3         → los diez enganches + formas en v3
#    ./test_rapido.sh v3 solo    → sólo las formas de la v3
#
#  Diez enganches son 30 piezas y ya no es "un rato". Para probar sólo unos
#  cuantos:  VERS="v2 v6 v10" ./test_rapido.sh v6
#
#  Si no sabes por dónde empezar:  VERS="v10 v6 v7" — la v10 es la que mejor
#  sale en cualquier impresora, la v6 la que mejor aguanta el uso y la v7 la
#  única que no tiene holgura que calibrar.
#
#  Sale todo en stl_test/ ($fn=48, suficiente para probar el ajuste).
#  Requiere openscad en el PATH (o exportar OPENSCAD=/ruta/openscad).
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")"
OPENSCAD="${OPENSCAD:-openscad}"
XVFB=""; command -v xvfb-run >/dev/null 2>&1 && XVFB="xvfb-run -a"

if ! command -v "$OPENSCAD" >/dev/null 2>&1 && [[ ! -x "$OPENSCAD" ]]; then
  echo "ERROR: no encuentro '$OPENSCAD'. Añádelo al PATH o pásalo a mano:" >&2
  echo "  OPENSCAD='/c/Program Files/OpenSCAD/openscad.com' ./test_rapido.sh" >&2
  exit 1
fi

FORMAS_V="${1:-v2}"
SOLO="${2:-no}"
FN=48
OUT=stl_test

scad_de() { [[ "$1" == "v1" ]] && echo "scad/sanding_stick.scad" || echo "scad/sanding_stick_$1.scad"; }

# Mango de bolsillo: 30 mm en vez de 125. Mismo diámetro, mismas ranuras,
# misma parte macho — cambia sólo lo que no influye en el encaje.
MANGO=(-D mango_largo=30 -D ranuras_num=4 -D ranuras_inicio=6 -D ranuras_paso=5)
# Cabezales recortados: la cara útil baja a 18 mm. El cuerpo y la hembra
# son los de la pieza real.
MINI=(-D largo_pala=18 -D largo_barra=18)

gen() {  # gen <carpeta> <nombre> <scad> [params...]
  local dir="$1" name="$2" scad="$3"; shift 3
  mkdir -p "$OUT/$dir"
  echo "   · $dir/$name"
  $XVFB "$OPENSCAD" --export-format binstl -o "$OUT/$dir/$name.stl" \
    -D "\$fn=$FN" "$@" "$scad" 2>&1 | grep -E "ERROR" || true
}

# ---- Bloque 1 · los enganches -------------------------------------
VERS="${VERS:-v1 v2 v3 v4 v5 v6 v7 v8 v9 v10}"
if [[ "$SOLO" != "solo" ]]; then
  echo "── enganches ($VERS)"
  for V in $VERS; do
    S="$(scad_de "$V")"
    gen enganches "test_ajuste_$V" "$S" -D 'pieza="test_ajuste"'
    gen enganches "mango_corto_$V" "$S" -D 'pieza="mango"' -D 'variante_mango="recta"' "${MANGO[@]}"
    gen enganches "cabezal_testigo_$V" "$S" -D 'pieza="cabezal"' -D 'tipo="pala"' \
        -D ancho=16 -D angulo=0 "${MINI[@]}"
    # La v8 y la v9 tienen una tercera pieza suelta. El test_ajuste ya la trae
    # al lado, pero se saca también aparte por si hay que reimprimirla sola
    # con otra holgura: es lo único que se toca al calibrar esas dos.
    if [[ "$V" == "v8" || "$V" == "v9" ]]; then
      gen enganches "pieza_suelta_$V" "$S" -D 'pieza="extra"'
    fi
  done
fi

# ---- Bloque 2 · las siete formas, en la versión elegida ------------
# Las formas son idénticas en las diez versiones: esto sólo sirve para decidir
# QUÉ cabezales quieres, no con qué enganche.
echo "── formas ($FORMAS_V)"
S="$(scad_de "$FORMAS_V")"
gen "formas_$FORMAS_V" "mango_corto" "$S" -D 'pieza="mango"' -D 'variante_mango="recta"' "${MANGO[@]}"
for a in 0 45 90; do
  gen "formas_$FORMAS_V" "pala_16_$a" "$S" -D 'pieza="cabezal"' -D 'tipo="pala"' \
      -D ancho=16 -D angulo=$a "${MINI[@]}"
done
for t in triangulo prisma_tri medio_tubo_convexo medio_tubo_concavo; do
  gen "formas_$FORMAS_V" "${t}_16" "$S" -D 'pieza="cabezal"' -D "tipo=\"$t\"" \
      -D ancho=16 "${MINI[@]}"
done
# Un solo cabezal estrecho, para ver si los 8 mm hacen falta
gen "formas_$FORMAS_V" "pala_8_0" "$S" -D 'pieza="cabezal"' -D 'tipo="pala"' \
    -D ancho=8 -D angulo=0 "${MINI[@]}"

echo "Listo → $OUT/"
