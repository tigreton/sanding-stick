# Historial de versiones — Sanding Stick

Todas las versiones comparten formas de cabezal, anchos, mangos y orientación de
impresión. Lo único que cambia es la unión entre mango y cabezal.

---

## v10.4 — La v10 se rompió otra vez, ahora por la base · 10 de septiembre de 2026

Segunda rotura, y por sitio distinto: con las espigas ya macizas, **una se partió
por la base al despegar la pieza de la cama**.

### El número

La raíz de una espiga es un voladizo vertical en una pieza impresa de pie, así
que trabaja **entre capas** (~30 MPa). Con Ø3,4, 12 mm de largo y llegando al
hombro en **ángulo vivo** —un concentrador de ~1,8—:

```
2 × Ø3,4 × 12, ángulo vivo (v10.1)     W = 3,86 mm³    rompe a  5,4 N  (0,5 kg)
2 × Ø4,4 raíz cónica × 9   (v10.2)     W = 8,36 mm³    rompe a 23,2 N  (2,4 kg)
un vástago Ø8,6 × 12 (v2, v6, v8…)     W = 62,4 mm³    rompe a 86,7 N  (8,8 kg)
```

Medio kilo de fuerza lateral en la punta. Eso no es una unión floja: es una pieza
que no se puede ni manipular. Y no lo vi porque en la 10.1 miré la lengüeta, que
era lo que había roto la vez anterior, y no volví a mirar la espiga.

### Los tres cambios, todos a la misma ecuación

La tensión en la raíz vale M/W, así que sólo hay tres palancas y se han movido
las tres: **Ø3,4 → Ø4,0** (W ×1,6), **12 → 9 mm de largo** (momento ×0,75) y
**raíz cónica de Ø4,4 en 1,5 mm** en vez de ángulo vivo (Kt de 1,8 a 1,2).
Juntas, de 0,5 a 2,4 kg.

**El acuerdo cóncavo de toda la vida no cabía.** Dos de R1,2 separados 5,6 mm se
tocan entre sí y se salen del hombro, y el rebaje que el cabezal necesitaría para
librarlos se comería la corona de apoyo entera — que es la única razón por la que
esta unión existe. La raíz cónica hace el mismo trabajo y el taladro del cabezal
la copia sin rebaje ninguno: sale gratis.

### El techo del concepto, por escrito

Con el cuerpo en Ø12, para que al cabezal le queden 1,1 mm de pared por fuera de
cada taladro y 1,45 de alma entre los dos, hace falta que separación ≥ Ø + 1,65 y
que separación + Ø ≤ 9,7. **La espiga no puede pasar de Ø4,0.** Ahí se acaba lo
que se puede reforzar sin cambiar de idea.

Así que la v10 se queda como la unión más frágil de las diez por un factor de
casi cuatro, y eso pasa al README y a la tabla de portada. Sigue teniendo la
mayor corona de apoyo —**53,5 mm²**, ha subido al separarse más las espigas— pero
la v6 da el 90 % de esa cifra con una parte macho maciza. Para casi todo el
mundo, la v6 es mejor opción.

Verificado: interferencia 0,0000 mm³; raíz medida sobre la malla Ø4,387 → Ø4,000
en 1,6 mm; garganta a Ø3,520; pared del cabezal 1,08–1,11 y alma 1,41; lengüetas
libres y boca entera comprobadas por sondeo; corona 53,46 mm². La lengüeta baja a
1,1 de pared, así que trabaja al 0,67 % en vez del 0,49 %, y sigue holgada porque
es tracción dentro de la capa.

---

## v10.3 — La v10 se rompió al imprimirla · 9 de septiembre de 2026

Jorge imprimió la v10.0. **Al apretarla mínimamente con las manos se partieron
los brazos**: primero medio brazo de cada espiga, y al sacar el cabezal, el que
quedaba. Se pudo montar «con una pata y media».

### Qué falló, y qué decía la ficha

La ficha de la v10.0 prometía 0,56 % de deformación de trabajo. **Era falso, por
dos errores míos en el mismo cálculo:**

1. Tomé como voladizo los 9 mm de ranura, cuando lo que trabaja es la distancia
   del arranque de la ranura al centro de la pestaña: 6,2 mm. Y la deformación va
   con el cuadrado del voladizo.
2. Traté la sección como un rectángulo de 1,2 mm de espesor. No lo es: es un
   **segmento circular**, y su fibra exterior está a 0,70 mm del centroide, no a
   0,60. Con 2,86 mm² de área.

El número real es **1,37 %**.

**Pero el fallo de fondo era la dirección, no el número.** El brazo es un
voladizo vertical en una pieza que se imprime de pie, así que la tracción va
**entre capas**, y ahí el PLA rompe alrededor del 1 %. Con 1,37 % no había
margen, y la pieza hizo exactamente lo que dicen los números.

### La regla que sale de aquí

**Lo que flexa va en el CABEZAL, no en el mango.** El mango se imprime de pie:
cualquier voladizo suyo flexa entre capas. El cabezal se imprime tumbado sobre su
cara de lijado, así que una lengüeta suya que flexe hacia los lados trabaja
dentro del plano de la capa, que es donde el PLA sí aguanta.

Es una regla de este proyecto, no general, y sale de la orientación de impresión
que se decidió el primer día. Va al apartado 7 del README, con las otras trampas.

### La v10.1

- **Espigas macizas**: 9,08 mm² cada una, sin ranura, sin nada que romper. Llevan
  una garganta de 0,24 de profundidad.
- **Dos lengüetas en el cabezal**, formadas por la pared exterior sobre cada
  taladro y liberadas por dos ranuras que arrancan a 2 mm de la boca — esos 2 mm
  intactos son los que salvan la corona de apoyo.
- Las espigas pasan a separarse en el eje que en el cabezal impreso es el
  **horizontal**, para que las lengüetas caigan en los costados y no en la cara
  que apoya en la cama.
- **La lengüeta abre 0,105 mm, no 0,18.** La pestaña sobresale 0,18 dentro de un
  taladro que ya es 0,075 más ancho que la espiga. Con 1,5 de pared, 3,0 de ancho
  y 7,0 de voladizo: **0,49 %**, y en el plano bueno.
- Ese mismo 0,105 es el escalón que retiene. Como la retención sale del ángulo
  del canto y no de su profundidad, el canto de arriba de la garganta se hace
  corto (0,15 para 0,24, unos 64°): retiene sin pedir más recorrido. Se gradúa
  con `esp2_gar_sube`.

Verificado: interferencia 0,0000 mm³; espigas medidas Ø3,400 a y = ±2,70 con
garganta a Ø2,920; corona de apoyo **51,55 mm²**, sigue siendo la mayor de las
diez; lengüetas comprobadas libres por siete sondeos de material/hueco, y la boca
intacta a 0,5 mm. Voladizo en la unión 103,6 mm², en línea con la v2 (97,0), y
son puentes de 3,2 mm.

### De paso, la v5

El mismo método, aplicado al clip de la v5, da **1,9 %** y no el 1,4 % que decía
su ficha. También es tracción entre capas. Se salva porque su brazo tiene
13,2 mm² de sección contra los 2,9 de la v10.0 — y porque su ficha lleva desde el
principio el aviso de imprimirlo en PETG, que ahora se entiende mejor por qué.
Corregido el número en el README.

---

## v10.2 — El visor y el kit de test, al día · 9 de septiembre de 2026

Las dos cosas que quedaban colgando de las cinco uniones nuevas.

**El visor 3D pasa de cinco versiones a diez.** 88 mallas nuevas — 16 por versión
más las piezas sueltas — y 170 empotradas en total. El archivo pasa de 1,3 a
3,0 MB, que sigue siendo un HTML que se abre de doble clic sin servidor ni nada
que descargar.

- Nuevo `web/_empaquetar.py`, que el proyecto no tenía: renderiza lo que falte,
  cuantiza a 16 bits, comprime, y arma `visor_lijador.html` desde la plantilla.
  Sin argumentos sólo hace lo que no está en `meshes.js`, así que regenerar una
  versión no cuesta las otras nueve.
- **La cuña de la v8 y el casquillo de la v9 se ven montados**, en rojo, como
  tercera malla del conjunto. Para eso hizo falta `pieza="extra_puesto"`, que
  saca la pieza suelta ya colocada en el marco del cabezal — y cuatro mallas por
  versión en vez de una, porque ese marco se mueve con el ángulo del cabezal y,
  a 90°, también con su ancho.
- Fichas nuevas para las cinco uniones, y la tabla comparativa **transpuesta**:
  con diez columnas no se leía. Ahora es una fila por unión, y una de las
  columnas es la corona de apoyo.

Verificado sin abrirlo: `node --check` sobre el script de la aplicación y sobre
las mallas, y una simulación de la interfaz que comprueba que las 10 versiones ×
15 cabezales × 3 mangos que la UI puede pedir existen todas, y que las cuatro
colocaciones de pieza suelta se resuelven para los catorce cabezales. Descodificando
las mallas empaquetadas, la cuña de la v8 cae a 7,80 mm de la boca —su `cun_z`— y
el casquillo de la v9 arranca exactamente en el plano de la boca con Ø14,60.

**El kit de test cubre las diez.** El `test_ajuste` de la v8 y la v9 sale ya con
su tercera pieza al lado, y además se genera suelta por si hay que reimprimirla
con otra holgura: es lo único que se toca al calibrar esas dos.

Diez enganches son 26 cm³ y ya no es «un rato», así que `test_rapido.sh` acepta
un subconjunto:

```bash
VERS="v10 v6 v7" ./test_rapido.sh v6
```

Ese trío es el primer corte recomendado: la v10 es la que mejor sale en cualquier
impresora, la v6 la que mejor aguanta el uso y la v7 la única sin holgura que
calibrar. Y sirve de diagnóstico: si sale bien la v10 y mal otra, el problema es
de calibración, no del diseño.

---

## v10.1 — La falda exterior, y por qué no es una mejora universal · 9 de septiembre de 2026

Opción nueva del esqueleto, `falda`, que no es una unión: el cabezal se alarga y
envuelve por fuera un tramo rebajado de la punta del mango. Con `falda = 0` —el
valor por defecto— la geometría de las diez versiones es **idéntica**, verificado
comparando volúmenes de cabezal, test y mango antes y después del parche.

La hipótesis con la que se propuso era «el momento pasa a resistirse en Ø12 en
vez de en Ø8,6, y el basculamiento cae a menos de la mitad». **Medida, resultó
ser medio verdad, y por otra razón.**

```
                  corona      inercia de la corona
v2  sin falda     1,6 mm²          22 mm⁴
v2  CON falda    30,5 mm²         420 mm⁴     ← 19 veces más
v6  sin falda    48,5 mm²         434 mm⁴
v6  CON falda    27,2 mm²         367 mm⁴     ← 15 % menos
v10 sin falda    51,6 mm²         415 mm⁴
v10 CON falda    27,2 mm²         367 mm⁴     ← 12 % menos
```

La falda cambia un disco casi macizo por un anillo: gana radio y pierde área.
A las uniones cuya boca acaba en filo (v2 a v5) las rescata; a las que ya tienen
disco (v6, v10) les quita un poco. **No es una mejora universal, y la primera
versión del cálculo no lo veía porque estimaba la corona en vez de medirla.**

Lo que sí vale para todas es lo otro: sin falda al cabezal lo guía sólo el
taladro —13 mm de base, 0,18 de holgura, 1,59° de bamboleo—; con falda hay dos
guías, una a cada lado del plano de la junta, la base pasa a 19 mm y quedan
0,84°. Ahí sí se cumple lo de «la mitad», pero por alargar la base, no por el
diámetro.

Cuesta 6 mm de herramienta y ~220 mm³ por cabezal.

### El mismo fallo, por tercera vez

La primera versión de la falda tenía `falda_pared` 1,2 y `falda_chaflan` 0,6.
Resultado: contrataladro Ø9,8, avellanado hasta r = 5,5 y borde exterior en
r = 5,2 — **corona negativa, boca en filo otra vez**. Es el fallo de la v2.2 y el
de la v8, y van tres. Con `falda_pared` 1,6, `falda_chaflan` 0,3 y un chaflán de
boca propio de 0,3 en vez del `cuerpo_chaflan` de 0,8, la corona sale de 30,5 mm².

La regla, ya escrita en el README: **la suma del avellanado interior y el chaflán
exterior tiene que dejar anillo.** Es lo primero que hay que comprobar al tocar
cualquier cota de la boca.

### Dos incompatibilidades, comprobadas

- **v7:** la corona de la falda apoyaría en el hombro y le disputaría al cono el
  posicionamiento axial, que es exactamente lo que esa unión evita a propósito.
- **v9:** el cono exterior de la pinza queda enterrado 6 mm dentro de un tubo de
  Ø12 —medido: Ø11,12 a 7 mm de la boca, Ø11,62 a 11 mm— y el casquillo no puede
  llegar a él. Renderiza sin error y no sirve para nada, que es la peor clase de
  fallo.

También se ajustó `plano_efectivo()`: con falda, el plano antirrodadura del mango
doble lo limita la espiga rebajada, que es más gorda que cualquier vástago y
sería lo primero en cortarse.

---

## v10.0 — Doble espiga, y la corona de apoyo medida en las diez · 9 de septiembre de 2026

Décima unión: dos espigas de Ø3,4 separadas 5,4 mm, cada una partida en dos
brazos con una pestaña de 0,25 que hace clic. Reparte el trabajo — las espigas
orientan y aguantan par y cortante, las pestañas sólo retienen — y deja que
quien impida bascular sea el hombro.

- **51,6 mm² de corona de apoyo, la mayor de las diez.** Cambiar un taladro de
  Ø8,6 por dos de Ø3,55 convierte la boca del cabezal de un anillo fino en un
  disco casi macizo. La v2 tiene 1,6.
- **La más fácil de imprimir bien:** dos postes redondos y dos agujeros
  redondos. Sin hélices, destalonados, tetones en canal ni paredes finas.
- Brazos al **0,56 %** de deformación contra el 1,4 % del clip de la v5: flexar
  está repartido entre cuatro brazos en vez de dos.
- Simétrica: entra en dos posiciones giradas 180°.
- Espigas separadas en el eje que en el cabezal impreso es el vertical, para que
  su par de fuerzas se oponga a la flexión de la presión de lijado.
- Juego de giro 1,6° (holgura ÷ semiseparación). Con `esp2_holgura` a 0,05, 1,1°.
- Lo que cuesta: espigas esbeltas. Mientras apoye la corona da igual; haciendo
  palanca de verdad, Ø3,4 es lo que hay.

### La medición que cazó un fallo en la v8

Para poder afirmar lo de los 51,6 mm² había que medirlo, y medirlo en las diez.
Integrando sobre la malla el material del cabezal en el plano de la boca,
recortado a lo que alcanza el hombro:

```
v10 doble espiga .... 51,6 mm²      v4  imán ............  8,9 mm²
v6  cola de milano .. 48,4 mm²      v9  pinza ...........  8,5 mm²
v1  hexágono ........ 25,5 mm²      v2  bayoneta ........  1,6 mm²
v5  clip ............ 13,4 mm²      v3  rosca ...........  0,0 mm²
v8  cuña ............ 13,2 mm²      v7  cono ............  0,0 mm²  (a propósito)
```

**La v8 salía con 0,63 mm².** El avellanado de su boca era de 0,8 y se comía el
borde que deja `cuerpo_chaflan`: la boca acababa en filo, exactamente el fallo
que costó la v2.2 — y en la unión donde más duele, porque el hombro es contra lo
que aprieta la cuña. Corregido con un parámetro propio, `cun_avell` = 0,4: 13,2
mm² de cara plana. La v8 pasa a 8.1.

Los ceros de la v3 y la v7 no son iguales: el de la v7 es de diseño, porque ahí
posiciona el cono y el hombro tiene prohibido tocar.

Verificado: interferencia 0,0000 mm³ en la v8 corregida y en la v10 (contacto de
corona, espesor nulo). Espigas medidas sobre la malla: Ø3,400 a x = ±2,70,
pestaña de 0,248. Todas las piezas `Simple: yes`. Voladizo en la unión 69,1 mm²,
por debajo de la v2 (97,0).

`stl/v10/test_ajuste.stl` listo. Sin imprimir todavía.

---

## v9.0 — Pinza cónica · 9 de septiembre de 2026

Novena unión: una pinza de portaminas. La boca del cabezal partida en cuatro
dedos por ranuras axiales, exterior cónico 1:8, y un casquillo de Ø14,6 × 6 mm
(355 mm³) que se empuja con el pulgar y los cierra sobre el vástago.

Hace lo mismo que la v8 —apriete regulable que no se agota— **sin pieza que se
pueda perder**: el casquillo no puede pasar al mango por detrás (taladro trasero
Ø11,05 contra un mango de Ø12) ni al cuerpo del cabezal por delante. Sólo sale
con el cabezal desmontado.

- 2 mm de recorrido, 0,125 mm de cierre de diámetro por milímetro. La unión se
  reaprieta durante toda la vida de la herramienta.
- Deformación de trabajo del dedo: **0,4 %**. Cierra 0,075 mm sobre un voladizo
  útil de 6 mm con 1,3 de pared. El clip de la v5 trabaja al 1,4 %.
- Cada ranura acaba en un taladro de alivio de Ø1,4, que es lo que evita que el
  dedo agriete donde la ranura moriría en ángulo vivo.

**La pinza va en el cabezal y no en el mango, y hubo que decidirlo antes de
modelar nada.** Con la pinza en el mango los cabezales necesitarían un vástago
macho saliendo en horizontal de la boca y dejarían de imprimirse planos sobre su
cara de lijado — la decisión de la que cuelga el proyecto entero. Invertida, sale
gratis: el mango queda como un cilindro liso de Ø8,6, el más simple de las nueve
versiones, y cualquier cabezal se puede montar sobre cualquier varilla de ese
diámetro.

**Lo que cuesta:** un collar de Ø14,6 en una herramienta de Ø12, y cuatro ranuras
abiertas en el cabezal que recogerán polvo.

### El chaflán que se comió la pieza

`difference() { cylinder(d=14,6, h=6); ... cylinder(r1=R+0,5, r2=R−0,5, h=0,5); }`
parece un chaflán y no lo es: en z=0 el radio de ese cono es mayor que el de la
pieza, así que el primer plano del casquillo desaparece entero. La envolvente lo
cantó —5,51 mm de alto en una pieza de 6— pero a ojo, en el render, no se veía.
Un chaflán se resta como **anillo**: la diferencia entre un cilindro grande y el
cono, no el cono a secas.

Verificado: casquillo ∩ cabezal y casquillo ∩ mango, las dos intersecciones
vacías con el casquillo en reposo; cabezal ∩ mango = 0,0 mm³ (contacto de corona,
espesor nulo). Cono exterior medido sobre la malla: 0,125 mm/mm, exacto. Todas
las piezas `Simple: yes`. Voladizo en la unión 101,3 mm², en línea con la v2
(97,0) y la v8 (95,4).

`stl/v9/test_ajuste.stl` incluye el casquillo. Sin imprimir todavía.

---

## v8.0 — Espiga y cuña transversal · 9 de septiembre de 2026

Octava unión, y la primera con **tres piezas**: mango, cabezal y una cuña de
13,6 × 5 × 2,6–3,2 mm (177 mm³). La de carpintería de siempre, a escala de
bolígrafo.

El vástago lleva una ranura transversal y el cabezal un túnel alineado. La cuña
los atraviesa: apoya abajo en el suelo del túnel del cabezal y arriba en el techo
de la ranura del vástago, y como es cónica 1:12, empujarla separa esas dos caras
y tira del vástago hacia dentro, apretando el cabezal contra el hombro.

- **Apriete regulable, que es lo que ninguna otra tiene.** No lo fija un número
  del modelo: lo fijas empujando. 7,2 mm de recorrido por delante. Si dentro de
  un año baila, se empuja medio milímetro más en vez de reimprimir catorce
  cabezales.
- **La cuña es también la chaveta**, así que el taladro puede ser un cilindro
  liso. Con 13,6 mm de largo, sus 0,08 de holgura lateral sólo permiten 0,34° de
  descuadre: lo que fija el giro es el largo de la cuña, no su ajuste.
- **La cuña es el fusible.** Aguanta ~90 N de precarga antes de doblarse y la
  ventaja mecánica es 12:1, así que es lo que rompe si te pasas apretando. Es la
  pieza más barata de reimprimir del proyecto, y prefiero que ceda ella.

### El coste, medido en vez de estimado

Es la unión que más debilita el cabezal, y merecía números en vez de adjetivos.
Sección del cuerpo en la banda del túnel contra la sección intacta, integrando
sobre la malla:

```
                            área      I (presión de lijado)   I (lijando de lado)
intacta, a 4 mm de la boca  49,3 mm²        659 mm⁴                706 mm⁴
en la banda de la cuña      32,7 mm²        621 mm⁴                288 mm⁴
pérdida                        34 %           5,7 %                   59 %
```

**La orientación del túnel resultó ser la buena por una razón que no era la que
me llevó a ella.** Se eligió porque así los flancos salen verticales al imprimir;
resulta que además el túnel quita material del eje neutro para la flexión que
produce la presión de lijado —la carga dominante— y sólo cuesta 5,7 % de inercia.
Girado 90° sería exactamente al revés. Como el momento en la banda es el 75 % del
de la boca, lijando de plano la banda trabaja al 0,80 de lo que trabaja la boca:
**no es la sección crítica.** Lijando de lado sí lo es, a ~1,8 veces la tensión
de la boca, pero ahí las fuerzas son de rozamiento, no de presión.

El túnel está a 7,8 mm de la boca: lo más adentro posible sin llegar a los 13 mm
donde arranca el cuello de la pala.

### El esqueleto ahora admite piezas sueltas

Una unión de tres piezas no cabía en el generador. Se añaden dos módulos
opcionales, vacíos en las otras seis: `junta_extra()` saca la pieza tumbada para
imprimir con `pieza="extra"`, y `junta_extra_montado()` la coloca en el marco de
la boca. El `test_ajuste` la incluye al lado del macho y la hembra, y el
`conjunto` la pinta montada. v2–v7 regeneradas y verificadas sin cambios.

Verificado: cuña ∩ cabezal = intersección vacía; cuña ∩ mango = 0,0 mm³ con
contacto en las dos caras de trabajo; cabezal ∩ mango = vacía. Todas las piezas
`Simple: yes` y estancas. Voladizo en la unión 95,4 mm², prácticamente el mismo
que la v2 (96,9), que ya está impresa y sale bien.

`stl/v8/test_ajuste.stl` incluye la cuña. Sin imprimir todavía.

---

## v7.0 — Cono autoblocante · 9 de septiembre de 2026

Séptima unión: un cono de 12° de semiángulo, Ø8,4 × 9 mm, con dos planos de
chaveta. Es la v1 hecha bien.

**Sin holgura que calibrar, que es todo el argumento.** Un cilindro necesita
hueco para entrar y ese hueco es el juego con el que baila después; un cono se
para donde le deja la interferencia y queda tocando en toda la superficie. El
error de impresión se convierte en profundidad de asiento en vez de en juego.

- Autorretenedor: 12° está por debajo del ángulo de rozamiento del PLA (~17°).
  Queda firme y sale de un tirón; a 7° agarraría más pero habría que golpearlo.
- Los planos de chaveta son **cónicos** también: escalan con el cono y aprietan
  con él, así que el giro tampoco tiene juego. Unos planos paralelos al eje se
  separarían de su cara en cuanto la profundidad de asiento variase.
- El cabezal **no apoya en el hombro**: quien posiciona es el cono. El chaflán
  frontal sube a 1,7 mm para que la punta del mango (Ø8,60) y el anillo de la
  boca (Ø9,63) no puedan tocarse.

**La contrapartida, sin adornos:** la profundidad de asiento depende del ajuste
—0,47 mm por cada 0,1 mm de error radial— y como un taladro impreso en
horizontal sale estrecho, lo esperable es medio milímetro de junta entre las dos
piezas. No afecta a cómo sujeta y `con_retro` la cierra.

### Tres cosas que sólo salieron al medir

**El taladro estaba desplazado al revés.** `translate([0,0,-con_asiento])` sobre
un cono que se estrecha lo hace más *estrecho* en la boca, no más ancho: 10,4 mm³
de interferencia repartidos por toda la superficie cónica, que es justo el
número que sale de multiplicar 0,049 mm por los 271 mm² de la generatriz.

**A 7° la profundidad de asiento se movía el doble.** Con 0,1 mm de error radial
el cabezal se iba 0,81 mm; a 12° son 0,47. Y el ángulo pequeño multiplica por 8
la fuerza de cuña sobre una pared de 1,6 mm. Subir a 12° cuesta muy poco agarre
—sigue muy por debajo del ángulo de rozamiento— y arregla las dos cosas.

**El cuello era un cilindro y se comía los planos.** El rebaje que hay antes del
cono, para que la boca del cabezal pueda pasar si el ajuste sale suelto, era un
cilindro de revolución: invadía la zona de los planos del taladro (2,5 mm³ de
interferencia, todos en el primer milímetro) y de paso dejaba ahí la sección más
débil de la pieza. Ahora es el mismo perfil rebajado 0,3 mm en radio, con enlace
a 45° para no dejar voladizo al imprimir el mango.

Verificado: `pieza="interferencia"` = 0,0004 mm³ — macho y hembra son
literalmente el mismo cono. Semiángulo medido sobre la malla: 12,00°. Planos a
3,193 mm en la base contra 3,193 de diseño. Todas las piezas `Simple: yes`.
Y menos voladizo en la unión que la v2: 54,8 mm² contra 96,9, porque el cono es
más corto y más estrecho que el vástago de la bayoneta.

`stl/v7/test_ajuste.stl` listo. Sin imprimir todavía.

---

## v6.0 — Cola de milano transversal · 8 de septiembre de 2026

Sexta unión, y la primera que no se enchufa: el cabezal **desliza de lado** sobre
un carril de cola de milano en la punta del mango.

La pregunta de la que sale es «¿qué enganche aguanta el movimiento de lijar en
todas las direcciones?». Las cinco anteriores resisten el desmontaje; ésta lo
evita: empujar y tirar actúan a lo largo del mango, girar alrededor de él, y el
cabezal sale perpendicular a las dos. El gesto de lijar no puede desmontarlo.

Carril de 7,0 × 5,0 mm, flancos a 12° de la vertical, recorrido de 7,9 mm.

- **El tirón lo aguanta la forma.** El destalonado de 12° hay que romperlo para
  separar las piezas. No depende del rozamiento (v1, v4), ni de un brazo elástico
  que se fatiga (v5), ni de que la holgura siga siendo la del primer día. Un
  carril tampoco gira dentro de su ranura.
- **Cónico:** la cresta se estrecha 0,7 mm de la entrada al tope (0,095 mm/mm) y
  la ranura del cabezal igual. Entra suelta y sólo aprieta en el último
  milímetro; por el ángulo del milano, ese apriete empuja el cabezal contra el
  hombro. Misma cuña autoblocante que la bayoneta de la v2, en línea recta.
- **Retención en el sentido del deslizamiento:** tope duro por delante y resalte
  de 0,10 mm en la entrada del carril por detrás. Para pasarlo el cabezal se
  levanta ~0,45 mm del hombro, así que se nota como un clic. Va en la ENTRADA a
  propósito: sólo queda cubierto en los últimos 1,5 mm y no roza durante todo el
  recorrido, que es lo que pasaría con el resalte en cualquier otro sitio.

**Nació imposible de imprimir.** Con la unión en su orientación natural —el
cabezal entrando de lado— los flancos del milano quedan a 12° de la *horizontal*:
un voladizo de 78° de 105 mm², y justo sobre la superficie de ajuste. Girando la
unión 90° sobre el eje de la herramienta (`cm_orient = 90`) los flancos salen
verticales, el cabezal baja a 1,6 mm² de voladizo en la zona de la unión (la v2
tiene 4,6) y, de propina, la presión de lijado pasa a meter el cabezal contra su
tope en vez de sacarlo. El parámetro sigue ahí por si alguien prefiere el
deslizamiento lateral y no le importa poner soportes.

Y un corolario del espejo entre marcos que no estaba documentado: **para girar
una unión sobre el eje hay que girar macho y hembra en sentidos contrarios.** Con
el mismo signo, la parte simétrica encaja y la conicidad sale invertida.

Verificado: `pieza="interferencia"` da 0,0001 mm³ con `cm_aprieto = 0` (macho y
hembra casan exactos) y 1,08 mm³ con los valores por defecto, que es el apriete
buscado. Mango, cabezal y `test_ajuste` salen `Simple: yes` y estancos. Medido
sobre la malla: destalonado de 1,95 mm en 4,8 de altura (12,0°), conicidad de
0,095 mm/mm creciendo hacia el tope, y resalte de 0,10 mm por flanco entre
x = −3,97 y −2,97.

`stl/v6/test_ajuste.stl` listo para imprimir. Falta imprimirla: es la única
versión de la familia que todavía no ha pasado por la cama.

---

## Los scripts de render fallaban en silencio · 8 de septiembre de 2026

`./render.sh v2` recorría las 18 piezas, no escribía ni un fichero y terminaba
diciendo «Listo»: la llamada a OpenSCAD acabab en `2>&1 | grep -E "ERROR" || true`,
que se traga también el «command not found».

- Los dos scripts comprueban que OpenSCAD existe antes de empezar, y que cada STL
  se ha escrito y no está vacío. Si falta algo, salen con código 1.
- Nuevo `render.ps1`: el mismo render desde PowerShell, sin Git Bash ni WSL, con
  búsqueda de `openscad.exe` en el PATH y en las rutas de instalación normales.
- Calidad final pasa de `$fn=96` a **64**. En un cilindro Ø12 el error de facetado
  es de 0,007 mm contra 0,003 — los dos muy por debajo de lo que puede expresar una
  boquilla de 0,4 — y con 96 el mango tarda tres veces más en resolver los booleanos
  (más de tres minutos por pieza).

Y renderizadas las 18 piezas de la v2.2 a `stl/v2/`: 88,7 cm³, las 18 estancas
(0 aristas de borde, 0 no-manifold) y dentro de 180 × 180 × 180 mm.

---

## v2.2 — El cabezal no llegaba a apoyar en el hombro · 8 de septiembre de 2026

Con la v2.1 impresa, el `test_ajuste` sujetaba bastante mejor que el `mango_corto`.
La unión es idéntica en las dos piezas, así que la diferencia tenía que estar en el
hombro. Medido sobre las mallas, el radio hasta donde llega material en el plano de
la boca:

```
                        arranca la cara     borde exterior    hombro del mango
v1 hexágono ........... r = 3,95            r = 5,20          4,30 – 5,00   apoya
v2 bayoneta ........... r = 5,28            r = 5,20          4,30 – 5,00   NO
v3 rosca .............. r = 5,40            r = 5,20          4,30 – 5,00   NO
v4 imán ............... r = 5,50            r = 5,20          4,30 – 5,00   NO
v5 clip ............... r = 5,30            r = 5,20          4,30 – 5,00   NO
```

En las cuatro últimas el avellanado de la boca es más ancho que el borde que deja
el `cuerpo_chaflan`: **no hay cara plana, la boca acaba en filo**, un anillo vivo a
r = 5,24 y 0,04 mm por dentro del plano. Y el `mango_chaflan_frontal` de 1,0 mm
dejaba el hombro en r = 5,00, así que ese filo caía sobre el chaflán, 0,28 mm por
debajo: no se tocaban. El cabezal iba en voladizo sobre el vástago, sujeto sólo por
el tetón, y el par de lijar lo hacía bascular dentro de la holgura.

El tapón del `test_ajuste` es un cilindro Ø12 a secas, sin chaflán: apoya en todo
el anillo. Por eso engañaba.

- v2: `mango_chaflan_frontal` 1,0 → **0,3**, en el bloque de la v2, no en el
  esqueleto. Hombro hasta r = 5,70: el filo del cabezal cae dentro del plano, con
  0,04 mm nominales de separación que la tolerancia de impresión cierra.
- v2: `ergo_d_frente` 11 → **11,6**. El mango ergonómico arranca más fino que el
  recto, así que con el chaflán se quedaba en r = 5,20 — 0,04 corto — y era el
  único de los tres que seguía sin apoyar.
- En la variante **doble** la culata también es un hombro: pasa a llevar el chaflán
  frontal en los dos extremos, no el de 1,5 mm. Esto sí toca las cinco versiones,
  pero sólo a esa variante de mango.

Los tres mangos de la v2, medidos sobre la malla (borde del cabezal, r = 5,24):

```
recta ........ hombro r = 4,30 – 5,70   apoya
ergonómica ... hombro r = 4,30 – 5,50   apoya  (antes 5,20)
doble ........ hombro r = 4,30 – 5,70   apoya
```

**Sólo cambia el mango de la v2.** Los cabezales no cambian, y las otras cuatro
versiones sólo cambian si imprimes el mango doble.

Pendiente: el apoyo de la v2 sigue siendo un filo, no una cara. Convertirlo en un
anillo plano de 0,3-0,7 mm pide bajar `cuerpo_chaflan` de 0,8 a 0,4 — y eso ya es
reimprimir los catorce cabezales, así que espera a que haya más motivos para
hacerlo.

Lección para el `test_ajuste`: reproduce la unión, pero no el hombro real del
mango. Vale para calibrar holguras, no para juzgar cuánto agarra.

---

## v2.1 — La bayoneta deja de aflojarse · 8 de septiembre de 2026

Lijando de lado, la v2.0 se soltaba. La causa no era la cuña sino el juego axial
del canal, que estaba fijado a mano en 0,15 mm:

```
espesor del tetón .................. 2,60 mm
alto del canal en el asiento ....... 2,72 mm   →  0,12 mm de flotación
alto del canal bajo la muesca ...... 2,66 mm   →  aprieto real  −0,06 mm
```

Es decir: el tetón flotaba, la cuña no llegaba a apretar contra nada y la muesca
de retención pasaba por debajo sin tocarla. El «clic» era el rozamiento de las
paredes, no un resalte. Un par alterno — que es exactamente lo que hace lijar de
izquierda a derecha, 10-15 N a 5,5 mm del eje ≈ 55-80 N·mm — se lo lleva por
delante en unas cuantas pasadas.

Cambios, todos en la parte macho:

- `bay_juego_ax` deja de estar escrito a mano en `bay_ranura()` y pasa a ser
  parámetro, con valor **0,05**. El tetón queda pinzado (0,02 mm de holgura).
- `bay_muesca` 0,06 → **0,18**. Ahora muerde 0,16 mm reales: salir del asiento
  exige deformar el vástago, no vencer un rozamiento.
- `bay_rampa` 0,25 → **0,40**, más recorrido de cuña con el que precargar.

**Sólo hay que reimprimir el mango**: el cabezal no cambia ni un micrómetro.

Descartado por el camino: dientes rígidos en el hombro. Sacar un diente de 0,5 mm
exige separar el cabezal 0,5 mm, y el canal cerrado sólo da 0,12; desenroscar para
ganar hueco tampoco vale, porque la hélice del canal sube 5,4° y el flanco del
diente 60°. Sería un bloqueo mutuo: se monta y no sale. Con dientes rígidos el
desmontaje tendría que ser «tirar y girar», con muelle o imán — anotado como
posible v7.

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
