#!/usr/bin/env bash
# =====================================================================
#  TEST RÁPIDO — kit mínimo para decidir enganche y forma antes de
#  imprimir el juego completo.
#
#    ./test_rapido.sh            → enganches de v1..v5 + formas en v2
#    ./test_rapido.sh v3         → enganches de v1..v5 + formas en v3
#    ./test_rapido.sh v3 solo    → sólo las formas de la v3
#
#  Sale todo en stl_test/ ($fn=48, suficiente para probar el ajuste).
#  Requiere openscad en el PATH (o exportar OPENSCAD=/ruta/openscad).
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")"
OPENSCAD="${OPENSCAD:-openscad}"
XVFB=""; command -v xvfb-run >/dev/null 2>&1 && XVFB="xvfb-run -a"

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

# ---- Bloque 1 · los cinco enganches -------------------------------
if [[ "$SOLO" != "solo" ]]; then
  echo "── enganches (v1..v5)"
  for V in v1 v2 v3 v4 v5; do
    S="$(scad_de "$V")"
    gen enganches "test_ajuste_$V" "$S" -D 'pieza="test_ajuste"'
    gen enganches "mango_corto_$V" "$S" -D 'pieza="mango"' -D 'variante_mango="recta"' "${MANGO[@]}"
    gen enganches "cabezal_testigo_$V" "$S" -D 'pieza="cabezal"' -D 'tipo="pala"' \
        -D ancho=16 -D angulo=0 "${MINI[@]}"
  done
fi

# ---- Bloque 2 · las siete formas, en la versión elegida ------------
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
