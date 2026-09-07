# Subir el repositorio

El repositorio ya está creado en esta carpeta, con un commit inicial y la
etiqueta `v5.0`. Sólo falta enviarlo a un servidor. Yo no puedo hacer ese paso:
requiere tus credenciales.

## 1 · Crea el repositorio vacío

En [github.com/new](https://github.com/new) (o GitLab, o Codeberg): elige el
nombre —`sanding-stick` va bien— y **no marques** «Add a README», «Add .gitignore»
ni «Choose a license». Tiene que quedar completamente vacío, o el primer `push`
chocará.

## 2 · Conéctalo y sube

Desde una terminal, en esta misma carpeta:

```bash
git remote add origin https://github.com/TU-USUARIO/sanding-stick.git
git push -u origin main
git push origin v5.0
```

La primera vez GitHub pedirá autenticación. Si te pide contraseña, no vale la de
la cuenta: hay que usar un **token personal** (Settings → Developer settings →
Personal access tokens) o instalar [GitHub CLI](https://cli.github.com) y hacer
`gh auth login` una sola vez.

Con GitHub CLI los tres pasos se quedan en uno:

```bash
gh repo create sanding-stick --public --source=. --push
```

## Qué se sube y qué no

**Sí** (22 archivos, 5,4 MB): los cinco `.scad`, el generador, `render.sh`, el
visor 3D, la documentación, la licencia y las cinco piezas de calibración
`stl/vN/test_ajuste.stl` en STL binario.

**No** (`.gitignore`): `preview_stl/` y `png/` — 105 MB de archivos regenerables
con `./render.sh`. Y los `.zip`.

Si prefieres que el juego completo de STL esté en el repositorio, lo suyo no es
quitarlos del `.gitignore` —105 MB en ASCII— sino convertirlos a binario primero:

```bash
python3 - <<'EOF'
import trimesh, glob
for f in glob.glob("stl/v*/*.stl"):
    trimesh.load(f).export(f)          # reescribe en binario, ~5 veces menos
EOF
```

y publicarlos como **Release** en vez de como archivos del repositorio, que es lo
habitual en proyectos de impresión 3D:

```bash
./render.sh todas                       # genera stl/v1..v5 a calidad final
gh release create v5.0 stl/v*/*.stl --title "Sanding Stick v5.0"
```

## Licencia

Va con licencia **MIT**, que es permisiva y sirve tanto para el código como para
los modelos. Si prefieres otra —CC BY-SA 4.0 y CERN-OHL-S son las habituales en
hardware libre, y obligan a compartir las modificaciones— sustituye el archivo
`LICENSE` antes de subirlo.
