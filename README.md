# Sanding Stick — lijador modular paramétrico

Mango tipo bolígrafo + 14 cabezales intercambiables, para lijar impresiones 3D y
filigranas en madera. Impreso en Bambu Lab A1 Mini (180 × 180 × 180 mm).

**Diez versiones. Lo único que cambia entre ellas es cómo se engancha el cabezal.**
Formas, anchos, mangos y orientación de impresión son idénticos en las diez.

| | Unión | Gesto de cambio | Aguanta el tirón | Comprar algo |
|---|---|---|---|---|
| **v1** | Hexágono 6 AF a presión | tirar y empujar | regular | no |
| **v2** | Bayoneta de 1/4 de vuelta | meter y girar 90° | **sí, bloqueo axial** | no |
| **v3** | Rosca cuadrada Ø8 × paso 2 | 3 vueltas | **sí** | no |
| **v4** | Imán Ø6×3 + espiga en D | acercar | se separa al tirar | **15 imanes** |
| **v5** | Clip elástico de dos brazos | empujar hasta el clic | sí, hasta cierta fuerza | no |
| **v6** | Cola de milano transversal | deslizar hasta el clic | **sí, por geometría** | no |
| **v7** | Cono autoblocante de 12° | empujar y tirar | sí, por rozamiento | no |
| **v8** | Espiga y cuña transversal | meter y empujar la cuña | **sí, y regulable** | no |
| **v9** | Pinza cónica de cuatro dedos | meter y empujar el casquillo | **sí, y regulable** | no |
| **v10** | Doble espiga con clic | empujar hasta el clic | sí, hasta cierta fuerza | no |

**Si sólo vas a imprimir una: la v2.** Es la única *probada* que combina cambio
rápido con bloqueo axial real, y no depende de comprar nada ni de que un brazo
elástico aguante mil ciclos.

**Si lo que te preocupa es que el cabezal se afloje lijando: la v6.** Es la única
cuya dirección de desmontaje no coincide con ninguna dirección de trabajo, y la
única en la que el tirón lo aguanta la forma —un destalonado— y no el rozamiento
ni un brazo elástico.

**Si no quieres calibrar nada: la v7.** Es la única sin holgura que acertar: un
cono se para donde le deja la interferencia y queda tocando en toda la
superficie, así que el error de impresión se convierte en profundidad de asiento
en vez de en juego. Sujeta por rozamiento, como la v1, pero sin el juego que
hace que la v1 se afloje.

**Si quieres poder reapretarla dentro de un año: la v8.** Es la única cuyo
apriete no lo fija un número del modelo sino cuánto empujas la cuña, con 7 mm de
recorrido por delante. A cambio es la que más debilita el cabezal.

La v9 hace lo mismo que la v8 sin pieza que se pueda perder, pero es la más
voluminosa y la que más pieza tiene que imprimir.

**Si tu impresora va justa: la v10.** Dos postes redondos y dos agujeros
redondos, que es lo que mejor le sale a una FDM. Ni hélices, ni destalonados, ni
paredes finas. Y es la que más superficie de apoyo tiene contra el hombro, que
es lo que de verdad impide que el cabezal bascule (ver la tabla del apartado 2).

Las v6 a v10 son nuevas y todavía no han pasado por la cama: empieza por su
`test_ajuste`.

Abre `visor_lijador.html` en el navegador para verlas y compararlas en 3D: están
las diez, con las tres piezas de la v8 y la v9 montadas. Se regenera con
`python3 web/_empaquetar.py` (sólo renderiza lo que falte; `--todo` desde cero).

---

## 1. Archivos

```
sanding_stick/
├── scad/
│   ├── sanding_stick.scad        v1 · hexágono a presión
│   ├── sanding_stick_v2.scad     v2 · bayoneta
│   ├── sanding_stick_v3.scad     v3 · rosca
│   ├── sanding_stick_v4.scad     v4 · imán
│   ├── sanding_stick_v5.scad     v5 · clip elástico
│   ├── sanding_stick_v6.scad     v6 · cola de milano transversal
│   ├── sanding_stick_v7.scad     v7 · cono autoblocante
│   ├── sanding_stick_v8.scad     v8 · espiga y cuña
│   ├── sanding_stick_v9.scad     v9 · pinza cónica
│   ├── sanding_stick_v10.scad    v10 · doble espiga
│   └── _generar_versiones.py     genera v2–v10 desde un esqueleto común
├── render.sh                     genera los STL de una versión o de todas (bash)
├── render.ps1                    lo mismo desde PowerShell, para Windows
├── test_rapido.sh                genera el kit de test mínimo → stl_test/
├── TEST_RAPIDO.md                qué imprimir para elegir enganche y formas
├── visor_lijador.html            visor 3D interactivo con las diez versiones (3 MB)
├── stl/                          STL a calidad final
├── preview_stl/vN/               18 piezas por versión, calidad de trabajo
├── png/                          renders de cada pieza
├── web/
│   ├── plantilla.html            el visor sin las mallas
│   ├── meshes.js                 170 mallas cuantizadas y comprimidas
│   └── _empaquetar.py            renderiza lo que falte y arma el visor
├── sanding_stick_v1.0.zip        instantánea congelada de la v1
├── sanding_stick_v1-v5.zip       instantánea de las cinco versiones
└── CHANGELOG.md · FUENTES.md · PUBLICAR.md · README.md · LICENSE
```

`preview_stl/` y `png/` no van al repositorio: se regeneran con `./render.sh`.
Sí están versionadas las diez piezas de calibración (`stl/vN/test_ajuste.stl`),
que es lo primero que hay que imprimir, guardadas como STL binario.

## 2. Lo que comparten las diez versiones

**El cabezal tiene que apoyar en el hombro del mango.** Es lo que impide que
bascule al lijar: sin apoyo va en voladizo sobre el vástago y el par lo mueve
dentro de la holgura. El hombro llega hasta Ø(12 − 2·`mango_chaflan_frontal`) y la
boca del cabezal acaba en Ø10,48 — así que **el chaflán frontal es un parámetro de
la unión, no un detalle estético**, y cada versión lo ajusta al avellanado de su
propia boca (la v2 lo baja a 0,3; la v1 apoya de sobra con 1,0).

Cuánta corona apoya de verdad en cada versión, integrado sobre la malla en el
plano de la boca y recortado a lo que alcanza el hombro:

| | Corona | |
|---|---:|---|
| **v10** doble espiga | **51,6 mm²** | dos taladros de Ø3,55 en vez de uno de Ø8,6 |
| **v6** cola de milano | **48,4 mm²** | la ranura ocupa poco del plano de la boca |
| v1 hexágono | 25,5 mm² | |
| v5 clip | 13,4 mm² | los dos planos dejan material cerca del eje |
| v8 cuña | 13,2 mm² | con `cun_avell` = 0,4 |
| v4 imán | 8,9 mm² | el plano de la chaveta en D |
| v9 pinza | 8,5 mm² | |
| v2 bayoneta | 1,6 mm² | apoya en filo, no en cara |
| v3 rosca | 0,0 mm² | |
| v7 cono | 0,0 mm² | **a propósito**: posiciona el cono, no el hombro |

Las tres últimas explican por sí solas por qué la v2 se aflojaba: su avellanado
de boca es más ancho que el borde que deja `cuerpo_chaflan`, así que la boca
acaba en filo y no en cara. Arreglarlo del todo pide bajar `cuerpo_chaflan` de
0,8 a 0,4, y eso son catorce cabezales a reimprimir — sigue pendiente. Las
versiones nuevas nacen ya con el avellanado ajustado.

### La falda exterior — `falda = 6`

Opción del esqueleto, no una versión: el cabezal se alarga 6 mm y envuelve por
fuera un tramo rebajado de la punta del mango (espiga Ø8,8, contrataladro Ø9,0).
Se activa con un parámetro y **vale para ocho de las diez uniones**:

```bash
openscad -o pala.stl -D 'pieza="cabezal"' -D falda=6 scad/sanding_stick_v2.scad
```

Hace dos cosas, y sólo una de ellas es un regalo:

**1 · Le devuelve la corona a las uniones que la tienen en filo.** Medido:

| | Corona | Inercia de la corona |
|---|---:|---:|
| v2 sin falda | 1,6 mm² | 22 mm⁴ |
| **v2 con falda** | **30,5 mm²** | **420 mm⁴** — 19 veces más |
| v6 sin falda | 48,5 mm² | 434 mm⁴ |
| v6 con falda | 27,2 mm² | 367 mm⁴ — un 15 % menos |
| v10 sin falda | 51,6 mm² | 415 mm⁴ |
| v10 con falda | 27,2 mm² | 367 mm⁴ — un 12 % menos |

Es decir: **rescate para la v2 a v5, y ligera pérdida para la v6 y la v10.** La
falda cambia un disco casi macizo por un anillo: gana radio y pierde área, y a
las que ya tenían disco no les compensa. No es una mejora universal.

**2 · Reduce a la mitad el basculamiento por holgura, y eso sí vale para todas.**
Sin falda, al cabezal lo guía sólo el taladro: 13 mm de base con 0,18 de holgura
son 1,59° de bamboleo. Con falda hay dos guías separadas, una a cada lado del
plano de la junta, y la base pasa de 13 a 19 mm: 0,84°.

**Lo que cuesta:** 6 mm más de herramienta y ~220 mm³ por cabezal (3,1 cm³ en los
catorce).

**No vale para la v7 ni para la v9.** En la v7 la corona de la falda apoyaría en
el hombro y le disputaría al cono el posicionamiento axial, que es justo lo que
esa unión evita a propósito. En la v9 es peor: el cono exterior de la pinza queda
enterrado 6 mm dentro de un tubo de Ø12 —medido, Ø11,12 a 7 mm de la boca— y el
casquillo no puede llegar a él.

Dos cotas de la falda están donde están por una razón, y las dos son el mismo
fallo de siempre: `falda_chaflan` no puede pasar de 0,3 ni `falda_ch_boca` de
0,3, porque con 0,6 y 0,8 los dos avellanados se comen la corona entera y la
boca vuelve a acabar en filo. `falda_pared` tampoco puede subir de 1,6: el
contrataladro tiene que ser más ancho que la hembra de la junta o no se puede
llegar a ella.

**La parte macho va en el mango y la hembra en el cabezal.** Es la decisión que
condiciona todo lo demás:

- Todos los cabezales se imprimen **planos, con la cara de lijado sobre la cama**.
  Esa cara sale lisa y perfectamente plana, que es lo que necesita para pegar la lija.
- Ningún cabezal necesita soportes en ninguna de las cinco versiones.
- El cuerpo del cabezal es Ø12 × 16 mm, enrasado con el mango, con el eje a 5,5 mm
  de la cama: eso deja un plano de apoyo de ~5 mm y se imprime estable.

**Catálogo de cabezales** (7 formas × 2 anchos):

| Cabezal | Cara útil | Para qué |
|---|---|---|
| Pala plana 0° | 16×40 / 8×40 | caras grandes, líneas de capa, planos largos |
| Pala 45° | 16×25 / 8×25 | chaflanes, romper aristas |
| Taco 90° | 16×16 / 8×16 | fondos y rincones, lijando a empuje |
| Triángulo | punta 30 / 22 mm | esquinas interiores, calados de marquetería |
| Prisma 3 caras | 3 caras de 16 / 8 | ranuras en V, molduras; tres caras útiles |
| Media caña convexa | R8 / R4 | interiores curvos, gargantas |
| Canal cóncavo | canal Ø12 / Ø5 | varillas, barrotes, cantos redondeados |

Cuando la cara es de 8 mm y el mango de 12, la paleta lleva un **hombro** que la
ensancha hasta Ø12 junto al cuerpo: refuerza el cuello, que es donde rompería.

**Tres mangos**, los tres compatibles con cualquier cabezal de su versión:

| | Envolvente | Volumen | Cómo se imprime |
|---|---|---|---|
| **recta** | Ø12 × 137 | 14,2 cm³ | de pie, con balsa |
| **ergonomica** | Ø11–14 × 137 | 15,2 cm³ | de pie, con balsa |
| **doble** | 149 × 12 × 9 | 11,9 cm³ | tumbado sobre la cara plana |

La variante doble tiene la parte macho en los dos extremos y un plano lateral: se
imprime en 9 mm de alto en vez de una torre de 137 mm, no rueda por la mesa y lleva
dos cabezales montados a la vez.

## 3. Las cinco uniones en detalle

### v1 · Hexágono a presión — `scad/sanding_stick.scad`

Espiga hexagonal de 6,00 mm entrecaras, 12 mm de agarre; hueco de 6,30 (holgura
0,15 mm por lado); chaflanes de 0,8 mm en espiga y boca. Seis caras planas impiden
que el cabezal gire al lijar de canto y estiran menos material que un cilindro.

*Calibrar:* `holgura`.

### v2 · Bayoneta de 1/4 de vuelta — `scad/sanding_stick_v2.scad`

Vástago Ø8,6 con dos ranuras en L; taladro Ø8,96 con dos tetones interiores. Se mete
a fondo y se gira 90° hasta el tope. **El canal no es horizontal: su techo baja
0,40 mm a lo largo del giro**, así que girar aprieta el cabezal contra el hombro del
mango. Es una cuña autoblocante y al entrar en el asiento pasa un resalte de
0,18 mm que se nota como un clic.

Los dos tetones van a ±90° del eje vertical, o sea horizontales sobre la cama:
ninguna de sus caras es un voladizo.

**El parámetro que decide si aguanta es `bay_juego_ax`** (0,05): el hueco que le
queda al tetón entre el suelo y el techo del canal. En la 2.0 valía 0,15 — más que
la propia muesca de retención — así que el tetón flotaba, la cuña no llegaba a
apretar y lijar de lado aflojaba la unión. Con 0,05, el tetón queda pinzado y la
muesca muerde 0,16 mm de verdad.

*Calibrar:* `bay_holgura` (0,18) para el ajuste radial. Si el giro va duro al final,
baja `bay_muesca` antes que nada; si baila, baja `bay_juego_ax`.

### v3 · Rosca cuadrada — `scad/sanding_stick_v3.scad`

Ø8 × paso 2, seis vueltas, filete cuadrado de 0,7 mm de profundidad. El perfil
cuadrado se imprime mucho mejor que el triangular (nada de puntas finas) y agarra
más superficie. Un piloto liso Ø8,6 × 2 centra antes de que la rosca engrane, y el
cabezal apoya en un hombro plano.

*Calibrar:* `ros_holgura` (0,25 radial) y `ros_hol_ax` (0,15 por flanco).

### v4 · Imán — `scad/sanding_stick_v4.scad`

Espiga Ø9 × 7,5 con una cara plana (chaveta en D) que impide el giro, y un imán de
neodimio **Ø6 × 3 mm** en la punta. Otro imán igual al fondo del taladro del cabezal,
a 0,3 mm del primero cuando está montado.

Necesitas 15 imanes: uno por mango y uno por cabezal. Se pegan con cianoacrilato.
**Acerca los dos imanes antes de encolar para marcar la polaridad** — si los pegas
al revés, el cabezal se repele.

*Calibrar:* `esp_holgura` (0,20). El alojamiento del imán es `mag_juego` = 0,20.

### v5 · Clip elástico — `scad/sanding_stick_v5.scad`

Vástago Ø8,6 partido por una ranura de 3,8 mm en dos brazos flexibles de 11,5 mm de
voladizo, cada uno con una pestaña de 0,6 mm que encaja en un rebaje interior del
cabezal. Rampas de 40° por los dos lados: entra y sale, no es un encaje permanente.
Dos caras planas laterales orientan la pieza y hacen de chaveta.

La deformación de trabajo del brazo es del **1,9 %** — recalculada con el método
que validó la rotura de la v10.0, tomando como voladizo la distancia real hasta la
pestaña y la sección real del brazo, que es un segmento circular y no un
rectángulo. Es tracción entre capas, así que **imprímelo en PETG**: en PLA está
por encima de donde rompe. Se salva de lo que le pasó a la v10.0 porque su brazo
tiene 13,2 mm² de sección contra los 2,9 de aquélla.

*Calibrar:* `snap_pest` (0,6). Si cuesta meterlo, baja a 0,5; si se suelta, sube a 0,7.

### v6 · Cola de milano transversal — `scad/sanding_stick_v6.scad`

La única unión de la familia que **no se enchufa**: el cabezal desliza de lado
sobre un carril de cola de milano en la punta del mango. Carril de 7,0 mm de
cresta × 5,0 de alto, flancos a 12° de la vertical, recorrido de 7,9 mm.

Las tres cosas que la hacen distinta:

**La dirección de desmontaje no es ninguna dirección de lijado.** Empujar y tirar
actúan a lo largo del mango; girar, alrededor de él. El cabezal sale
perpendicular a las dos, así que el propio gesto de lijar no puede desmontarlo.
Y con `cm_orient = 90` esa dirección es además la de la presión de lijado, que
mete el cabezal contra su tope en vez de sacarlo.

**El tirón lo aguanta la geometría, no el ajuste.** El destalonado de 12° hay que
romperlo para separar las piezas: no depende del rozamiento (v1, v4), ni de un
brazo elástico que se fatiga (v5), ni de que una holgura siga siendo la del
primer día. Un carril tampoco puede girar dentro de su ranura: el par de lijar de
canto lo bloquea la forma.

**Aprieta al final del recorrido.** El carril es cónico: la cresta se estrecha
0,7 mm desde el tope hasta la entrada (0,095 mm por milímetro) y la ranura del
cabezal se estrecha igual. Entra suelta y sólo aprieta en el último milímetro, y
por el ángulo del milano ese apriete empuja el cabezal contra el hombro del
mango. Es la misma cuña autoblocante de la v2, en línea recta.

En el sentido del deslizamiento la sujetan un tope duro por un lado y, por el
otro, un resalte de 0,10 mm en el extremo de entrada del carril. Para pasarlo el
cabezal tiene que levantarse ~0,45 mm del hombro, así que se nota como un clic y
no cede lijando de lado. El resalte va en la ENTRADA a propósito: sólo queda
cubierto en los últimos 1,5 mm, y no roza durante todo el recorrido.

*Ojo con la orientación:* con `cm_orient = 0` el carril desliza de lado, que es
más cómodo de cambiar, **pero los flancos quedan a 12° de la horizontal y el
cabezal necesita soportes justo en la superficie de ajuste**. Con 90 —el valor
por defecto— los flancos salen verticales y el cabezal no lleva ni un voladizo en
la zona de la unión (1,6 mm² frente a los 4,6 de la v2).

*Calibrar:* `cm_aprieto` (0,04, la interferencia total de flancos en el asiento).
Si el cabezal se queda corto y no llega al tope, bájalo; si llega pero baila,
súbelo. Si el clic cuesta demasiado, baja `cm_muesca` antes de tocar nada más.

### v7 · Cono autoblocante — `scad/sanding_stick_v7.scad`

La v1 hecha bien. Un cono de 12° de semiángulo, Ø8,4 en la base y 9 mm de largo,
en vez de un vástago cilíndrico.

**Es la única unión sin holgura que calibrar.** Un cilindro necesita hueco para
entrar, y ese hueco es exactamente el juego con el que después baila; un cono
entra hasta donde le deja la interferencia y se queda tocando en toda la
superficie. Cero juego radial, cero angular y cero basculamiento, sin depender
de acertar una décima ni de que la décima buena siga siéndolo con otro filamento.

Por debajo del ángulo de rozamiento del PLA (~17°) un cono es **autorretenedor**:
no se suelta solo y agarra con la fuerza que le hayas metido con el pulgar. Con
12° queda firme y sale de un tirón. Bajarlo agarra más, pero hay que golpearlo
para sacarlo y mueve el doble la profundidad de asiento.

Los dos planos de chaveta son **también cónicos**: escalan con el cono, así que
aprietan a la vez que él y el giro tampoco tiene juego. Un plano paralelo al eje
no serviría — se separaría de su cara en cuanto la profundidad variase.

**El cabezal no apoya en el hombro, a propósito.** Quien lo sitúa es el cono,
como en un cono Morse de máquina: si el hombro tocase, los dos se pelearían por
posicionar y el cono dejaría de apretar. Por eso el chaflán frontal es de 1,7 mm
en vez de 1,0 — la punta del mango acaba en Ø8,60 y el anillo de la boca del
cabezal empieza en Ø9,63, y no se rozan nunca.

**La contrapartida, dicha claramente:** la profundidad de asiento la pone el
ajuste, y cada 0,1 mm de error radial la mueve 0,47 mm. Como un taladro impreso
en horizontal tiende a salir estrecho, lo normal es que quede medio milímetro de
junta entre las dos piezas. No afecta a cómo sujeta —el cono agarra igual— y
cae dentro de la V que forman los dos chaflanes, que es donde menos canta. Si
te molesta, `con_retro` la cierra.

Dos topes de seguridad que con un ajuste normal no llegan a tocar: el taladro
deja 0,8 mm delante de la punta, y si el cono entrase muy suelto la boca del
cabezal apoyaría en el chaflán del mango medio milímetro más adentro, antes de
que la cuña pudiera abrir una pared de 1,6 mm.

*Calibrar:* `con_retro`, y sólo si te molesta la junta. Está en milímetros de
recorrido: `-0.3` mete el cabezal 0,3 mm más hacia el mango. **No cambia cómo
ajusta** — es la única versión en la que equivocarse en el parámetro no estropea
la unión, sólo mueve dónde queda la junta.

### v8 · Espiga y cuña transversal — `scad/sanding_stick_v8.scad`

La unión de carpintería de siempre, a escala de bolígrafo, y **la única con tres
piezas**: mango, cabezal y una cuña de 13,6 × 5 × 2,6–3,2 mm (177 mm³, se
imprime en un minuto).

El vástago lleva una ranura transversal y el cabezal un túnel alineado con ella.
La cuña entra de lado atravesando los dos: apoya por abajo en el suelo del túnel
del cabezal y por arriba en el techo de la ranura del vástago. Como es cónica
(1:12), empujarla separa esas dos caras y **tira del vástago hacia dentro**,
apretando el cabezal contra el hombro del mango.

**El apriete no lo fija el modelo, lo fijas tú.** Ninguna otra versión tiene eso:
en las demás, si la holgura se queda corta o la unión se desgasta, hay que
reimprimir. Aquí empujas la cuña medio milímetro más. Hay 7,2 mm de recorrido
(`cun_juego` dividido por la pendiente), y 1:12 está muy por debajo del ángulo de
rozamiento del PLA, así que no se sale sola.

**La cuña es además la chaveta.** Atraviesa el vástago, así que el giro lo bloquea
ella y el taladro puede ser un cilindro liso. Y con 13,6 mm de largo dentro de un
vástago de Ø8,6, el descuadre que permiten sus 0,08 de holgura lateral es de
0,34° — el largo de la cuña, no su holgura, es lo que fija el giro.

**Lo que cuesta, con los números medidos** sobre la sección del cabezal en la
banda del túnel, comparada con la sección intacta:

| | Área | I respecto a la presión de lijado | I lijando de lado |
|---|---|---|---|
| Intacta (a 4 mm de la boca) | 49,3 mm² | 659 mm⁴ | 706 mm⁴ |
| En la banda de la cuña (9 mm) | 32,7 mm² | 621 mm⁴ | 288 mm⁴ |
| **Pérdida** | **34 %** | **5,7 %** | **59 %** |

La orientación del túnel es la buena: quita material del eje neutro para la
flexión que produce la presión de lijado —la carga dominante— y sólo 5,7 % de
inercia. Girado 90° sería al revés. En esa dirección el momento en la banda es el
75 % del de la boca, así que **la banda no es la sección crítica lijando de
plano**: trabaja al 0,80 de lo que trabaja la boca.

Lijando de lado sí lo es: pierde el 59 % de inercia y queda a ~1,8 veces la
tensión de la boca. Son fuerzas de rozamiento, mucho menores que la presión, pero
es el punto por donde rompería.

**La cuña es el fusible.** Aguanta unos 90 N de precarga antes de doblarse, y con
la ventaja mecánica 12:1 un pulgar decidido llega ahí. Es lo que se rompe si te
pasas apretando, y es la pieza más barata de reimprimir de todo el proyecto.

Sobresale ~1,35 mm por cada lado. Es lo que permite empujarla para apretar y
golpearla para sacarla, y no hay forma de evitarlo en una unión de cuña.

*Calibrar:* nada. `cun_holgura` (0,15 radial) sólo tiene que dejar entrar el
vástago; quien quita el juego es la cuña. Si el taladro sale justo, súbela.

*Corregido en la 8.1:* el avellanado de la boca era de 0,8 y se comía el borde
que deja `cuerpo_chaflan`, así que la boca acababa en filo — 0,63 mm² de apoyo —
justo en la unión donde el hombro es contra lo que aprieta la cuña. Con
`cun_avell` = 0,4 son 13,2 mm² de cara plana.

### v9 · Pinza cónica — `scad/sanding_stick_v9.scad`

Una pinza de portaminas. La boca del cabezal va partida en cuatro dedos por
ranuras axiales y su exterior es un cono 1:8; un casquillo cónico de Ø14,6 × 6 mm
se empuja con el pulgar sobre ese cono y cierra los dedos sobre el vástago.

**El apriete no se agota.** Las demás versiones reparten un número fijo de
holgura, y cuando el uso se lo come no hay más que reimprimir. Aquí hay 2 mm de
recorrido de casquillo, cada milímetro cierra 0,125 mm de diámetro, y la unión se
puede reapretar durante toda la vida de la herramienta. La conicidad multiplica
por ocho la fuerza del pulgar y está muy por debajo del ángulo de rozamiento del
PLA, así que el casquillo no se afloja solo.

**La pinza va en el cabezal, no en el mango**, y no es un capricho. Al revés los
cabezales necesitarían un vástago macho saliendo en horizontal de la boca, y
dejarían de poder imprimirse planos sobre su cara de lijado, que es la decisión
de la que cuelga todo el proyecto. Dos consecuencias buenas: el mango es el más
simple de las nueve versiones —un cilindro liso de Ø8,6, sin una sola
característica— y cualquier cabezal se puede montar sobre **cualquier varilla de
Ø8,6**, por ejemplo un tubo largo para llegar al fondo de una caja.

**El casquillo no se pierde.** Por detrás no puede pasar al mango (su taladro
trasero es de Ø11,05 y el mango es de Ø12) y por delante topa con el cuerpo del
cabezal. Sólo sale con el cabezal desmontado, que es cuando toca limpiarlo. Es la
diferencia práctica con la cuña de la v8, que sí se puede perder.

Cada ranura acaba en un **taladro de alivio de Ø1,4**. Sin él la ranura muere en
un ángulo vivo, que es exactamente donde agrietaría un dedo después de unos
cuantos ciclos.

La deformación de trabajo del dedo es del **0,4 %** —cierra 0,075 mm sobre un
voladizo útil de 6 mm con 1,3 de pared—, menos de un tercio del 1,4 % del clip de
la v5. Esta pinza no se fatiga.

**Lo que cuesta:** es la más voluminosa, con un collar de Ø14,6 en una
herramienta de Ø12, y la que más volumen añade (355 mm³ de casquillo por mango).
Y el cabezal lleva cuatro ranuras abiertas de la boca hasta 10 mm que van a
recoger polvo de lijado.

*Calibrar:* nada. `pin_holgura` (0,15 diametral) sólo tiene que dejar entrar el
vástago con el casquillo suelto; el resto lo pone el pulgar.

### v10 · Doble espiga con clic — `scad/sanding_stick_v10.scad`

> **La 10.0 se rompía.** Las espigas iban partidas en dos brazos y se partieron
> al primer montaje a mano. La ficha decía 0,56 % de deformación y era falso: el
> número real era 1,37 %, y además en tracción **entre capas**. Lo que sigue es
> la 10.1, con las espigas macizas y lo que flexa mudado al cabezal. El porqué
> completo está en el CHANGELOG.

Dos espigas **macizas** de Ø3,4 separadas 5,4 mm, con una garganta, y en el
cabezal dos lengüetas flexibles con la pestaña. Es la unión que **reparte el
trabajo**: las espigas orientan y aguantan el par y el cortante, las lengüetas
sólo retienen, y quien impide que el cabezal bascule no es ninguna de las dos
cosas sino el hombro.

Y ahí está su argumento. La lección que costó la v2.2 fue que lo que impide
bascular es la corona de apoyo, no el vástago. Al cambiar un taladro de Ø8,6 por
dos de Ø3,55, la boca del cabezal deja de ser un anillo fino y pasa a ser un
disco casi macizo: **51,6 mm² apoyando contra el hombro, la mayor de las diez**,
frente a los 1,6 de la v2.

**Es la más fácil de imprimir bien.** Dos postes redondos y dos agujeros
redondos: no hay hélice, ni destalonado, ni tetones dentro de un canal, ni
collares de pared fina. Si hay una impresora o un filamento con los que las
demás uniones no acaban de salir, ésta va a salir.

**Lo que flexa vive en el cabezal, y eso no es un detalle.** El mango se imprime
de pie: cualquier voladizo suyo flexa *entre capas*, que es donde el PLA rompe
sobre el 1 %. El cabezal se imprime tumbado sobre su cara de lijado, así que una
lengüeta suya que flexe hacia los lados trabaja **dentro** del plano de la capa.
Es la lección que costó la 10.0, y vale para cualquier unión que se añada.

Y flexa poquísimo: la pestaña sobresale 0,18 dentro de un taladro que ya es
0,075 más ancho que la espiga, así que **lo que la lengüeta abre son 0,105 mm**.
Con 1,5 de pared, 3,0 de ancho y 7,0 de voladizo eso es **0,49 %**.

Ese mismo 0,105 es el escalón que retiene. Como la retención sale del *ángulo*
del canto y no de su profundidad, el canto de arriba de la garganta es corto a
propósito —0,15 para 0,24 de profundidad, unos 64°—: retiene de sobra sin
pedirle a la lengüeta ni una décima más de recorrido.

Las espigas van separadas en el eje que en el cabezal impreso es el
**horizontal**, para que las lengüetas caigan en los costados y no en la cara que
apoya en la cama. Se pierde algo de par de fuerzas contra la presión de lijado,
pero quien se come ese momento es la corona.

*Juego de giro:* vale holgura ÷ (separación ÷ 2) = 0,075/2,7 = **1,6°**. Bajar
`esp2_holgura` a 0,05 lo deja en 1,1°, a cambio de un ajuste más exigente.

**Lo que cuesta:** las espigas son esbeltas — mientras el cabezal apoye en el
hombro da igual, porque la corona se come el momento, pero si alguien hace
palanca de verdad con la pala, Ø3,4 es lo que hay. Y el cabezal lleva cuatro
ranuras abiertas en los costados por las que entrará polvo.

*Calibrar:* `esp2_gar_sube` (0,15), que es lo que gradúa cuánto retiene: a 0,08
cuesta mucho sacarlo, a 0,30 sale solo. `esp2_pest` (0,18) sólo si el clic no se
nota — y sube de 0,105 mm de recorrido de lengüeta por cada 0,10 que le añadas.

## 4. Calibra antes de imprimir el juego

**Si aún no sabes qué versión quieres, empieza por el kit de test rápido**
(`TEST_RAPIDO.md` · `stl_test/`): los cinco enganches y las siete formas
recortados a lo mínimo, para probarlos todos en un rato en vez de imprimir 45 cm³
a ciegas. La geometría de unión es la misma que la de las piezas reales.

1. Imprime el `test_ajuste.stl` **de la versión que hayas elegido** (5 min). Trae el
   macho y la hembra sueltos, con la geometría exacta de las piezas reales.
2. Prueba el encaje. Debe montar sin forzar y quedar firme.
3. Corrige **una sola variable**, la que dice «calibrar» en el apartado de tu versión.
4. Repite el test. **Sólo cuando encaje**, lanza `./render.sh vN`.

Cambiar la holgura después obliga a reimprimir los catorce cabezales, no el mango.

## 5. Ajustes de impresión

**Cabezales** — capa 0,16 mm · 4 perímetros · 30 % giroide · sin soportes ni balsa.
PLA vale (PETG en la v5, y también si vas a lijar en húmedo). Los catorce caben en
una bandeja: 45–50 cm³ según la versión.

**Mango** — capa 0,20 mm · 4 perímetros · 20 % · velocidad exterior ≤ 120 mm/s.
Recto y ergonómico **de pie con balsa**, con la parte macho hacia arriba (el chaflán
de punta evita así el «pie de elefante» en el encaje). Doble, tumbado.

## 6. Uso del modelo

**En Windows, usa PowerShell y `render.ps1`** — `render.sh` es bash y necesita Git
Bash o WSL. El `.ps1` busca `openscad.exe` en el PATH y en las rutas normales de
instalación; si lo tienes en otro sitio, `$env:OPENSCAD = "C:\ruta\openscad.exe"`.

```powershell
.\render.ps1 v2            # una versión completa, calidad final ($fn=64) → stl\v2\
.\render.ps1 todas         # las cinco
.\render.ps1 v2 preview    # rápido ($fn=48) → preview_stl\v2\
```

```bash
./render.sh v2            # lo mismo desde bash
./render.sh todas
./render.sh v3 preview    # rápido ($fn=48) + PNG de cada pieza

# una pieza suelta
openscad -o pala16_45.stl -D 'pieza="cabezal"' -D 'tipo="pala"' \
         -D ancho=16 -D angulo=45 scad/sanding_stick_v2.scad
```

Los dos scripts **avisan si no encuentran OpenSCAD y si alguna pieza no se ha
escrito**, en vez de recorrer las 18 en silencio y decir «Listo».

Calidad final es `$fn=64`, no 96: en un cilindro Ø12 el error de facetado con 64 es
de 0,007 mm — treinta veces menos de lo que puede expresar una boquilla de 0,4 — y
con 96 el mango tarda tres veces más en resolver los booleanos.

Parámetros comunes, todos al principio de cada `.scad` con su comentario:

| Parámetro | Por defecto | Qué hace |
|---|---|---|
| `pieza` | `"conjunto"` | `mango` · `cabezal` · `test_ajuste` · `conjunto` · `interferencia` |
| `variante_mango` | `"recta"` | `recta` · `ergonomica` · `doble` |
| `tipo` | `"pala"` | forma del cabezal (7 opciones) |
| `ancho` | `16` | ancho de la cara de lijado |
| `angulo` | `0` | 0 / 45 / 90 — sólo para `pala` |
| `mango_largo` | `125` | largo del mango sin la parte macho |
| `ranuras_num` | `7` | anillos de agarre |
| `largo_barra` | `40` | largo de prismas y medios tubos |
| `falda` | `0` | falda exterior; 6 la activa (ver apartado 2) |

`pieza="interferencia"` renderiza la intersección del cabezal con el mango montado:
su volumen debe ser prácticamente cero. Es la comprobación que garantiza que macho y
hembra casan sin chocar.

## 7. Añadir una undécima unión

Las versiones 2 a 10 se generan desde un esqueleto común con
`python3 scad/_generar_versiones.py`. Cada una sólo aporta cinco cosas, y una
sexta si necesita una pieza suelta:

```
junta_macho(sentido)   parte macho, base en z=0, crece hacia +Z (va en el mango)
junta_hembra_neg()     negativo a restar, marco de la boca del cabezal
junta_hembra_pos()     positivo a añadir después de restar (tetones, etc.)
junta_giro()           giro del mango en el conjunto montado
junta_d()              Ø nominal, para el plano del mango "doble"

junta_extra()          pieza suelta tumbada para imprimir  → pieza="extra"
junta_extra_montado()  la misma, colocada en el marco de la boca
```

Las dos últimas están vacías en todas menos en la v8 y la v9, y son las que
permiten que una unión lleve una tercera pieza sin tocar el esqueleto:
`pieza="extra"` la saca sola, el `test_ajuste` la incluye al lado y el `conjunto`
la pinta montada.

Un aviso de la v9: **un chaflán se resta como anillo, no como cono.** Restar un
`cylinder(r1 = R+0,5, r2 = R−0,5)` parece un chaflán y en realidad se lleva por
delante toda la pieza en su primer plano, porque ahí el radio del cono es mayor
que el de la pieza. Hay que restar la diferencia entre un cilindro grande y ese
cono. Se ve al instante en la envolvente: 5,51 mm de alto en una pieza de 6.

Escribe esos módulos en un bloque nuevo del generador y tienes las 18 piezas.

**Aviso al escribir una junta nueva:** el marco de la boca del cabezal está
**espejado en Z** respecto al del mango. Cualquier geometría con quiralidad —una
hélice, una bayoneta— hay que invertirla en la hembra, o macho y hembra no casan.
La comprobación `pieza="interferencia"` lo detecta al instante.

Ese espejo tiene un corolario que costó encontrar en la v6: **para orientar la
unión con un giro sobre el eje de la herramienta hay que girar el macho y la
hembra en sentidos contrarios** (`rotate([0,0,-cm_orient])` y
`rotate([0,0,+cm_orient])`). Si se giran igual, la parte simétrica encaja y la
asimétrica —la conicidad del carril— sale invertida.

**Lo que flexa va en el CABEZAL, no en el mango.** El mango se imprime de pie, así
que cualquier voladizo suyo flexa **entre capas**, y ahí el PLA rompe alrededor
del 1 %. El cabezal se imprime tumbado sobre su cara de lijado: una lengüeta suya
que flexe hacia los lados trabaja **dentro** del plano de la capa. La v10.0 puso
los brazos en el mango, prometió 0,56 % —eran 1,37 %— y se partió al primer
montaje a mano.

Y al calcular la deformación de un brazo: el voladizo es la distancia hasta la
**pestaña**, no la longitud de la ranura, y va al cuadrado; y la sección de un
brazo partido de una espiga redonda es un **segmento circular**, cuya fibra
exterior está más lejos del centroide que la mitad de su espesor. Los dos errores
juntos dan un número 2,4 veces optimista.

**Y comprueba los voladizos, no sólo la interferencia.** La v6 nació con los
flancos del milano a 12° de la horizontal: encajaba perfecto y era imposible de
imprimir sin soportes justo en la cara de ajuste. Se ve en dos líneas:

```python
m = trimesh.load("cabezal.stl"); n = m.face_normals
zmin = m.vertices[:,2].min()
cama = (m.vertices[m.faces][:,:,2] <= zmin + 0.05).all(axis=1)
print(m.area_faces[(n[:,2] < -0.7071) & ~cama].sum(), "mm² en voladizo")
```

## 8. Cómo pegar la lija

Cinta de doble cara fina o adhesivo de contacto en spray sobre la cara plana, y
recortar al ras con cúter apoyando el filo en el canto del cabezal. En los medios
tubos la lija se enrolla y los bordes se meten a presión dentro del canal, sin
pegamento: así se cambia en segundos.
