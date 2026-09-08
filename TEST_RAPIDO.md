# Kit de test rápido

Piezas mínimas para decidir **qué enganche** y **qué formas** quieres antes de
imprimir el juego completo (que son 45–50 cm³ y unas cinco horas).

Todo está en `stl_test/`. **La geometría de unión es exactamente la de las piezas
reales**: lo único recortado es lo que no influye en el encaje — el mango pasa de
125 a 30 mm y la cara de lijado de 40 a 18 mm. Si aquí encaja, encaja en el juego
final.

---

## Paso 1 · ¿Qué enganche? (≈1 h, 12 cm³)

Imprime los cinco `test_ajuste_vN.stl` en una sola bandeja. Cada uno trae el
cuerpo con la hembra y un tapón con el macho, sueltos.

| Pieza | cm³ | Unión |
|---|---|---|
| `test_ajuste_v1` | 2,60 | hexágono a presión |
| `test_ajuste_v2` | 2,50 | bayoneta 1/4 de vuelta |
| `test_ajuste_v3` | 2,50 | rosca cuadrada |
| `test_ajuste_v4` | 2,39 | imán + chaveta en D |
| `test_ajuste_v5` | 2,25 | clip elástico |

Móntalos y desmóntalos veinte veces. Lo que buscas: que entre sin forzar, que
quede firme, y que el gesto no te moleste. **La v4 necesita dos imanes Ø6×3** para
probarla de verdad; sin ellos sólo comprueba que la espiga entra.

Estas cinco piezas también están versionadas a calidad final en
`stl/vN/test_ajuste.stl`: si no tienes OpenSCAD instalado, imprime ésas.

Si alguno va duro o baila, corrige **una sola variable** (la que dice «calibrar»
en el README de esa versión) y reimprime sólo esa pieza.

## Paso 2 · Con el mango en la mano (≈45 min por versión, 6,5 cm³)

De las dos o tres finalistas, imprime la pareja:

- `mango_corto_vN.stl` — Ø12 × 43 mm, cuatro ranuras. De pie, con balsa.
- `cabezal_testigo_vN.stl` — pala plana de 16 × 18 mm. Plano, cara de lijado abajo.

Es el gesto real de cambio de cabezal, con el par que hace un mango de verdad.
Pega un trozo de lija en el testigo y lija algo: el enganche que aguanta el tirón
lateral se nota en treinta segundos.

## Paso 3 · ¿Qué formas necesitas? (≈1,5 h, 24 cm³)

`stl_test/formas_v2/` trae las siete formas recortadas a 18 mm de cara útil, más
el mango corto. Están generadas en la **v2**; si eliges otra versión, regenéralas:

```bash
./test_rapido.sh v3 solo      # → stl_test/formas_v3/
```

| Pieza | cm³ | Para qué |
|---|---|---|
| `pala_16_0` | 2,47 | caras grandes, líneas de capa |
| `pala_16_45` | 2,30 | chaflanes |
| `pala_16_90` | 2,90 | fondos y rincones |
| `triangulo_16` | 2,22 | esquinas interiores |
| `prisma_tri_16` | 3,10 | ranuras en V |
| `medio_tubo_convexo_16` | 2,90 | interiores curvos |
| `medio_tubo_concavo_16` | 2,87 | varillas y cantos |
| `pala_8_0` | 1,80 | ¿te hace falta la serie estrecha de 8 mm? |
| `mango_corto` | 3,90 | — |

Lija con ellas una pieza impresa de verdad durante un rato y tacha las que no
uses. En el juego final imprimes sólo las que sobrevivan, ya con la cara larga
(40 mm) y en los dos anchos.

---

## Impresión

Cabezales y test de ajuste: **0,16 mm · 4 perímetros · 25 % · sin soportes ni
balsa**, cara de lijado sobre la cama. Mangos: **0,20 mm · 4 perímetros · 20 %,
de pie con balsa**, la parte macho arriba. PLA vale para todo; la v5 mejor en PETG.

Las cifras de tiempo son orientativas — mándalo al laminador y hazle caso a él.

## Regenerar el kit

```bash
./test_rapido.sh          # enganches v1..v5 + formas en v2
./test_rapido.sh v3       # enganches v1..v5 + formas en v3
./test_rapido.sh v3 solo  # sólo las formas de la v3
```

Requiere `openscad` en el PATH. Los STL salen a `$fn=48`: suficiente para probar
el ajuste, y la mitad de tiempo de render que la calidad final.
