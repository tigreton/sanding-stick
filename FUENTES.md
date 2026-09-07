# Fuentes e indicaciones — Sanding Stick

Registro de todo lo que entró en el proyecto: qué pediste, qué elegiste, qué se
consultó y por qué el diseño acabó así. 7 de septiembre de 2026, versiones 1 a 5.

---

## 1. Petición original (literal)

> quiero un "sanding stick" formado por el mango y el cabezal.
>
> El mago es igual para todo, del tamaño algo asi como un boligrafo.
>
> El cabezal, que debe ser intercambiable, tiene diferentes cabezas. Unas
> totalmente planas y a 90 grados, otras a 45. Otras a 0 grados. Tiene diferentes
> formas, un rectangulo, un triangulo, forma de medio tubo etc...
>
> La idea que se pueda pegar un trozo de papel de lija y poder lijar elementos de
> impresiones 3d o filigranas en madera. Presentamelo también primero con varios
> diseños 2 o 3D antes de hacer obtener el stl final.
>
> Guarda las fuentes y las indicaciones que hayas usado

## 2. Decisiones que tomaste

| Pregunta | Respuesta |
|---|---|
| Unión mango–cabezal | **Espiga hexagonal a presión.** Guardar las otras tres opciones para después |
| Ancho de la cara de lijado | **Varios anchos**: cada forma en 8 y 16 mm |
| Medio tubo | **Ambos**: uno convexo y uno cóncavo |
| Forma del mango | **Cilíndrico con ranuras** de agarre |

Opciones aparcadas en aquel momento a petición tuya —rosca, bayoneta e imán— y
retomadas después:

| Petición posterior | Resultado |
|---|---|
| «guárdalo todo esto como versión 1» | v1 congelada en `sanding_stick_v1.0.zip` |
| «como versión 2, quiero otro tipo de enganche» | v2, **bayoneta de 1/4 de vuelta** (elegida por ti entre cuatro opciones) |
| «cuando termines, haz las otras tres versiones» | v3 rosca, v4 imán, v5 clip elástico — las tres restantes de aquella lista |

También elegiste tener la v2 en un **archivo `.scad` aparte**, no como parámetro
dentro del de la v1. Al llegar a cinco versiones eso se resolvió con un generador
(`scad/_generar_versiones.py`): cinco archivos independientes y autocontenidos, pero
un solo esqueleto que mantener.

## 3. Contexto de proyecto reutilizado

De la base de conocimiento «diseños 3d» de tus conversaciones anteriores:

- Impresora **Bambu Lab A1 Mini**, volumen 180 × 180 × 180 mm → toda pieza debe
  caber ahí; de ahí la variante de mango tumbado.
- Flujo de trabajo ya establecido: **OpenSCAD paramétrico**, render sin pantalla
  con `xvfb-run` + `openscad -o`. El modelo sigue ese mismo patrón (parámetros
  con nombre arriba del archivo, una sola fuente para todas las piezas).
- Aprendizaje de las bandejas Leuchtturm: los agujeros y encajes necesitan
  **material sólido alrededor** para anclar; aquí se traduce en el cuerpo macizo
  de Ø12 × 16 mm del cabezal y en el hombro de las palas de 8 mm.

## 4. Fuentes externas consultadas

**Tolerancias de ajuste a presión en FDM** — se buscó para fijar el valor de
`holgura` con un criterio, no a ojo. Los resultados coinciden en un rango de
**0,05–0,15 mm por lado** para un press fit en FDM, en añadir un **chaflán o
radio de entrada** en eje y agujero para guiar el montaje y evitar agrietar la
pared, y en que las **geometrías hexagonales o cuadradas funcionan mejor** que
las cilíndricas porque exigen estirar menos material. También insisten en
imprimir una probeta antes de tirar la serie.

→ Decisión: `holgura = 0.15` (extremo alto del rango, porque el cabezal se cambia
muchas veces y un ajuste demasiado apretado acabaría partiendo la pared),
chaflanes de 0,8 mm en espiga y hueco, y pieza de calibración `test_ajuste.stl`
como primer paso obligatorio.

- [3D Printing Tolerances: Designing Gaps for Press Fits — Zbotic](https://zbotic.in/3d-printing-tolerances-designing-gaps-for-press-fits-threads-and-snap-fits/)
- [Engineering Fits: How to Design for 3D Printed Assemblies — AON3D](https://www.aon3d.com/applications/engineering-fits-how-to-design-for-3d-printed-assemblies/)
- [FDM 3D Printing Tolerances & Clearances — Sovol](https://www.sovol3d.com/blogs/news/fdm-3d-printing-tolerances-clearances-how-to-design-parts-that-fit)
- [Press-Fit Tolerances for 3D Printing — Creative3DP](https://tools.creative3dp.com/blog/press-fit-tolerances-3d-printing/)

**Volumen de impresión de la A1 Mini** — confirmado en la ficha técnica oficial:
180 × 180 × 180 mm.

- [Bambu Lab A1 mini — Technical Specifications](https://bambulab.com/en/a1-mini/tech-specs)
- [Ficha técnica A1 mini (PDF, Bambu Lab)](https://store.bblcdn.com/6cddc28fcb5a4a34975cfc7a23c83491.pdf)

**Granos de lija sugeridos** en el catálogo (P180–P800) proceden de la escala FEPA
P de uso común en acabado de impresiones 3D y madera; no se tomaron de una fuente
concreta y son una recomendación de partida, no una especificación.

## 5. Decisiones de diseño y su motivo

| Decisión | Motivo |
|---|---|
| Espiga en el mango, hueco en el cabezal | Permite imprimir **todos** los cabezales con la cara de lijado sobre la cama: sale plana y lisa, sin soportes |
| Hexágono en vez de cilindro | No gira al lijar de canto; estira menos material al entrar (mejor press fit en FDM) |
| 12 mm de agarre | Suficiente palanca para que el cabezal no cabecee; el cuerpo de 16 mm deja 3,5 mm de pared en el fondo |
| Cuerpo del cabezal Ø12 = Ø del mango | El conjunto queda enrasado, sin escalón donde engancharse |
| Eje del cuerpo a 5,5 mm de la cama | Genera un plano de apoyo de ~5 mm bajo el cuerpo: se imprime estable sin soportes |
| Hombro en las palas de 8 mm | Sin él, el cuello Ø12 → 8 mm dejaba geometría degenerada y un punto débil |
| Base del cuello Ø11,4 (0,6 menos que el cuerpo) | Evita que la superficie del `hull()` quede tangente al cilindro; sin esto una malla salía no-manifold |
| Tercera variante de mango (doble, tumbado) | Una torre de 137 mm y 12 mm de base en una A1 Mini es imprimible pero esbelta; esta variante lo resuelve por geometría |

## 6. Verificación hecha

- Las 18 mallas se comprobaron con `trimesh`: **todas estancas** (`is_watertight`)
  tras normalizar la precisión del STL ASCII, y OpenSCAD reporta `Simple: yes` en
  todas.
- Envolventes comprobadas contra 180 × 180 × 180 mm: la pieza mayor es el mango
  doble, 149 mm.
- Dos fallos detectados y corregidos en el proceso: `cabezal_pala_8_45` con 8
  aristas no-manifold en la tangencia cuello/cuerpo, y `cabezal_triangulo_8` con
  vértices sin fusionar. Ambos resueltos en el modelo, no en la malla.
- Montaje mango + cabezal verificado a 0°, 45° y 90° mediante render del módulo
  `conjunto()` (ver `png/conjunto_16_*.png`).

## 7. Herramientas

OpenSCAD 2021.01 (AppImage, render sin pantalla con `xvfb-run`) · Python 3 con
`trimesh` para la verificación de mallas · `three.js` r128 y `pako` 2.1.0 en el
visor HTML.

---

## 8. Lo aprendido al hacer las cinco uniones

Tres problemas que no se ven venir y que aparecieron al modelar juntas distintas
sobre el mismo esqueleto. Quedan aquí porque volverán a aparecer con la sexta:

**Quiralidad del marco de la boca.** El taladro del cabezal se construye con
`mirror([0,0,1])`, así que ese marco está espejado respecto al del mango. Cualquier
geometría con «mano» —una hélice de rosca, el canal de una bayoneta— sale invertida
en la hembra si se escribe igual que en el macho. En la v3 costó 44 mm³ de
interferencia hasta dar con ello; la solución es invertir la hélice **y** girarla
180°, porque el espejo no es sólo un cambio de signo del ángulo.

**Negativos que sólo se tocan.** Cuando dos sólidos que se van a restar comparten
exactamente un plano (el taladro acabando justo donde empieza el alojamiento del
imán, o el piloto justo donde empieza la rosca), CGAL no los une: deja una cavidad
cerrada dentro de la pieza. Pasó en la v3 y en la v4. Hay que solaparlos en volumen,
aunque sea 0,4 mm.

**Superficies tangentes.** Cuando la superficie reglada de un `hull()` queda
exactamente tangente a un cilindro, aparecen aristas compartidas por cuatro caras.
Se resuelve haciendo la base del `hull()` 0,6 mm más pequeña que el cilindro, para
que nunca lleguen a tocarse.

**Comprobación que lo detecta todo.** `pieza="interferencia"` renderiza la
intersección del cabezal con el mango montado. Su volumen debe ser cero, o justo el
apriete que se haya buscado a propósito. Es una comprobación de dos segundos que
encuentra en el acto lo que a ojo pasa desapercibido.
