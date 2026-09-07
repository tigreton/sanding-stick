#!/usr/bin/env bash
# Renderiza las piezas del Sanding Stick a STL.
#
#   ./render.sh                  → v1, calidad final ($fn=96)  → stl/v1/
#   ./render.sh v3               → sólo la v3                  → stl/v3/
#   ./render.sh todas            → las cinco versiones
#   ./render.sh v2 preview       → rápido ($fn=48) + PNG       → preview_stl/v2/, png/v2/
#
# Versiones:  v1 hexágono a presión · v2 bayoneta · v3 rosca · v4 imán · v5 clip
# Requiere openscad en el PATH (o exportar OPENSCAD=/ruta/openscad).
set -euo pipefail
cd "$(dirname "$0")"
OPENSCAD="${OPENSCAD:-openscad}"
XVFB=""; command -v xvfb-run >/dev/null 2>&1 && XVFB="xvfb-run -a"

ARG1="${1:-v1}"; MODE="${2:-final}"
if [[ "$MODE" == "preview" ]]; then FN=48; RAIZ=preview_stl; PNG=1; else FN=96; RAIZ=stl; PNG=0; fi
VERS=("$ARG1"); [[ "$ARG1" == "todas" ]] && VERS=(v1 v2 v3 v4 v5)

scad_de() { [[ "$1" == "v1" ]] && echo "scad/sanding_stick.scad" || echo "scad/sanding_stick_$1.scad"; }

for V in "${VERS[@]}"; do
  SCAD="$(scad_de "$V")"; OUT="$RAIZ/$V"; PNGD="png/$V"
  mkdir -p "$OUT"; [[ "$PNG" == "1" ]] && mkdir -p "$PNGD"
  echo "── $V  ($SCAD)"

  render() {
    local name="$1"; shift
    echo "   · $name"
    $XVFB "$OPENSCAD" -o "$OUT/$name.stl" -D "\$fn=$FN" "$@" "$SCAD" 2>&1 | grep -E "ERROR" || true
    if [[ "$PNG" == "1" ]]; then
      $XVFB "$OPENSCAD" -o "$PNGD/$name.png" --imgsize=1000,750 --viewall --autocenter \
        --camera=0,0,0,60,0,35,0 --projection=p --colorscheme=Tomorrow -D "\$fn=$FN" "$@" "$SCAD" \
        >/dev/null 2>&1 || true
    fi
  }

  for v in recta ergonomica doble; do
    render "mango_$v" -D 'pieza="mango"' -D "variante_mango=\"$v\""
  done
  for w in 8 16; do
    for a in 0 45 90; do
      render "cabezal_pala_${w}_${a}" -D 'pieza="cabezal"' -D 'tipo="pala"' -D "ancho=$w" -D "angulo=$a"
    done
    for t in triangulo prisma_tri medio_tubo_convexo medio_tubo_concavo; do
      render "cabezal_${t}_${w}" -D 'pieza="cabezal"' -D "tipo=\"$t\"" -D "ancho=$w"
    done
  done
  render "test_ajuste" -D 'pieza="test_ajuste"'
done
echo "Listo."
