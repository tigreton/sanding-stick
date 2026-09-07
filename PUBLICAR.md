# Subir el repositorio

El repositorio ya está listo: dos commits, la etiqueta `v5.0` y el remoto
`origin` apuntando a `https://github.com/tigreton/sanding-stick.git`.

Sólo falta el `push`, y ese paso tiene que salir de tu máquina: requiere
autenticarse con tu cuenta de GitHub.

## Opción A · GitHub CLI (crea el repositorio y lo sube)

Con [GitHub CLI](https://cli.github.com) instalado, en esta carpeta:

```bash
gh auth login                       # una vez; abre el navegador, sin pegar tokens
git remote remove origin            # gh crea el remoto él mismo
gh repo create sanding-stick --public --source=. --push
git push origin v5.0
```

## Opción B · Crear el repositorio en la web

1. En [github.com/new](https://github.com/new): nombre `sanding-stick`.
   **No marques** «Add a README», «Add .gitignore» ni «Choose a license» — tiene
   que quedar vacío o el primer `push` chocará.
2. En esta carpeta, el remoto ya está puesto:

```bash
git push -u origin main
git push origin v5.0
```

La primera vez GitHub pedirá autenticación. La contraseña de la cuenta **no
sirve**: hace falta un token personal (Settings → Developer settings → Personal
access tokens) o tener GitHub CLI instalado, que gestiona las credenciales solo.

## Qué se sube y qué no

**Sí** (23 archivos, 5,4 MB): los cinco `.scad`, el generador, `render.sh`, el
visor 3D, la documentación, la licencia y las cinco piezas de calibración
`stl/vN/test_ajuste.stl` en STL binario.

**No** (`.gitignore`): `preview_stl/` y `png/` — 105 MB de archivos regenerables
con `./render.sh`. Y los `.zip`.

Si quieres el juego completo de STL publicado, lo habitual en proyectos de
impresión 3D no es meterlos en el repositorio sino colgarlos como **Release**.

`render.sh` ya exporta en STL binario, así que no hay que convertir nada:

```bash
./render.sh todas       # genera stl/v1..v5 a calidad final, en binario
gh release create v5.0 stl/v*/*.stl --title "Sanding Stick v5.0"
```

**En Windows**, `render.sh` es un script de bash: ejecútalo desde **Git Bash**
(viene con Git para Windows) o desde WSL. En PowerShell no funciona.

Y si lanzas el `gh release` desde PowerShell, el comodín hay que expandirlo a
mano, porque PowerShell no lo hace por los programas externos:

```powershell
./render.sh todas       # esto, desde Git Bash
gh release create v5.0 (Get-ChildItem stl\v*\*.stl).FullName --title "Sanding Stick v5.0"
```

## Licencia

Va con licencia **MIT**, permisiva y válida tanto para el código como para los
modelos. Si prefieres copyleft —CC BY-SA 4.0 o CERN-OHL-S son las habituales en
hardware libre, y obligan a compartir las modificaciones— sustituye el archivo
`LICENSE` antes de subirlo.
