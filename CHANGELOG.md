# Historial de versiones — Sanding Stick

Todas las versiones comparten formas de cabezal, anchos, mangos y orientación de
impresión. Lo único que cambia es la unión entre mango y cabezal.

---

## Kit de test rápido · 8 de septiembre de 2026

Añadidos `test_rapido.sh`, `TEST_RAPIDO.md` y la carpeta `stl_test/` (24 piezas,
68 cm³ en total, repartidas en tres pasos de ~1 h cada uno). No cambia ninguna
pieza del modelo: es el mismo `.scad` con `mango_largo=30`, `largo_pala=18` y
`largo_barra=18`, para probar los cinco enganches y las siete formas sin imprimir
el juego entero.

La geometría de unión no se toca. Comprobado con `pieza="interferencia"` sobre el
mango corto de la v2: 0,11 mm³ de solape, el aprieto de diseño de la bayoneta.
Las 24 mallas son estancas (0 aristas de borde, 0 no-manifold).

---

## v1.0 — Hexágono a presión · 7 de septiembre de 2026

Primera versión completa. **Congelada** en `sanding_stick_v1.0.zip`.

Espiga hexagonal de 6 mm entrecaras a presión, espiga en el mango y hueco en el
cabezal. Holgura 0,15 mm por lado, 12 mm de agarre, chaflanes de 0,8 mm.

18 piezas: 3 mangos + 14 cabezales + pieza de calibración. Las 18 estancas, todas
dentro de 180 × 180 × 180 mm.

Correcciones durante el desarrollo:

- `cabezal_pala_8_45`: 8 aristas no-manifold por tangencia entre la superficie
  reglada del cuello y el cilindro del cuerpo → base del cuello reducida a Ø11,4 mm.
- `cabezal_triangulo_8`: vértices sin fusionar en el hombro → hombro rediseñado como
  `hull()` de un círculo Ø12 hacia el ancho de la pala.

## v2.0 — Bayoneta de 1/4 de vuelta

Vástago Ø8,6 con dos ranuras en L y taladro Ø8,96 con dos tetones. El canal es
helicoidal: su techo baja 0,25 mm a lo largo del giro, de modo que **girar aprieta**
el cabezal contra el hombro. Cuña autoblocante, con un resalte de 0,06 mm que da el
clic al entrar en el asiento y un tope duro al final.

- Los tetones a ±90° (horizontales sobre la cama) → cero voladizos en el cabezal.
- Diámetro elegido para que la sección crítica del canal aguante: Ø6,36 en el fondo
  de la ranura, ~21 MPa a 20 N de empuje, el doble de margen.
- Encaje verificado por volumen: 0 mm³ en la posición de inserción, 0,111 mm³ (el
  apriete buscado) en la posición bloqueada.

## v3.0 — Rosca cuadrada Ø8 × paso 2

Seis vueltas de filete cuadrado de 0,7 mm, piloto liso Ø8,6 × 2 que centra antes de
engranar, hombro plano de apoyo. Holgura 0,25 radial + 0,15 axial por flanco.

Dos fallos encontrados y corregidos:

- La hembra y el piloto sólo se **tocaban** en un plano → CGAL dejaba el taladro como
  cavidad cerrada. Resuelto bajando la hélice un paso entero dentro del piloto.
- **Quiralidad:** el marco de la boca del cabezal está espejado en Z, así que la
  hélice de la hembra salía a izquierdas contra un macho a derechas (44 mm³ de
  interferencia). Resuelto invirtiendo la hélice y girándola 180°.

## v4.0 — Imán Ø6×3 + espiga en D

Espiga Ø9 × 7,5 con cara plana antigiro y un imán de neodimio en la punta; otro
imán al fondo del taladro, con 0,3 mm de separación entre caras al montar.
Requiere 15 imanes (uno por mango y por cabezal) pegados con cianoacrilato.

- Mismo fallo de cavidad cerrada que la v3 en el alojamiento del imán, resuelto
  solapando 0,4 mm el alojamiento dentro del taladro.
- Encaje verificado: 0,000 mm³ de interferencia.

## v5.0 — Clip elástico de dos brazos

Vástago partido por una ranura de 3,8 mm en dos brazos de 11,5 mm de voladizo, con
pestañas de 0,6 mm y rampas de 40° a ambos lados. Dos caras planas orientan y hacen
de chaveta.

- Dimensionado por deformación: ~1,4 % en el brazo al montar, dentro de lo admisible
  para PLA y holgado para PETG (el material recomendado).
- Los rebajes del cabezal van a ±90°, horizontales sobre la cama, igual que los
  tetones de la v2 y por la misma razón.

---

## Estado de verificación (90 piezas)

| | Piezas | Estancas | Interferencia macho/hembra | Volumen total |
|---|---|---|---|---|
| v1 | 18 | 18/18 | — | 90,9 cm³ |
| v2 | 18 | 14/18 · resto con duplicados <10 µm | 0,111 mm³ (apriete) | 88,2 cm³ |
| v3 | 18 | 18/18 | 0,000 mm³ | 89,2 cm³ |
| v4 | 18 | 17/18 · 1 con duplicados <10 µm | 0,000 mm³ | 90,3 cm³ |
| v5 | 18 | 18/18 | 0,016 mm³ (apriete) | 87,3 cm³ |

OpenSCAD reporta `Simple: yes` —sólido 2-manifold válido— en las 90 piezas. Los
«duplicados <10 µm» son vértices que el exportador de STL ASCII escribe dos veces
con 0,003–0,01 mm de diferencia en los bordes del canal de la bayoneta; cualquier
laminador los fusiona sin avisar y no afectan a la impresión.
