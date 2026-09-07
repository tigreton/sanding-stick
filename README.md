# Sanding Stick — lijador modular paramétrico

Mango tipo bolígrafo + 14 cabezales intercambiables, para lijar impresiones 3D y
filigranas en madera. Impreso en Bambu Lab A1 Mini (180 × 180 × 180 mm).

**Cinco versiones. Lo único que cambia entre ellas es cómo se engancha el cabezal.**
Formas, anchos, mangos y orientación de impresión son idénticos en las cinco.

| | Unión | Gesto de cambio | Aguanta el tirón | Comprar algo |
|---|---|---|---|---|
| **v1** | Hexágono 6 AF a presión | tirar y empujar | regular | no |
| **v2** | Bayoneta de 1/4 de vuelta | meter y girar 90° | **sí, bloqueo axial** | no |
| **v3** | Rosca cuadrada Ø8 × paso 2 | 3 vueltas | **sí** | no |
| **v4** | Imán Ø6×3 + espiga en D | acercar | se separa al tirar | **15 imanes** |
| **v5** | Clip elástico de dos brazos | empujar hasta el clic | sí, hasta cierta fuerza | no |

**Si sólo vas a imprimir una: la v2.** Es la única que combina cambio rápido con
bloqueo axial real, y no depende de comprar nada ni de que un brazo elástico
aguante mil ciclos.

Abre `visor_lijador.html` en el navegador para verlas y compararlas en 3D.

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
│   └── _generar_versiones.py     genera v2–v5 desde un esqueleto común
├── render.sh                     genera los STL de una versión o de todas
├── visor_lijador.html            visor 3D interactivo con las 5 versiones
├── stl/                          STL a calidad final
├── preview_stl/v1..v5/           18 piezas por versión, calidad de trabajo
├── png/                          renders de cada pieza
├── web/                          plantilla del visor y mallas empaquetadas
└── CHANGELOG.md · FUENTES.md · README.md · LICENSE

sanding_stick_v1.0.zip            instantánea congelada de la v1 (fuera de la carpeta)
```

`preview_stl/` y `png/` no van al repositorio: se regeneran con `./render.sh`.
Sí están versionadas las cinco piezas de calibración (`stl/vN/test_ajuste.stl`),
que es lo primero que hay que imprimir, guardadas como STL binario.

## 2. Lo que comparten las cinco versiones

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
0,25 mm a lo largo del giro**, así que girar aprieta el cabezal contra el hombro del
mango. Es una cuña autoblocante — no se afloja sola — y al entrar en el asiento pasa
un resalte de 0,06 mm que se nota como un clic.

Los dos tetones van a ±90° del eje vertical, o sea horizontales sobre la cama:
ninguna de sus caras es un voladizo.

*Calibrar:* `bay_holgura` (0,18). Si el giro va duro, sube también `bay_rampa`.

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

La deformación de trabajo del brazo es ~1,4 % — dentro de lo que aguanta el PLA, pero
**imprímelo en PETG** si vas a cambiar de cabezal a menudo: tolera mucho mejor los
ciclos.

*Calibrar:* `snap_pest` (0,6). Si cuesta meterlo, baja a 0,5; si se suelta, sube a 0,7.

## 4. Calibra antes de imprimir el juego

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

```bash
./render.sh v2            # una versión completa, calidad final ($fn=96) → stl/v2/
./render.sh todas         # las cinco
./render.sh v3 preview    # rápido ($fn=48) + PNG de cada pieza

# una pieza suelta
openscad -o pala16_45.stl -D 'pieza="cabezal"' -D 'tipo="pala"' \
         -D ancho=16 -D angulo=45 scad/sanding_stick_v2.scad
```

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

`pieza="interferencia"` renderiza la intersección del cabezal con el mango montado:
su volumen debe ser prácticamente cero. Es la comprobación que garantiza que macho y
hembra casan sin chocar.

## 7. Añadir una sexta unión

Las versiones 2 a 5 se generan desde un esqueleto común con
`python3 scad/_generar_versiones.py`. Cada una sólo aporta cinco cosas:

```
junta_macho(sentido)   parte macho, base en z=0, crece hacia +Z (va en el mango)
junta_hembra_neg()     negativo a restar, marco de la boca del cabezal
junta_hembra_pos()     positivo a añadir después de restar (tetones, etc.)
junta_giro()           giro del mango en el conjunto montado
junta_d()              Ø nominal, para el plano del mango "doble"
```

Escribe esos módulos en un bloque nuevo del generador y tienes las 18 piezas.

**Aviso al escribir una junta nueva:** el marco de la boca del cabezal está
**espejado en Z** respecto al del mango. Cualquier geometría con quiralidad —una
hélice, una bayoneta— hay que invertirla en la hembra, o macho y hembra no casan.
La comprobación `pieza="interferencia"` lo detecta al instante.

## 8. Cómo pegar la lija

Cinta de doble cara fina o adhesivo de contacto en spray sobre la cara plana, y
recortar al ras con cúter apoyando el filo en el canto del cabezal. En los medios
tubos la lija se enrolla y los bordes se meten a presión dentro del canal, sin
pegamento: así se cambia en segundos.
