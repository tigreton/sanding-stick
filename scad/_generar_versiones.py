#!/usr/bin/env python3
"""Genera las cuatro variantes de unión del Sanding Stick a partir de un
esqueleto común. Cada versión sólo aporta:

    · su bloque de parámetros
    · junta_macho(sentido)   — parte macho, base en z=0, crece hacia +Z (mango)
    · junta_hembra_neg()     — negativo a restar, marco de la boca del cabezal
    · junta_hembra_pos()     — positivo a añadir después de restar (opcional)
    · junta_giro()           — giro del mango en el conjunto montado
    · junta_d()              — Ø nominal, para el plano del mango "doble"

Uso:  python3 _generar_versiones.py      (escribe sanding_stick_v[2-5].scad)
"""
import os, textwrap

AQUI = os.path.dirname(os.path.abspath(__file__))

# =====================================================================
#  ESQUELETO COMÚN
# =====================================================================
COMUN = r'''
/* [Pieza a generar] */
pieza = "conjunto";           // ["mango","cabezal","test_ajuste","conjunto","interferencia","extra"]
                              // "extra" es la pieza suelta de las uniones que la
                              // necesitan (la cuña de la v8); vacía en las demás
variante_mango = "recta";     // ["recta","ergonomica","doble"]
giro_vista = 1;               // 1 = montado y bloqueado · 0 = alineado para insertar

/* [Cabezal] */
tipo = "pala";                // ["pala","triangulo","prisma_tri","medio_tubo_convexo","medio_tubo_concavo"]
ancho = 16;                   // ancho de la cara de lijado (8 ó 16 recomendados)
angulo = 0;                   // 0 | 45 | 90   (solo para tipo "pala")
largo_pala = -1;              // -1 = automático (40 a 0°, 25 a 45°, 16 a 90°)
espesor = -1;                 // -1 = automático (3 mm si ancho<=10, si no 4 mm)
radio_esquinas = 1.5;
largo_barra = 40;             // longitud de prismas y medios tubos
pared_canal = -1;
fondo_canal = 2;

/* [Mango] */
mango_diametro = 12;
mango_largo = 125;
mango_chaflan = 1.5;
mango_chaflan_frontal = 1.0;  // Es lo que le queda de asiento al cabezal: el hombro
                              // llega hasta Ø(12 - 2*chaflán). Cada versión lo ajusta
                              // a la boca de SU cabezal (la v2 lo baja a 0,3).
ranuras_num = 7;
ranuras_ancho = 1.6;
ranuras_prof = 0.6;
ranuras_paso = 4;
ranuras_inicio = 14;
plano_antirrodadura = 0;
ergo_d_frente = 11;
ergo_d_max = 14;
ergo_pos_max = 55;
ergo_d_atras = 10.5;

/* [Falda exterior — opcional, vale para las diez uniones] */
// Con falda > 0 el cabezal envuelve por fuera un tramo rebajado de la punta del
// mango. Traslada la corona de apoyo de Ø8,8–10,4 a Ø9,8–11,2: misma unión, el
// doble de inercia contra el basculamiento, y una guía radial más que alarga la
// base de apoyo por delante del plano de la junta en vez de por detrás.
// Cuesta `falda` mm de longitud de herramienta y ~240 mm³ por cabezal.
falda = 0;                    // longitud de la falda (0 = sin falda; 6 es lo probado)
falda_pared = 1.6;            // pared de la falda: la espiga queda en Ø(12 - 2·pared).
                              // No subirlo: el contrataladro tiene que ser más ancho
                              // que la hembra de la junta o no se puede llegar a ella
falda_juego = 0.10;           // holgura radial entre falda y espiga
falda_chaflan = 0.3;          // chaflán de entrada de la espiga y de la falda. Con 0,6
                              // el avellanado se comía la corona entera: mismo fallo
                              // que la boca en filo de la v2.2
falda_ch_boca = 0.3;          // chaflán exterior de la boca cuando hay falda. El 0,8
                              // de cuerpo_chaflan dejaría la corona en 9 mm²

/* [Cuerpo del cabezal] */
cuerpo_d = 12;
cuerpo_largo = 16;
cuerpo_zc = 5.5;
cuerpo_chaflan = 0.8;
cuello = 8;
cuello_90 = 3;

/* [Calidad] */
$fn = 64;
__PARAMS__

// ---------------------------------------------------------------------
//  Auxiliares
// ---------------------------------------------------------------------
function esp() = espesor > 0 ? espesor : (ancho <= 10 ? 3 : 4);
function largo_p(a) = largo_pala > 0 ? largo_pala : (a == 0 ? 40 : (a == 45 ? 25 : 16));
function x0_pala(a) = -largo_p(a) * (a / 90) / 2;
function pared_c() = pared_canal > 0 ? pared_canal : (ancho <= 10 ? 1.5 : 2);
function canal_d() = ancho - 2 * pared_c();
function ang_efectivo() = (tipo == "pala") ? angulo : 0;
function P(a) = (a == 90) ? [0, 0, esp() + cuello_90] : [0, 0, cuerpo_zc];
function coseno(t) = (1 - cos(180 * t)) / 2;
function r_ergo_s(s) = s <= ergo_pos_max
    ? ergo_d_frente / 2 + (ergo_d_max - ergo_d_frente) / 2 * coseno(s / ergo_pos_max)
    : ergo_d_max / 2 + (ergo_d_atras - ergo_d_max) / 2 * coseno((s - ergo_pos_max) / (mango_largo - ergo_pos_max));
function radio_mango(z) = (variante_mango == "ergonomica") ? r_ergo_s(mango_largo - z) : mango_diametro / 2;
// Con falda, el plano del mango doble lo limita la espiga rebajada, no la junta:
// la espiga es más gorda que cualquier vástago y es lo primero que cortaría.
function plano_auto() = (mango_diametro - (falda > 0 ? falda_d() : junta_d())) / 2 - 0.4;
function plano_efectivo() = (variante_mango == "doble" && plano_antirrodadura == 0)
    ? max(0, plano_auto()) : plano_antirrodadura;
function cuerpo_L() = cuerpo_largo + falda;              // cuerpo, falda incluida
function falda_d()  = mango_diametro - 2 * falda_pared;  // Ø de la espiga rebajada
function ranura_s0() = (variante_mango == "doble")
    ? (mango_largo - (ranuras_num - 1) * ranuras_paso) / 2 : ranuras_inicio;

// Sector anular 2D, de 0 a `ang` grados (ang puede ser negativo)
module sector2d(ri, ro, ang, n = 6) {
    polygon(concat(
        [for (i = [0 : n]) let(t = ang * i / n) [ri * cos(t), ri * sin(t)]],
        [for (i = [n : -1 : 0]) let(t = ang * i / n) [ro * cos(t), ro * sin(t)]]
    ));
}
__JUNTA__

// ---------------------------------------------------------------------
//  MANGO
// ---------------------------------------------------------------------
module perfil_mango() {
    n = 80; chf = mango_chaflan_frontal;
    // En la variante doble el extremo de atrás también es un hombro: lleva el
    // chaflán pequeño, no el de culata, o el cabezal de ese lado no apoya.
    ch0 = (variante_mango == "doble") ? chf : mango_chaflan;
    pts = concat(
        [[0, 0], [radio_mango(0) - ch0, 0]],
        [for (i = [0 : n]) let(z = ch0 + (mango_largo - ch0 - chf) * i / n) [radio_mango(z), z]],
        [[radio_mango(mango_largo) - chf, mango_largo], [0, mango_largo]]
    );
    polygon(pts);
}
module ranuras_mango() {
    for (k = [0 : ranuras_num - 1]) {
        z = mango_largo - (ranura_s0() + k * ranuras_paso);
        r = radio_mango(z);
        rotate_extrude() translate([r, z]) scale([ranuras_prof / (ranuras_ancho / 2), 1]) circle(d = ranuras_ancho);
    }
}
module mango() {
    pl = plano_efectivo();
    difference() {
        union() {
            rotate_extrude() perfil_mango();
            translate([0, 0, mango_largo]) { falda_espiga(); translate([0, 0, falda]) junta_macho(1); }
            if (variante_mango == "doble")
                mirror([0, 0, 1]) { falda_espiga(); translate([0, 0, falda]) junta_macho(-1); }
        }
        ranuras_mango();
        if (variante_mango == "doble") translate([0, 0, falda]) junta_hueco_macho();
        if (pl > 0)
            translate([-50, -mango_diametro / 2 - 20, -junta_largo() - falda - 5])
                cube([100, 20 + pl, mango_largo + 2 * (junta_largo() + falda) + 10]);
    }
}

// ---------------------------------------------------------------------
//  CABEZAL  (orientación de impresión: cara de lijado en z = 0)
// ---------------------------------------------------------------------
module a_eje_cuerpo(a) { translate(P(a)) rotate([0, a, 0]) rotate([0, -90, 0]) children(); }
// La boca es el extremo exterior del cabezal, falda incluida. El marco de la
// JUNTA está `falda` mm más adentro: a_junta().
module a_boca(a) { a_eje_cuerpo(a) translate([0, 0, cuerpo_L()]) mirror([0, 0, 1]) children(); }
module a_junta(a) { a_boca(a) translate([0, 0, falda]) children(); }
// Contrataladro de la falda, en el marco de la boca
module falda_hueco() {
    if (falda > 0) {
        translate([0, 0, -0.01])
            cylinder(d = falda_d() + 2 * falda_juego, h = falda + 0.01);
        translate([0, 0, -0.01])
            cylinder(d1 = falda_d() + 2 * falda_juego + 2 * falda_chaflan,
                     d2 = falda_d() + 2 * falda_juego, h = falda_chaflan + 0.01);
    }
}
// Espiga rebajada de la punta del mango, con su chaflán de entrada
module falda_espiga() {
    if (falda > 0) {
        cylinder(d = falda_d(), h = falda - falda_chaflan);
        translate([0, 0, falda - falda_chaflan])
            cylinder(d1 = falda_d(), d2 = falda_d() - 2 * falda_chaflan, h = falda_chaflan);
    }
}

module cuerpo(a) {
    r = cuerpo_d / 2; ch = (falda > 0) ? falda_ch_boca : cuerpo_chaflan; L = cuerpo_L();
    a_eje_cuerpo(a) rotate_extrude()
        polygon([[0, 0], [r, 0], [r, L - ch], [r - ch, L], [0, L]]);
}
module cuerpo_base(a) { a_eje_cuerpo(a) cylinder(d = cuerpo_d - 0.6, h = 3); }

module pala_2d(a) {
    L = largo_p(a); x0 = x0_pala(a); rr = radio_esquinas; W = ancho;
    if (a == 90) translate([x0, -W / 2]) offset(r = rr) offset(delta = -rr) square([L, W]);
    else hull() {
        translate([x0, -W / 2]) square([L - rr, W]);
        translate([x0 + L - rr, -W / 2 + rr]) circle(rr);
        translate([x0 + L - rr,  W / 2 - rr]) circle(rr);
    }
}
module triangulo_2d() {
    Lt = ancho <= 10 ? 22 : 30; rr = 0.8;
    offset(r = rr) offset(delta = -rr) polygon([[0, -ancho / 2], [0, ancho / 2], [Lt, 0]]);
}
function x0_forma(a) = (tipo == "pala") ? x0_pala(a) : 0;
module hombro_2d(a) {
    if (ancho < cuerpo_d - 0.5) {
        L = (tipo == "triangulo") ? (ancho <= 10 ? 22 : 30) : largo_p(a);
        x0 = x0_forma(a); Lh = min(cuello + 6, L * 0.8);
        hull() {
            translate([x0 + cuerpo_d / 2, 0]) circle(d = cuerpo_d);
            translate([x0 + Lh, -ancho / 2]) square([0.01, ancho]);
        }
    }
}
module pala(a)      { linear_extrude(height = esp()) { pala_2d(a); hombro_2d(a); } }
module triangulo()  { linear_extrude(height = esp()) { triangulo_2d(); hombro_2d(0); } }
module prisma_tri() {
    h = ancho * sqrt(3) / 2;
    rotate([90, 0, 90]) linear_extrude(height = largo_barra) polygon([[-ancho / 2, 0], [ancho / 2, 0], [0, h]]);
}
module medio_tubo_convexo() {
    rotate([90, 0, 90]) linear_extrude(height = largo_barra)
        intersection() { circle(d = ancho); translate([-ancho / 2, 0]) square([ancho, ancho]); }
}
module medio_tubo_concavo() {
    cd = canal_d(); H = cd / 2 + fondo_canal;
    rotate([90, 0, 90]) linear_extrude(height = largo_barra) difference() {
        translate([-ancho / 2, 0]) square([ancho, H]);
        translate([0, H]) circle(d = cd);
    }
}
module forma_activa(a) {
    if (tipo == "pala") pala(a);
    else if (tipo == "triangulo") triangulo();
    else if (tipo == "prisma_tri") prisma_tri();
    else if (tipo == "medio_tubo_convexo") medio_tubo_convexo();
    else if (tipo == "medio_tubo_concavo") medio_tubo_concavo();
}

module cabezal() {
    a = ang_efectivo();
    difference() {
        union() {
            cuerpo(a);
            forma_activa(a);
            hull() {
                cuerpo_base(a);
                intersection() {
                    forma_activa(a);
                    translate([x0_forma(a) - 0.01, -100, -1])
                        cube([(a == 90) ? largo_p(a) + 0.02 : cuello, 200, 100]);
                }
            }
        }
        a_junta(a) junta_hembra_neg();
        a_boca(a) falda_hueco();
        translate([-200, -200, -100]) cube([400, 400, 100]);
    }
    a_junta(a) junta_hembra_pos();
}

// ---------------------------------------------------------------------
//  TEST DE AJUSTE: cuerpo con la hembra + tapón con el macho
// ---------------------------------------------------------------------
module test_ajuste() {
    difference() {
        cuerpo(0);
        a_junta(0) junta_hembra_neg();
        a_boca(0) falda_hueco();
        translate([-200, -200, -100]) cube([400, 400, 100]);
    }
    a_junta(0) junta_hembra_pos();
    translate([19, 0, 0]) {
        cylinder(d = mango_diametro, h = 8);
        translate([0, 0, 8]) falda_espiga();
        translate([0, 0, 8 + falda]) junta_macho(1);
    }
    translate([9.5, -14, 0]) junta_extra();     // vacío salvo en las uniones que la usan
}

// ---------------------------------------------------------------------
//  CONJUNTO
// ---------------------------------------------------------------------
module mango_montado() {
    a = ang_efectivo();
    d = [-cos(a), 0, sin(a)];
    M = P(a) + cuerpo_L() * d;
    translate(M) rotate([0, 90 + a, 0]) rotate([0, 0, junta_giro() * giro_vista])
        translate([0, 0, -mango_largo]) children();
}
module conjunto() {
    color("#d9a441") cabezal();
    color("#4a6fa5") mango_montado() mango();
    color("#b5483f") a_junta(ang_efectivo()) junta_extra_montado();
}
// Comprobación: el volumen debe ser ~0. Si sale grande, macho y hembra chocan.
//   openscad -o x.stl -D 'pieza="interferencia"' -D mango_largo=8 -D ranuras_num=0 ...
module interferencia() { intersection() { cabezal(); mango_montado() mango(); } }

// ---------------------------------------------------------------------
if (pieza == "mango") mango();
else if (pieza == "cabezal") cabezal();
else if (pieza == "test_ajuste") test_ajuste();
else if (pieza == "extra") junta_extra();
// La pieza suelta ya colocada en el marco del cabezal. No es para imprimir:
// es lo que come el visor 3D, que la pinta como tercera malla del conjunto.
else if (pieza == "extra_puesto") a_junta(ang_efectivo()) junta_extra_montado();
else if (pieza == "interferencia") interferencia();
else conjunto();
'''

# =====================================================================
#  V2 · BAYONETA DE 1/4 DE VUELTA
# =====================================================================
V2_HEAD = r'''// =====================================================================
//  SANDING STICK BAY90 — v2 · unión de BAYONETA de 1/4 de vuelta
//  Versión 2.1 · 2026-09-08 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  v2.1 — La 2.0 se aflojaba lijando de lado. El canal era 0,12 mm más alto
//  que el tetón, así que el tetón flotaba: la cuña no apretaba nada y la
//  muesca de retención pasaba por debajo sin tocar (aprieto real −0,06 mm).
//  Ahora el juego axial del canal es un parámetro, `bay_juego_ax` = 0,05, y
//  la muesca muerde 0,16 mm de verdad.
//
//  El mango termina en un vástago Ø8,6 con dos ranuras en L. El cabezal lleva
//  un taladro Ø8,96 con dos tetones interiores. Se mete a fondo y se gira 90°
//  hasta el tope: los tetones recorren un canal cuyo techo baja 0,25 mm, así
//  que el giro APRIETA el cabezal contra el hombro del mango. Es una cuña
//  autoblocante — no se afloja sola — y al entrar en el asiento hace clic.
//
//  Los dos tetones van a ±90° (eje Y), horizontal en la cama: ninguna de sus
//  caras es un voladizo al imprimir el cabezal.
// ====================================================================='''

V2_PARAMS = r'''
/* [Bayoneta — la unión de la v2] */
bay_d         = 8.6;   // Ø del vástago del mango
bay_largo     = 13;    // longitud del vástago desde el hombro
bay_holgura   = 0.18;  // holgura radial del taladro
bay_prof      = 1.15;  // saliente radial del tetón / profundidad de la ranura
bay_juego_r   = 0.15;  // holgura radial en el fondo de la ranura
bay_teton_ang = 26;    // ancho angular del tetón, en grados
bay_juego_ang = 4;     // holgura angular por lado en la ranura de entrada
bay_teton_t   = 2.6;   // espesor axial del tetón
bay_z         = 8.4;   // cara inferior del tetón, medida desde el hombro
bay_giro      = 90;    // ángulo de bloqueo
bay_juego_ax  = 0.05;  // juego axial del tetón dentro del canal — CRÍTICO:
                       // si es mayor que la muesca, el tetón flota y la
                       // unión se afloja al lijar de lado (era 0,15 en la 2.0)
bay_rampa     = 0.40;  // cuánto baja el techo del canal a lo largo del giro
bay_muesca    = 0.18;  // resalte de retención antes del asiento (0 = sin clic)
bay_aprieto   = 0.03;  // interferencia en el asiento final
bay_chaflan   = 0.8;   // chaflán de la punta del vástago y de la boca
bay_pasos     = 44;    // resolución angular del canal helicoidal
bay_sentido   = -1;    // -1 = bloquea girando el cabezal a derechas

/* [Asiento — específico de la v2] */
// El hombro del mango tiene que llegar más lejos que el borde de la boca del
// cabezal (r = 5,24 en la v2) o el cabezal va en voladizo sobre el vástago.
// Con el 1,0 del esqueleto el hombro moría en r = 5,00 y no se tocaban.
mango_chaflan_frontal = 0.3;
// Y el mango ergonómico arrancaba en Ø11: con el chaflán, hombro hasta r = 5,20,
// que se queda 0,04 corto. Ø11,6 le da r = 5,50 y sigue siendo más fino que el
// recto en la zona de los dedos.
ergo_d_frente = 11.6;'''

V2_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · bayoneta
// ---------------------------------------------------------------------
function bay_rp() = bay_d / 2;
function bay_rb() = bay_rp() + bay_holgura;
function bay_rt() = bay_rb() - bay_prof;
function bay_rg() = bay_rt() - bay_juego_r;
function bay_ranura_ang() = bay_teton_ang + 2 * bay_juego_ang;
function bay_zt() = bay_z + bay_teton_t;
function bay_ang_total() = bay_ranura_ang() / 2 + bay_giro + bay_teton_ang / 2;
function bay_f_llano() = bay_ang_total() - bay_teton_ang - 3;
function bay_techo(f) =
      f <= 5                 ? bay_zt() + bay_rampa
    : f <= bay_f_llano()     ? bay_zt() + bay_rampa * (1 - (f - 5) / (bay_f_llano() - 5))
    : f <= bay_f_llano() + 3 ? bay_zt() - bay_aprieto - bay_muesca
    :                          bay_zt() - bay_aprieto;

module bay_ranura(sentido) {
    rg = bay_rg(); ro = bay_rp() + 1.2; w = bay_ranura_ang(); ja = bay_juego_ax;
    rotate([0, 0, -w / 2]) translate([0, 0, bay_z - ja])
        linear_extrude(height = bay_largo - bay_z + 1.5) sector2d(rg, ro, w);
    // El canal arranca dos pasos ANTES de la ranura de entrada para que los dos
    // negativos se solapen en volumen y no queden slivers en la unión.
    N = bay_pasos; tot = bay_ang_total();
    for (i = [-2 : N - 1]) {
        f0 = tot * i / N; f1 = tot * (i + 1) / N;
        rotate([0, 0, sentido * (f0 - w / 2)]) translate([0, 0, bay_z - ja])
            linear_extrude(height = bay_techo(max(f0, 0)) - bay_z + ja)
                sector2d(rg, ro, sentido * (f1 - f0 + 0.15), 2);
    }
}
function junta_d() = bay_d;
function junta_largo() = bay_largo;
function junta_giro() = bay_sentido * bay_giro;
module junta_hueco_macho() { }
module junta_macho(sentido = 1) {
    difference() {
        union() {
            cylinder(r = bay_rp(), h = bay_largo - bay_chaflan);
            translate([0, 0, bay_largo - bay_chaflan])
                cylinder(r1 = bay_rp(), r2 = bay_rp() - bay_chaflan, h = bay_chaflan);
        }
        for (k = [0 : 1]) rotate([0, 0, 90 + 180 * k]) bay_ranura(sentido * bay_sentido);
    }
}
module junta_hembra_neg() {
    translate([0, 0, -0.01]) cylinder(r = bay_rb(), h = bay_largo + 0.6);
    translate([0, 0, -0.01])
        cylinder(r1 = bay_rb() + bay_chaflan, r2 = bay_rb(), h = bay_chaflan + 0.01);
}
module junta_hembra_pos() {
    for (k = [0 : 1]) rotate([0, 0, 90 + 180 * k - bay_teton_ang / 2])
        translate([0, 0, bay_z])
            linear_extrude(height = bay_teton_t) sector2d(bay_rt(), bay_rb() + 0.01, bay_teton_ang);
}
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V3 · ROSCA CUADRADA Ø8 x 2
# =====================================================================
V3_HEAD = r'''// =====================================================================
//  SANDING STICK THREAD8 — v3 · unión ROSCADA
//  Versión 3.0 · 2026-09-07 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  Rosca cuadrada Ø8 × paso 2, seis vueltas. Perfil cuadrado en vez de
//  triangular: en FDM se imprime mucho mejor (nada de puntas finas) y agarra
//  más superficie. El cabezal apoya en un hombro plano al final del roscado,
//  así que queda perpendicular y sin juego.
//
//  Es la unión más firme de la familia y la única con cero holgura una vez
//  apretada; a cambio, cambiar de cabezal son tres vueltas de muñeca.
//  El paso es el parámetro sensible: si la rosca va dura, sube ros_holgura.
// ====================================================================='''

V3_PARAMS = r'''
/* [Rosca — la unión de la v3] */
ros_d        = 8.0;   // Ø exterior (cresta) del macho
ros_paso     = 2.0;   // paso
ros_prof     = 0.7;   // profundidad radial del filete
ros_largo    = 12;    // longitud roscada
ros_frac     = 0.40;  // fracción del paso ocupada por el filete
ros_holgura  = 0.25;  // holgura radial de la hembra (subir si va duro)
ros_hol_ax   = 0.15;  // holgura axial por flanco
ros_piloto_d = 8.6;   // Ø del piloto liso que centra antes de roscar
ros_piloto_h = 2.0;   // altura del piloto
ros_chaflan  = 0.9;   // chaflán de entrada
ros_res      = 30;    // rebanadas por vuelta de hélice'''

V3_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · rosca cuadrada
// ---------------------------------------------------------------------
function ros_rk(h) = ros_d / 2 + h;               // radio de cresta
function ros_rc(h) = ros_d / 2 - ros_prof + h;    // radio de núcleo
module ros_perfil2d(h, dang = 0) {
    a = ros_frac * 360 + dang;
    circle(r = ros_rc(h));
    rotate(-a / 2) sector2d(0.3, ros_rk(h) + 0.01, a);
}
// s = -1 para la hembra: el marco de la boca del cabezal está espejado en Z,
// así que hay que invertir la hélice para que salga del mismo sentido que el macho.
module ros_helice(h, largo, dang = 0, s = 1) {
    linear_extrude(height = largo, twist = s * -360 * largo / ros_paso,
                   slices = max(24, ceil(largo / ros_paso * ros_res)), convexity = 10)
        ros_perfil2d(h, dang);
}
// ensanche angular de la hembra que da la holgura axial entre flancos
function ros_dang() = 2 * ros_hol_ax / ros_paso * 360;
function junta_d() = ros_piloto_d;
function junta_largo() = ros_largo + ros_piloto_h;
function junta_giro() = 0;
module junta_hueco_macho() { }
module junta_macho(sentido = 1) {
    difference() {
        union() {
            cylinder(d = ros_piloto_d, h = ros_piloto_h);
            translate([0, 0, ros_piloto_h]) ros_helice(0, ros_largo);
        }
        // chaflán de la punta
        translate([0, 0, ros_piloto_h + ros_largo - ros_chaflan])
            difference() {
                cylinder(r = ros_rk(0) + 1, h = ros_chaflan + 0.1);
                cylinder(r1 = ros_rk(0) - ros_chaflan, r2 = ros_rk(0) - 2 * ros_chaflan,
                         h = ros_chaflan + 0.1);
            }
    }
}
module junta_hembra_neg() {
    translate([0, 0, -0.01]) cylinder(d = ros_piloto_d + 0.4, h = ros_piloto_h + 0.01);
    // Baja un paso entero dentro del piloto: los dos negativos se solapan en
    // volumen (si sólo se tocan, CGAL deja una cavidad cerrada).
    // El marco de la boca está espejado respecto al del macho: hay que invertir
    // la hélice (s = -1) y girarla 180°, o rosca y contrarrosca no casan.
    rotate([0, 0, 180]) translate([0, 0, ros_piloto_h - ros_paso])
        ros_helice(ros_holgura, ros_largo + ros_paso + 0.8, ros_dang(), -1);
    translate([0, 0, -0.01])
        cylinder(r1 = ros_piloto_d / 2 + 0.2 + ros_chaflan, r2 = ros_piloto_d / 2 + 0.2,
                 h = ros_chaflan + 0.01);
}
module junta_hembra_pos() { }
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V4 · IMÁN Ø6x3 + ESPIGA EN D
# =====================================================================
V4_HEAD = r'''// =====================================================================
//  SANDING STICK MAG6 — v4 · unión MAGNÉTICA
//  Versión 4.0 · 2026-09-07 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  Espiga Ø9 con una cara plana (chaveta en D) que impide que el cabezal gire,
//  y un imán de neodimio Ø6 × 3 mm en la punta que hace toda la retención.
//  Otro imán igual al fondo del taladro del cabezal.
//
//  Es el cambio más rápido de la familia: se acerca y se pega solo; se quita
//  tirando. Es la única versión que necesita comprar algo (dos imanes por
//  cabezal más uno por mango) y pegarlos con cianoacrilato.
//
//  IMPORTANTE al pegar: acerca los dos imanes ANTES de encolar para marcar la
//  polaridad; si los pegas al revés, el cabezal se repele.
// ====================================================================='''

V4_PARAMS = r'''
/* [Imán — la unión de la v4] */
mag_d        = 6.0;   // Ø del imán
mag_h        = 3.0;   // espesor del imán
mag_juego    = 0.20;  // holgura del alojamiento (Ø y fondo)
esp_d        = 9.0;   // Ø de la espiga
esp_largo    = 7.5;   // longitud de la espiga
esp_holgura  = 0.20;  // holgura radial del taladro
esp_plano    = 1.4;   // profundidad de la cara plana (chaveta en D)
esp_chaflan  = 0.8;   // chaflán de punta y boca'''

V4_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · imán + espiga en D
// ---------------------------------------------------------------------
function mag_alo_d() = mag_d + 2 * mag_juego;
function mag_alo_h() = mag_h + mag_juego;
function esp_rb() = esp_d / 2 + esp_holgura;
module esp_corte_plano(r, h, extra) {       // quita la cara plana en +Y
    translate([-r - 1, esp_d / 2 - esp_plano + extra, -0.01])
        cube([2 * r + 2, r + 2, h + 0.02]);
}
function junta_d() = esp_d;
function junta_largo() = esp_largo;
function junta_giro() = 0;
module junta_hueco_macho() { }
module junta_macho(sentido = 1) {
    difference() {
        union() {
            cylinder(d = esp_d, h = esp_largo - esp_chaflan);
            translate([0, 0, esp_largo - esp_chaflan])
                cylinder(d1 = esp_d, d2 = esp_d - 2 * esp_chaflan, h = esp_chaflan);
        }
        esp_corte_plano(esp_d / 2, esp_largo, 0);
        translate([0, 0, esp_largo - mag_alo_h()])                  // alojamiento del imán
            cylinder(d = mag_alo_d(), h = mag_alo_h() + 0.01);
    }
}
module junta_hembra_neg() {
    difference() {
        union() {
            translate([0, 0, -0.01]) cylinder(r = esp_rb(), h = esp_largo + 0.5);
            translate([0, 0, -0.01])
                cylinder(r1 = esp_rb() + esp_chaflan, r2 = esp_rb(), h = esp_chaflan + 0.01);
        }
        esp_corte_plano(esp_rb() + esp_chaflan, esp_largo + 0.55, esp_holgura);
    }
    // alojamiento del imán: arranca 0,4 mm dentro del taladro para que los dos
    // negativos se solapen. El imán cae al fondo y su cara queda a 0,3 mm de la
    // cara del imán de la espiga.
    translate([0, 0, esp_largo + 0.1]) cylinder(d = mag_alo_d(), h = mag_alo_h());
}
module junta_hembra_pos() { }
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V5 · CLIP ELÁSTICO (SNAP-FIT)
# =====================================================================
V5_HEAD = r'''// =====================================================================
//  SANDING STICK SNAP — v5 · unión de CLIP ELÁSTICO
//  Versión 5.0 · 2026-09-07 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  El vástago está partido en dos brazos flexibles, cada uno con una pestaña
//  que encaja en un rebaje interior del cabezal. Se empuja hasta el clic y se
//  saca de un tirón: sin girar, sin roscar y sin comprar nada.
//
//  Dos caras planas laterales orientan la pieza (los rebajes están a ±90°) y
//  hacen de chaveta contra el giro. Las pestañas tienen rampa de 40° por los
//  dos lados: entra y sale, no es un encaje permanente.
//
//  El parámetro a tocar si cuesta o se suelta es snap_pest (saliente de la
//  pestaña); snap_ranura controla lo flexibles que son los brazos.
// ====================================================================='''

V5_PARAMS = r'''
/* [Clip elástico — la unión de la v5] */
snap_d       = 8.6;   // Ø del vástago
snap_largo   = 13;    // longitud del vástago
snap_holgura = 0.20;  // holgura radial del taladro
snap_ranura  = 3.8;   // ancho de la ranura que separa los dos brazos
snap_ranura_z= 1.5;   // dónde empieza la ranura (desde el hombro)
snap_pest    = 0.6;   // saliente radial de la pestaña
snap_pest_z  = 8.8;   // inicio de la pestaña desde el hombro
snap_pest_h  = 2.0;   // altura recta de la pestaña
snap_rampa   = 0.9;   // altura de las rampas de 40° arriba y abajo
snap_pest_ang= 62;    // ancho angular del rebaje del cabezal
snap_plano   = 0.9;   // profundidad de las caras planas (chaveta)
snap_chaflan = 0.8;'''

V5_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · clip elástico
// ---------------------------------------------------------------------
function snap_rp() = snap_d / 2;
function snap_rb() = snap_rp() + snap_holgura;
module snap_planos(r, z0, h, extra) {        // quita las dos caras planas (±X)
    p = snap_rp() - snap_plano + extra;
    translate([ p, -r - 1, z0 - 0.01]) cube([r + 2, 2 * r + 2, h + 0.02]);
    translate([-p - (r + 2), -r - 1, z0 - 0.01]) cube([r + 2, 2 * r + 2, h + 0.02]);
}
function junta_d() = snap_d;
function junta_largo() = snap_largo;
function junta_giro() = 0;
module junta_hueco_macho() { }
module junta_macho(sentido = 1) {
    difference() {
        union() {
            cylinder(r = snap_rp(), h = snap_largo - snap_chaflan);
            translate([0, 0, snap_largo - snap_chaflan])
                cylinder(r1 = snap_rp(), r2 = snap_rp() - snap_chaflan, h = snap_chaflan);
            // pestañas en ±Y, sobre la cara exterior de cada brazo
            for (k = [0 : 1]) rotate([0, 0, 90 + 180 * k - snap_pest_ang / 2])
                rotate_extrude(angle = snap_pest_ang, $fn = 96)
                        polygon([[snap_rp() - 0.3, snap_pest_z - snap_rampa],
                                 [snap_rp() + snap_pest, snap_pest_z],
                                 [snap_rp() + snap_pest, snap_pest_z + snap_pest_h],
                                 [snap_rp() - 0.3, snap_pest_z + snap_pest_h + snap_rampa]]);
        }
        snap_planos(snap_rp() + snap_pest, 0, snap_largo + 0.5, 0);
        translate([-snap_rp() - 2, -snap_ranura / 2, snap_ranura_z])   // ranura entre brazos
            cube([2 * snap_rp() + 4, snap_ranura, snap_largo + 1]);
    }
}
module junta_hembra_neg() {
    difference() {
        union() {
            translate([0, 0, -0.01]) cylinder(r = snap_rb(), h = snap_largo + 0.6);
            translate([0, 0, -0.01])
                cylinder(r1 = snap_rb() + snap_chaflan, r2 = snap_rb(), h = snap_chaflan + 0.01);
        }
        snap_planos(snap_rb() + snap_pest + 1, 0, snap_largo + 0.7, snap_holgura);
    }
    // rebajes donde encajan las pestañas
    for (k = [0 : 1]) rotate([0, 0, 90 + 180 * k - (snap_pest_ang + 8) / 2])
        rotate_extrude(angle = snap_pest_ang + 8, $fn = 96)
            polygon([[snap_rb() - 0.01, snap_pest_z - snap_rampa - 0.3],
                     [snap_rb() + snap_pest + 0.15, snap_pest_z - 0.2],
                     [snap_rb() + snap_pest + 0.15, snap_pest_z + snap_pest_h + 0.2],
                     [snap_rb() - 0.01, snap_pest_z + snap_pest_h + snap_rampa + 0.3]]);
}
module junta_hembra_pos() { }
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V6 · COLA DE MILANO TRANSVERSAL CÓNICA
# =====================================================================
V6_HEAD = r'''// =====================================================================
//  SANDING STICK DOVE7 — v6 · unión de COLA DE MILANO transversal
//  Versión 6.0 · 2026-09-08 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  El cabezal no se enchufa: DESLIZA DE LADO sobre un carril de cola de milano
//  en la punta del mango. Es la única unión de la familia cuya dirección de
//  desmontaje no coincide con ninguna dirección de lijado: empujar, tirar y
//  girar actúan sobre el eje del mango o alrededor de él, y el cabezal sale
//  perpendicular a los dos. El propio uso no puede desmontarlo.
//
//  El destalonado de 12° bloquea la tracción POR GEOMETRÍA, no por fricción ni
//  por un brazo elástico: para separar el cabezal del mango habría que romper
//  los labios. Y un carril no puede girar dentro de su ranura, así que el par
//  de lijar de canto lo aguanta la forma, no el ajuste.
//
//  El carril es CÓNICO: la cresta se estrecha 0,7 mm desde el tope hasta la
//  entrada, y la ranura del cabezal se estrecha igual. Así entra holgado y sólo
//  aprieta en el último milímetro, y por el ángulo del milano ese apriete
//  empuja el cabezal contra el hombro del mango — misma cuña autoblocante que
//  la bayoneta de la v2, pero en línea recta.
//
//  Retención en el sentido del deslizamiento: tope duro contra la pared ciega
//  del cabezal por un lado, y un resalte de 0,10 mm en la entrada del carril
//  por el otro. Para pasarlo el cabezal tiene que levantarse ~0,45 mm del
//  hombro, así que se nota como un clic y no cede lijando de lado. El resalte
//  está en el extremo de ENTRADA a propósito: sólo queda cubierto en los
//  últimos 1,5 mm del recorrido, y no roza durante todo el deslizamiento.
//
//  Ninguna pieza necesita soportes. En el cabezal los flancos cierran a 12° de
//  la vertical y en el mango el carril ensancha a 12°: nada baja de 45°.
// ====================================================================='''

V6_PARAMS = r'''
/* [Cola de milano — la unión de la v6] */
cm_alto        = 5.0;   // altura del carril sobre el hombro
cm_cresta      = 7.0;   // ancho de la cresta en el extremo del tope
cm_angulo      = 12;    // ángulo del flanco respecto a la vertical (0 = sin bloqueo)
cm_conicidad   = 0.7;   // cuánto se estrecha la cresta de la entrada al tope:
                        // es lo que hace que deslizar hasta el fondo apriete
cm_aprieto     = 0.04;  // interferencia total de flancos en el asiento — CALIBRAR ÉSTA
cm_muesca      = 0.10;  // resalte de retención en la entrada del carril (0 = sin clic)
cm_muesca_l    = 1.0;   // longitud de la meseta del resalte
cm_juego_mue   = 0.06;  // holgura del hueco del resalte en el cabezal
cm_juego_fondo = 0.6;   // holgura entre la cresta y el fondo de la ranura: tiene que
                        // ser mayor que lo que el cabezal se levanta al pasar la muesca
cm_y_tope      = 3.0;   // cara de tope del carril, medida desde el eje
cm_juego_tope  = 0.15;  // juego entre esa cara y la pared ciega del cabezal
cm_y_entrada   = -4.9;  // final del carril por el lado de entrada
cm_chaflan     = 0.6;   // chaflán de la cresta y avellanado de la boca
cm_orient      = 90;    // giro de la unión sobre el eje de la herramienta. Con 90 el
                        // carril desliza perpendicular a la cara de lijado y la ranura
                        // del cabezal sale hacia ARRIBA al imprimir: flancos verticales,
                        // cero voladizos, y la presión de lijar mete el cabezal contra
                        // su tope en vez de sacarlo. Con 0 desliza de lado, pero los
                        // flancos quedan a 12° de la horizontal y hay que soportarlos.

/* [Asiento — específico de la v6] */
// La boca del cabezal acaba en Ø10,48: con 0,4 el hombro llega a Ø11,2 y apoya
// en toda la corona. Aquí el hombro es TODA la superficie de apoyo, así que es
// lo que impide que el cabezal bascule.
mango_chaflan_frontal = 0.4;'''

V6_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · cola de milano transversal cónica
// ---------------------------------------------------------------------
function cm_tapa_r() = mango_diametro / 2 - mango_chaflan_frontal;
// Referencia geométrica del cono: donde la cresta a tope tocaría el borde de la punta
function cm_y0()  = -sqrt(pow(cm_tapa_r(), 2) - pow(cm_cresta / 2, 2));
function cm_rec() = cm_y_tope - cm_y0();
function cm_w(y)  = cm_cresta - cm_conicidad * (cm_y_tope - y) / cm_rec();
function cm_yc()  = cm_y_tope + cm_juego_tope;      // pared ciega del cabezal

// Perfil del carril en el plano (x = ancho, z = altura). La cresta es más ancha
// que la base: ese destalonado es todo el bloqueo axial de la unión.
// `dx` desplaza los dos flancos hacia fuera (holguras, apriete, muesca).
module cm_perfil(w, dx = 0, fondo = 0) {
    wb = w - 2 * cm_alto * tan(cm_angulo);
    if (fondo > 0)
        polygon([[-wb/2 - dx, 0], [wb/2 + dx, 0], [w/2 + dx, cm_alto],
                 [w/2 + dx, cm_alto + fondo], [-w/2 - dx, cm_alto + fondo],
                 [-w/2 - dx, cm_alto]]);
    else
        polygon([[-wb/2 - dx, 0], [wb/2 + dx, 0], [w/2 + dx, cm_alto], [-w/2 - dx, cm_alto]]);
}
// Losa infinitesimal en el plano y = cte, para construir el carril por hull()
module cm_losa(y, dx = 0, fondo = 0) {
    translate([0, y, 0]) rotate([90, 0, 0]) linear_extrude(height = 0.01)
        cm_perfil(cm_w(y), dx, fondo);
}
// Resalte de retención: rampa · meseta · rampa, en el extremo de entrada
module cm_resalte(dx, base) {
    ya = max(cm_y_entrada, cm_y0()) + 0.4; yb = ya + cm_muesca_l;
    hull() { cm_losa(ya - 0.7, base);  cm_losa(ya,      base + dx); }
    hull() { cm_losa(ya,       base + dx); cm_losa(yb,  base + dx); }
    hull() { cm_losa(yb,       base + dx); cm_losa(yb + 0.7, base); }
}

function junta_d() = cm_cresta;   // lo que deja libre al plano del mango doble
function junta_largo() = cm_alto;
function junta_giro() = 0;     // esta unión no gira: entra de lado
module junta_hueco_macho() { }

// Los marcos del mango y de la boca del cabezal están espejados en X, así que la
// misma orientación se pide con giros de signo contrario. Si se igualan, la conicidad
// del carril queda invertida y pieza="interferencia" lo canta al instante.
module junta_macho(sentido = 1) {
    rotate([0, 0, -cm_orient]) intersection() {
        union() {
            hull() { cm_losa(cm_y0() - 1.5); cm_losa(cm_y_tope); }
            if (cm_muesca > 0) cm_resalte(cm_muesca, 0);
        }
        // contorno de la punta del mango, con chaflán en la cresta
        union() {
            cylinder(r = cm_tapa_r(), h = cm_alto - cm_chaflan);
            translate([0, 0, cm_alto - cm_chaflan])
                cylinder(r1 = cm_tapa_r(), r2 = cm_tapa_r() - cm_chaflan, h = cm_chaflan);
        }
        // tope duro por delante, nariz recortada por detrás
        translate([-20, cm_y_entrada, -1]) cube([40, cm_y_tope - cm_y_entrada, cm_alto + 2]);
    }
}

module junta_hembra_neg() {
    rotate([0, 0, cm_orient]) {
    // ranura cónica, abierta por -Y y ciega en cm_yc()
    hull() { cm_losa(-9, -cm_aprieto / 2, cm_juego_fondo);
             cm_losa(cm_yc(), -cm_aprieto / 2, cm_juego_fondo); }
    // avellanado de entrada: se solapa en volumen con la ranura, no sólo la toca
    hull() { cm_losa(-9, cm_chaflan - cm_aprieto / 2, cm_juego_fondo + cm_chaflan);
             cm_losa(-4.0, -cm_aprieto / 2, cm_juego_fondo); }
    // hueco donde cae el resalte al asentar
    if (cm_muesca > 0) cm_resalte(cm_muesca + cm_juego_mue, -cm_aprieto / 2);
    }
}
module junta_hembra_pos() { }
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V7 · CONO AUTOBLOCANTE (MORSE) CON DOS PLANOS
# =====================================================================
V7_HEAD = r'''// =====================================================================
//  SANDING STICK CONO12 — v7 · unión CÓNICA autoblocante
//  Versión 7.0 · 2026-09-09 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  Un cono de 12° de semiángulo en vez de un vástago cilíndrico. Es la v1
//  hecha bien: un ajuste a presión, pero SIN HOLGURA QUE CALIBRAR. Un cilindro
//  necesita hueco para entrar, y ese hueco es exactamente el juego con el que
//  luego baila; un cono entra hasta donde le deja la interferencia y se queda
//  tocando en toda la superficie. Cero juego radial, cero angular, cero
//  basculamiento, sin depender de acertar una décima.
//
//  Por debajo del ángulo de rozamiento del PLA (~17°) un cono es
//  autorretenedor: no se suelta solo, y agarra con la fuerza que le hayas
//  metido con el pulgar. Con 12° queda firme y sale de un tirón; con 7° agarra
//  más pero hay que golpearlo, y la profundidad de asiento se mueve el doble.
//
//  Dos planos, TAMBIÉN CÓNICOS, hacen de chaveta. Al escalar con el cono
//  aprietan a la vez que él, así que el giro tampoco tiene juego. Un plano
//  paralelo al eje no valdría: se separaría de su cara en cuanto la
//  profundidad de asiento variara un poco.
//
//  EL CABEZAL NO APOYA EN EL HOMBRO, y es a propósito. Quien lo sitúa es el
//  cono, como en un cono Morse: si el hombro tocase, los dos se pelearían por
//  posicionar y el cono dejaría de apretar. En nominal la boca del cabezal
//  queda a ras del hombro —macho y hembra son EL MISMO cono, interferencia
//  cero por construcción— pero la profundidad real la pone el ajuste: cada
//  0,1 mm de error radial la mueve 0,47 mm. Como un taladro impreso en
//  horizontal tiende a salir estrecho, lo normal es que se abra una junta de
//  medio milímetro entre las dos piezas. No afecta a cómo sujeta y `con_retro`
//  la cierra. Por eso el chaflán frontal del mango es de 1,7 y no de 1,0: la
//  junta cae dentro de una V entre los dos chaflanes, que es donde no canta.
//
//  Dos topes de seguridad, que con un ajuste normal no llegan a tocar: el
//  taladro deja 0,8 mm delante de la punta, y si el cono entrase muy suelto la
//  boca del cabezal se apoyaría en el chaflán del mango medio milímetro más
//  adentro, antes de que la cuña pudiera abrir una pared de 1,6 mm.
// ====================================================================='''

V7_PARAMS = r'''
/* [Cono — la unión de la v7] */
con_d_base    = 8.4;   // Ø del cono en su arranque, al final del cuello
con_angulo    = 12;    // semiángulo. Por debajo de ~17° (rozamiento del PLA) el
                       // cono es autorretenedor. Bajarlo agarra más, cuesta más
                       // sacarlo y mueve más el asiento: 1/tan(α) mm por mm
con_largo     = 9.0;   // longitud del cono
con_cuello    = 1.0;   // cuello rebajado antes del cono: por donde pasa la boca
con_retro     = 0;     // corrección de la profundidad de asiento, en mm de
                       // recorrido: -0,3 mete el cabezal 0,3 mm más hacia el
                       // mango. En nominal vale 0 y macho y hembra son el mismo
                       // cono. Es lo único calibrable, y sólo mueve la junta
con_plano     = 1.0;   // profundidad de cada plano de chaveta, en la base
con_relieve   = 0.3;   // cuánto se rebaja el cuello respecto al cono
con_fondo     = 0.8;   // hueco delante de la punta: tope de seguridad
con_chaflan   = 0.6;   // chaflán de la punta del cono
con_avellanado = 0.4;  // avellanado de la boca del cabezal. No subirlo: por
                       // encima de 0,4 se come el anillo de la boca, que es el
                       // segundo tope de seguridad

/* [Asiento — específico de la v7] */
// Al revés que en las demás: aquí el hombro NO debe tocar. La punta del mango
// acaba en Ø8,60 y el anillo de la boca del cabezal empieza en Ø9,63, así que
// se cruzan sin rozarse y el cabezal puede entrar medio milímetro de más si el
// ajuste sale suelto. Por debajo de 1,59 el anillo apoyaría en la cara de la
// punta y le disputaría el asiento al cono.
mango_chaflan_frontal = 1.7;'''

V7_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · cono autoblocante con dos planos de chaveta
// ---------------------------------------------------------------------
function con_r()    = con_d_base / 2;
function con_tan()  = tan(con_angulo);
function con_zap()  = con_cuello + con_r() / con_tan();   // altura del vértice
function con_R(z)   = (con_zap() - z) * con_tan();        // radio del cono a la altura z
function con_prop() = (con_r() - con_plano) / con_r();    // planos, en fracción del radio
function con_rp()   = con_R(con_cuello + con_largo);      // radio en la punta

// Círculo recortado por dos planos. El cono entero es una homotecia desde su
// vértice, así que los planos se estrechan con él y quedan paralelos a la
// generatriz: aprietan cuando aprieta el cono. Un plano paralelo al eje se
// separaría de su cara en cuanto la profundidad de asiento variara.
module con_perfil(R) {
    intersection() {
        circle(r = R);
        square([2 * R + 2, 2 * R * con_prop()], center = true);
    }
}
module con_losa(z, dr = 0) {
    translate([0, 0, z]) linear_extrude(height = 0.01) con_perfil(con_R(z) - dr);
}
module con_tramo(z0, z1, dr = 0) {
    R0 = con_R(z0) - dr; R1 = con_R(z1) - dr;
    translate([0, 0, z0]) linear_extrude(height = z1 - z0, scale = R1 / R0, convexity = 6)
        con_perfil(R0);
}

function junta_d() = con_d_base;
function junta_largo() = con_cuello + con_largo;
function junta_giro() = 0;      // esta unión no gira: entra recta y hace cuña
module junta_hueco_macho() { }

module junta_macho(sentido = 1) {
    // Cuello: el MISMO perfil rebajado `con_relieve` en radio, no un cilindro.
    // Un cilindro de revolución se comería los planos del taladro (fue el fallo
    // de la primera versión: 2,5 mm³ de interferencia justo en la boca), y
    // además dejaría aquí la sección más débil de toda la pieza.
    con_tramo(-0.01, con_cuello - 0.3, con_relieve);
    hull() {                                    // enlace a 45° con la base del cono
        con_losa(con_cuello - 0.3, con_relieve);
        con_losa(con_cuello);
    }
    intersection() {
        con_tramo(con_cuello, con_cuello + con_largo);
        union() {
            cylinder(r = con_r() + 1, h = junta_largo() - con_chaflan);
            translate([0, 0, junta_largo() - con_chaflan])
                cylinder(r1 = con_rp(), r2 = con_rp() - con_chaflan, h = con_chaflan);
        }
    }
}

// El taladro es el MISMO cono corrido `con_retro`: su radio a la profundidad z'
// vale con_R(z' + con_retro). Con con_retro = 0 macho y hembra son idénticos y
// la interferencia es cero por construcción. Baja hasta con_fondo por delante
// de la punta.
module junta_hembra_neg() {
    z0 = -0.5;                                   // asoma por la boca: se solapa en
    z1 = junta_largo() + con_fondo - con_retro;  //   volumen con el avellanado
    R0 = con_R(z0 + con_retro); R1 = con_R(z1 + con_retro);
    translate([0, 0, z0]) linear_extrude(height = z1 - z0, scale = R1 / R0, convexity = 6)
        con_perfil(R0);
    rm = con_R(con_retro);
    translate([0, 0, -0.01])
        cylinder(r1 = rm + con_avellanado, r2 = rm, h = con_avellanado + 0.01);
}
module junta_hembra_pos() { }
module junta_extra() { }
module junta_extra_montado() { }'''

# =====================================================================
#  V8 · ESPIGA Y CUÑA TRANSVERSAL
# =====================================================================
V8_HEAD = r'''// =====================================================================
//  SANDING STICK CUÑA — v8 · unión de ESPIGA Y CUÑA transversal
//  Versión 8.0 · 2026-09-09 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  La unión de carpintería de toda la vida, a escala de bolígrafo. El vástago
//  del mango lleva una ranura transversal; el cabezal, un alojamiento alineado
//  con ella; y una cuña impresa entra de lado atravesando los dos. Como es
//  cónica (1:12), meterla TIRA del vástago hacia dentro y aprieta el cabezal
//  contra el hombro del mango.
//
//  Es la única de la familia con APRIETE REGULABLE: no depende de acertar una
//  holgura, sino de cuánto empujes. Si dentro de un año la unión baila, metes
//  la cuña medio milímetro más y vuelve a estar como el primer día. Hay 7 mm de
//  recorrido de apriete, y la pendiente 1:12 está muy por debajo del ángulo de
//  rozamiento del PLA: la cuña no se sale sola.
//
//  La cuña es además la CHAVETA. Atraviesa el vástago, así que el giro lo
//  bloquea ella y el taladro puede ser un cilindro liso con holgura normal.
//  Y como mide 13,6 mm de largo dentro de un vástago de Ø8,6, resiste el
//  descuadre mucho mejor de lo que sugiere su holgura lateral de 0,08.
//
//  EL PRECIO, DICHO SIN RODEOS: es la unión que más debilita el cabezal. Para
//  que la cuña pase hay que abrir un túnel de 5 mm de ancho de lado a lado, y
//  eso se come parte de la sección justo donde el cabezal trabaja a flexión.
//  Está colocado lo más adentro posible —a 7,8 mm de la boca, donde el momento
//  ya ha bajado, y antes de los 13 mm donde arranca la pala— pero sigue siendo
//  el punto débil. Los números están en el README.
//
//  La cuña sobresale ~1 mm por cada lado. Es lo que permite empujarla para
//  apretar y golpearla para sacarla, y es inevitable en una unión de cuña.
// ====================================================================='''

V8_PARAMS = r'''
/* [Cuña — la unión de la v8] */
cun_d       = 8.6;    // Ø del vástago
cun_largo   = 13;     // longitud del vástago
cun_holgura = 0.15;   // holgura radial del taladro. Aquí no es crítica: quien
                      // quita el juego es la cuña al apretar contra el hombro
cun_z       = 7.8;    // altura de la cara de apoyo de la cuña, desde el hombro.
                      // Subirlo debilita menos el cabezal pero se acerca a la
                      // pala; bajarlo lo debilita donde más momento hay
cun_ancho   = 5.0;    // ancho de la cuña
cun_esp     = 2.6;    // espesor de la cuña en su posición nominal
cun_pend    = 0.0833; // pendiente 1:12: cuánto engorda por mm de avance
cun_l       = 13.6;   // longitud de la cuña (sobresale ~1 mm por lado)
cun_hol     = 0.08;   // holgura lateral de la cuña en sus dos alojamientos
cun_juego   = 0.6;    // cuánto más alto es el alojamiento del cabezal que la
                      // cuña: dividido por la pendiente, 7,2 mm de apriete
cun_rebaje  = 0.4;    // hueco bajo la cuña dentro de la ranura del vástago
cun_chaflan = 0.8;    // chaflán de la punta del vástago
cun_avell   = 0.4;    // avellanado de la boca del cabezal. NO subirlo: con 0,8
                      // el avellanado se come el borde que deja cuerpo_chaflan y
                      // la boca acaba en filo, sin cara plana contra la que
                      // pueda apretar la cuña (medido: 0,63 mm² de apoyo con
                      // 0,8 · 11,0 mm² con 0,4)

/* [Asiento — específico de la v8] */
// Aquí el hombro es la superficie de apoyo, y la cuña es lo que empuja contra
// él: tiene que llegar más lejos que el borde de la boca del cabezal (Ø10,48).
// Con 0,4 llega a Ø11,2 y la corona real de apoyo es de 11,0 mm².
mango_chaflan_frontal = 0.4;'''

V8_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · espiga y cuña transversal
// ---------------------------------------------------------------------
function cun_t(y)  = cun_esp - cun_pend * y;   // espesor de la cuña en y
function cun_y0()  = -cun_l / 2;
function cun_y1()  =  cun_l / 2;

// La cuña, y de paso sus dos alojamientos: la misma sección con márgenes.
// La sección real está en el plano (y, z) —un trapecio— y se extruye en x.
// El lado GRUESO va hacia -Y, que es por donde se empuja: al avanzar en +Y,
// el material que llega a la ranura del vástago es cada vez más grueso.
module cun_cuna(dx = 0, dtop = 0, dbot = 0, y0 = 0, y1 = 0) {
    a = cun_y0() - y0; b = cun_y1() + y1;
    translate([-cun_ancho / 2 - dx, 0, 0])
        multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
            linear_extrude(height = cun_ancho + 2 * dx)
                polygon([[a, cun_z - dbot], [b, cun_z - dbot],
                         [b, cun_z + cun_t(b) + dtop], [a, cun_z + cun_t(a) + dtop]]);
}

function junta_d() = cun_d;
function junta_largo() = cun_largo;
function junta_giro() = 0;     // no gira: entra recto y la cuña hace el resto
module junta_hueco_macho() { }

module junta_macho(sentido = 1) {
    difference() {
        union() {
            cylinder(d = cun_d, h = cun_largo - cun_chaflan);
            translate([0, 0, cun_largo - cun_chaflan])
                cylinder(d1 = cun_d, d2 = cun_d - 2 * cun_chaflan, h = cun_chaflan);
        }
        // Ranura del vástago. Su TECHO es la cara de apriete: coincide con el
        // dorso de la cuña, sin holgura, porque es donde se transmite el tiro.
        // El suelo queda `cun_rebaje` por debajo para que la cuña no se apoye
        // en él en vez de en el cabezal.
        cun_cuna(cun_hol, 0, cun_rebaje, 4, 4);
    }
}

module junta_hembra_neg() {
    translate([0, 0, -0.01]) cylinder(d = cun_d + 2 * cun_holgura, h = cun_largo + 0.5);
    translate([0, 0, -0.01])
        cylinder(d1 = cun_d + 2 * cun_holgura + 2 * cun_avell, d2 = cun_d + 2 * cun_holgura,
                 h = cun_avell + 0.01);
    // Túnel de la cuña: `cun_juego` más alto que ella, que es el recorrido de
    // apriete. Su SUELO es la otra cara de trabajo, y va sin holgura.
    cun_cuna(cun_hol, cun_juego, 0, 4, 4);
}
module junta_hembra_pos() { }

// La cuña suelta, tumbada sobre su cara plana para imprimir
module junta_extra() { translate([0, 0, -cun_z]) cun_cuna(); }
module junta_extra_montado() { cun_cuna(); }'''

# =====================================================================
#  V9 · PINZA CÓNICA CON CASQUILLO DE APRIETE
# =====================================================================
V9_HEAD = r'''// =====================================================================
//  SANDING STICK PINZA — v9 · unión de PINZA CÓNICA
//  Versión 9.0 · 2026-09-09 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  Una pinza de portaminas. La boca del cabezal va partida en cuatro dedos por
//  ranuras axiales, y su exterior es un cono; un casquillo cónico se empuja con
//  el pulgar sobre ese cono y cierra los dedos sobre el vástago del mango.
//
//  Lo que ninguna otra versión tiene: **el apriete no se agota**. Las demás
//  reparten un número fijo de holgura y cuando el uso se lo come, se acabó. Aquí
//  hay 2 mm de recorrido de casquillo y cada milímetro cierra 0,125 mm de
//  diámetro, así que la unión se puede reapretar durante toda la vida de la
//  herramienta. Y el agarre es todo el que quieras darle: la conicidad 1:8
//  multiplica por ocho la fuerza del pulgar y está muy por debajo del ángulo de
//  rozamiento del PLA, así que el casquillo no se afloja solo.
//
//  LA PINZA VA EN EL CABEZAL, no en el mango, y no es un capricho: si fuera al
//  revés los cabezales necesitarían un vástago macho saliendo en horizontal de
//  la boca, y dejarían de poder imprimirse planos sobre su cara de lijado, que
//  es la decisión de la que cuelga todo el proyecto. A cambio, el mango es el
//  más simple de las nueve versiones: un cilindro liso de Ø8,6. Y cada cabezal
//  se puede montar sobre cualquier varilla de Ø8,6 — un tubo largo para llegar
//  al fondo de una caja, por ejemplo.
//
//  El casquillo no se pierde: por detrás no puede pasar al mango (su taladro
//  trasero es de Ø11,05 y el mango es de Ø12) y por delante topa con el cuerpo
//  del cabezal. Sólo sale con el cabezal desmontado, que es cuando toca
//  limpiarlo.
//
//  Es la más voluminosa de la familia: un collar de Ø14,6 × 6 mm en la punta.
//  Y la deformación de trabajo del dedo es del 0,48 %, un tercio de la del clip
//  de la v5, porque el dedo es corto y sólo tiene que cerrar 0,075 mm.
// ====================================================================='''

V9_PARAMS = r'''
/* [Pinza — la unión de la v9] */
pin_d        = 8.6;    // Ø del vástago del mango. Es toda la parte macho
pin_largo    = 12;     // longitud del vástago
pin_holgura  = 0.15;   // holgura diametral del taladro con el casquillo suelto
pin_dedos    = 4;      // número de dedos de la pinza
pin_ranura   = 0.8;    // ancho de las ranuras entre dedos
pin_l_dedo   = 10;     // longitud de los dedos
pin_alivio   = 1.4;    // Ø del taladro de alivio al final de cada ranura: sin él
                       // la ranura acaba en un ángulo vivo y es donde agrietaría
pin_d_boca   = 11.0;   // Ø exterior de la pinza en la boca
pin_pend     = 0.125;  // conicidad del exterior de la pinza, en Ø por mm (1:8)
pin_z_cono   = 6.0;    // hasta dónde llega el cono exterior
pin_col_d    = 14.6;   // Ø exterior del casquillo
pin_col_l    = 6.0;    // longitud del casquillo
pin_col_hol  = 0.05;   // holgura del casquillo en reposo: el apriete empieza
                       // después de 0,4 mm de recorrido
pin_col_flauta = 6;    // acanaladuras de agarre del casquillo
pin_chaflan  = 0.6;    // chaflán de la punta del vástago y de la boca

/* [Asiento — específico de la v9] */
// El hombro tiene que llegar a la corona del cabezal (Ø8,75 a Ø11,0) pero
// quedarse por dentro del taladro trasero del casquillo (Ø11,05) o se tocarían.
// Con 0,6 muere en Ø10,8: apoya en 1,0 mm de corona y deja 0,125 de margen.
mango_chaflan_frontal = 0.6;'''

V9_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · pinza cónica con casquillo de apriete
// ---------------------------------------------------------------------
function pin_H(z)  = pin_d_boca + pin_pend * z;      // Ø exterior de la pinza
function pin_rb()  = pin_d / 2 + pin_holgura / 2;    // radio del taladro

function junta_d() = pin_d;
function junta_largo() = pin_largo;
function junta_giro() = 0;
module junta_hueco_macho() { }

// El macho más simple de la familia: un cilindro liso. Todo el mecanismo está
// en el cabezal y en el casquillo.
module junta_macho(sentido = 1) {
    cylinder(d = pin_d, h = pin_largo - pin_chaflan);
    translate([0, 0, pin_largo - pin_chaflan])
        cylinder(d1 = pin_d, d2 = pin_d - 2 * pin_chaflan, h = pin_chaflan);
}

module junta_hembra_neg() {
    // taladro y avellanado
    translate([0, 0, -0.01]) cylinder(r = pin_rb(), h = pin_largo + 0.5);
    translate([0, 0, -0.01])
        cylinder(r1 = pin_rb() + pin_chaflan, r2 = pin_rb(), h = pin_chaflan + 0.01);
    // cono exterior: se rebaja el cuerpo Ø12 hasta la generatriz de la pinza
    difference() {
        translate([0, 0, -0.01]) cylinder(r = 20, h = pin_z_cono + 0.01);
        translate([0, 0, -0.02])
            cylinder(d1 = pin_H(-0.02), d2 = pin_H(pin_z_cono + 0.02), h = pin_z_cono + 0.04);
    }
    // ranuras entre dedos, cada una acabada en su taladro de alivio.
    // A 45° para que ninguna caiga en el plano horizontal ni en el vertical del
    // cabezal al imprimir: así ninguna cara de ranura baja de 45°.
    for (k = [0 : pin_dedos - 1]) rotate([0, 0, 360 * k / pin_dedos + 45]) {
        translate([-pin_ranura / 2, 0, -0.01]) cube([pin_ranura, 10, pin_l_dedo + 0.01]);
        translate([0, 0, pin_l_dedo]) rotate([-90, 0, 0]) cylinder(d = pin_alivio, h = 10);
    }
}
module junta_hembra_pos() { }

// ---- el casquillo -----------------------------------------------------
// Su taladro es el mismo cono que la pinza, más `pin_col_hol`. Empujarlo hacia
// la pala lo lleva sobre diámetros mayores y cierra los dedos; tirar de él hacia
// el mango lo libera. Se imprime de pie: así el taladro cónico se abre hacia
// arriba —sin voladizos— y la tracción de aro cae dentro de las capas, no entre
// ellas, que es donde el PLA no aguanta.
module pin_casquillo() {
    difference() {
        cylinder(d = pin_col_d, h = pin_col_l);
        translate([0, 0, -0.01])
            cylinder(d1 = pin_H(0) + pin_col_hol, d2 = pin_H(pin_col_l) + pin_col_hol,
                     h = pin_col_l + 0.02);
        // acanaladuras de agarre
        for (k = [0 : pin_col_flauta - 1]) rotate([0, 0, 360 * k / pin_col_flauta])
            translate([pin_col_d / 2 + 1.0, 0, -0.01]) cylinder(d = 3.0, h = pin_col_l + 0.02);
        // Chaflanes de los dos cantos. Van como ANILLO a restar, no como cono:
        // un cono macizo con el radio grande abajo se lleva por delante toda la
        // pieza en su primer plano, que fue lo que pasó en el primer intento.
        for (t = [0, 1]) translate([0, 0, t * (pin_col_l - 0.5)]) difference() {
            translate([0, 0, -0.01]) cylinder(r = pin_col_d, h = 0.5 + 0.02);
            translate([0, 0, -0.02])
                cylinder(r1 = pin_col_d / 2 - (t ? 0 : 0.5), r2 = pin_col_d / 2 - (t ? 0.5 : 0),
                         h = 0.5 + 0.04);
        }
    }
}
module junta_extra() { pin_casquillo(); }
module junta_extra_montado() { pin_casquillo(); }'''

# =====================================================================
#  V10 · DOBLE ESPIGA CON CLIC
# =====================================================================
V10_HEAD = r'''// =====================================================================
//  SANDING STICK 2ESPIGAS — v10 · unión de DOBLE ESPIGA con clic
//  Versión 10.1 · 9 de septiembre de 2026 · Jorge (con Claude) · OpenSCAD 2021.01+
//
//  v10.2 — LA 10.1 TAMBIÉN SE ROMPIÓ, y por otro sitio: una espiga se partió
//  por la BASE al despegar la pieza de la cama. Las espigas macizas de Ø3,4
//  eran voladizos verticales de 12 mm que llegaban al hombro en ángulo vivo, y
//  con la raíz trabajando entre capas eso son 0,5 kg de fuerza lateral en la
//  punta. Un vástago Ø8,6 de las otras versiones aguanta 8,8.
//
//  Tres cambios, y los tres van al mismo sitio — la tensión en la raíz, que
//  vale M/W y crece con el largo y con el ángulo vivo:
//    · Ø3,4 → Ø4,0, el máximo que deja la geometría (ver abajo): W ×1,6
//    · 12 → 9 mm de largo: momento ×0,75
//    · RAÍZ CÓNICA de Ø4,4 en 1,5 mm en vez de ángulo vivo: mata el
//      concentrador (Kt de 1,8 a 1,2) y engorda la sección justo donde rompe
//  Juntos: de 0,5 a 2,4 kg. Cinco veces, y sigue siendo la unión más frágil de
//  las diez — eso hay que saberlo al elegirla.
//
//  El acuerdo cóncavo de toda la vida NO CABÍA: dos de R1,2 separados 5,6 mm se
//  tocan entre sí y se salen del hombro, y el rebaje que el cabezal necesitaría
//  para librarlos se comería la corona de apoyo entera. La raíz cónica hace el
//  mismo trabajo y el taladro del cabezal la copia sin rebaje ninguno.
//
//  EL TECHO DEL CONCEPTO, para que quede escrito: con el cuerpo en Ø12, para
//  que al cabezal le queden 1,1 mm de pared por fuera de cada taladro y 1,45 de
//  alma entre los dos, la espiga no puede pasar de Ø4,0. No hay más margen.
//
//  v10.1 — LA 10.0 SE ROMPÍA. Las espigas iban partidas en dos brazos cada una
//  y al primer montaje a mano se partieron. La ficha decía 0,56 % de
//  deformación y era falso por dos motivos: se tomó como voladizo la ranura
//  entera (9 mm) en vez de la distancia real hasta la pestaña (6,2), y se trató
//  la sección como un rectángulo de 1,2 cuando es un segmento circular con la
//  fibra exterior a 0,70 del centroide. El número real era 1,37 %.
//
//  Pero el fallo de fondo era otro, y es el que hay que recordar: **el brazo
//  era un voladizo vertical en una pieza que se imprime de pie**, así que la
//  tracción iba ENTRE CAPAS, que es donde el PLA rompe sobre el 1 %. El clip de
//  la v5 trabaja aún peor (1,9 %) pero con 4,6 veces más sección — y por eso su
//  ficha lleva desde el principio el aviso de imprimirlo en PETG.
//
//  La regla que sale de aquí: **lo que flexa va en el CABEZAL, no en el mango.**
//  El mango se imprime de pie y cualquier voladizo suyo flexa entre capas; el
//  cabezal se imprime tumbado sobre su cara de lijado, así que una lengüeta suya
//  que flexe hacia los lados trabaja DENTRO del plano de la capa.
//
//  Así queda: las espigas son MACIZAS —9,08 mm² cada una, no hay nada que
//  romper— y llevan una garganta. Quien flexa es el cabezal: la pared exterior
//  sobre cada taladro, liberada por dos ranuras, hace de lengüeta y lleva la
//  pestaña.
//
//  Y flexa poquísimo: la pestaña sobresale 0,18 dentro de un taladro que ya es
//  0,075 más ancho que la espiga, así que **lo que la lengüeta tiene que
//  abrirse es 0,105 mm**, no 0,18. Con 1,5 de pared, 3,0 de ancho y 7,0 de
//  voladizo eso son 0,49 % de deformación, y encima en el plano bueno. Frente
//  al 1,37 % entre capas de la 10.0.
//
//  Ese mismo 0,105 es el escalón que retiene. Como la retención sale del
//  ÁNGULO del canto y no de su profundidad, el canto de arriba es corto a
//  propósito (0,15 para 0,24 de garganta, unos 64°): retiene de sobra sin
//  pedirle a la lengüeta ni una décima más de recorrido. `esp2_gar_sube` es el
//  parámetro con el que se gradúa — a 0,08 cuesta mucho sacarlo, a 0,30 sale
//  solo.
//
//  Las espigas se separan ahora en el eje que en el cabezal impreso es el
//  HORIZONTAL, no el vertical: así las lengüetas caen en los costados y no en
//  la cara que apoya en la cama. Se pierde algo de par de fuerzas contra la
//  presión de lijado, pero quien se come ese momento es la corona de apoyo de
//  51,6 mm², que sigue siendo la mayor de las diez.
// ====================================================================='''

V10_PARAMS = r'''
/* [Doble espiga — la unión de la v10] */
esp2_d        = 4.0;    // Ø de cada espiga. MACIZA, y es el máximo que cabe:
                        // subirlo deja al cabezal sin pared o sin alma
esp2_d_raiz   = 4.4;    // Ø en el arranque. La raíz va cónica para que no haya
                        // ángulo vivo donde el momento es máximo
esp2_raiz_h   = 1.5;    // altura de esa transición
esp2_sep      = 5.6;    // separación entre ejes. Cuanto mayor, menos juego
                        // angular (vale holgura/(sep/2)) y menos alma le queda
                        // al cabezal entre los dos taladros
esp2_largo    = 9;      // longitud de las espigas. Cada milímetro de más es
                        // momento de más en la raíz, que es por donde rompen
esp2_holgura  = 0.075;  // holgura radial del taladro. Con 0,075 el juego de giro
                        // es de 1,6°; bajarla a 0,05 lo deja en 1,1°
esp2_gar_z    = 5.9;    // dónde empieza la garganta de la espiga
esp2_gar_h    = 1.2;    // altura de la garganta
esp2_gar_prof = 0.24;   // profundidad de la garganta
esp2_gar_sube = 0.15;   // rampa del canto de arriba. Es el canto que la pestaña
                        // tiene que trepar para salir: cuanto más corto, más
                        // retiene y más cuesta desmontar
esp2_gar_baja = 0.50;   // rampa del canto de abajo, que no trabaja
esp2_pest     = 0.18;   // resalte de la pestaña, ahora en el cabezal
esp2_pest_ang = 100;    // ancho angular de la pestaña sobre la lengüeta
esp2_leng_a   = 3.0;    // ancho de la lengüeta
esp2_leng_ran = 0.8;    // ranuras que la liberan
esp2_leng_z0  = 1.4;    // dónde arrancan esas ranuras. La boca que queda entera
                        // es la que salva la corona de apoyo; con las espigas
                        // más cortas hay que arrancar antes o la lengüeta se
                        // queda sin voladizo y pasa a trabajar al doble
esp2_chaflan  = 0.6;    // chaflán de la punta y de la boca

/* [Asiento — específico de la v10] */
// Aquí el hombro es TODO. Con 0,4 llega a Ø11,2 y la boca del cabezal acaba en
// Ø10,48: apoyan en toda la corona, que es la mayor de la familia.
mango_chaflan_frontal = 0.4;'''

V10_JUNTA = r'''
// ---------------------------------------------------------------------
//  JUNTA · doble espiga maciza con lengüeta en el cabezal
// ---------------------------------------------------------------------
function esp2_r()  = esp2_d / 2;
function esp2_rb() = esp2_r() + esp2_holgura;
function esp2_y()  = esp2_sep / 2;

// Separadas en el eje Y de la junta, que en el cabezal impreso es el horizontal:
// las lengüetas caen en los costados, no en la cara que se apoya en la cama.
module esp2_en_las_dos() { for (k = [-1, 1]) translate([0, k * esp2_y(), 0]) children(); }

function junta_d() = 8.6;      // no es un Ø real: es lo que deja al plano
                               // antirrodadura del mango doble un ancho sensato
function junta_largo() = esp2_largo;
function junta_giro() = 0;
module junta_hueco_macho() { }

module junta_macho(sentido = 1) {
    esp2_en_las_dos() difference() {
        union() {
            // raíz cónica: sale del hombro en Ø4,4 y llega a Ø4,0 en 1,5 mm.
            // Al imprimir el mango de pie la sección sólo se estrecha hacia
            // arriba, así que no hay voladizo por ningún lado.
            cylinder(d1 = esp2_d_raiz, d2 = esp2_d, h = esp2_raiz_h);
            cylinder(r = esp2_r(), h = esp2_largo - esp2_chaflan);
            translate([0, 0, esp2_largo - esp2_chaflan])
                cylinder(r1 = esp2_r(), r2 = esp2_r() - esp2_chaflan, h = esp2_chaflan);
        }
        // Garganta. El canto de ARRIBA es el que trabaja: al montar, la pestaña
        // baja por el cono de la punta y cae dentro; al desmontar tiene que
        // treparlo. El de abajo no lo toca nunca y va tendido para que el
        // techo de la garganta no quede en voladizo al imprimir el mango.
        rotate_extrude($fn = 64)
            polygon([[esp2_r() - esp2_gar_prof, esp2_gar_z],
                     [esp2_r() + 0.01,          esp2_gar_z - esp2_gar_baja],
                     [esp2_r() + 0.01,          esp2_gar_z + esp2_gar_h + esp2_gar_sube],
                     [esp2_r() - esp2_gar_prof, esp2_gar_z + esp2_gar_h]]);
    }
}

// Ranura que libera un costado de la lengüeta: va del taladro hacia fuera y
// arranca a esp2_leng_z0 de la boca, para no tocar la corona de apoyo.
module esp2_ranura(k, s) {
    y0 = esp2_y() - 0.4;          // arranca DENTRO del taladro, o la lengüeta
    L  = 8 - y0;                  // seguiría cosida al cabezal por los costados
    translate([s * esp2_leng_a / 2 - (s > 0 ? 0 : esp2_leng_ran),
               k > 0 ? y0 : -8,
               esp2_leng_z0])
        cube([esp2_leng_ran, L, esp2_largo + 1.5]);
}

module junta_hembra_neg() {
    esp2_en_las_dos() {
        translate([0, 0, -0.01]) cylinder(r = esp2_rb(), h = esp2_largo + 0.5);
        // El taladro copia la raíz cónica: así el cabezal asienta sin que haya
        // que rebajarle la boca, que es lo que habría matado la corona.
        translate([0, 0, -0.01])
            cylinder(d1 = esp2_d_raiz + 2 * esp2_holgura, d2 = esp2_d + 2 * esp2_holgura,
                     h = esp2_raiz_h + 0.01);
    }
    for (k = [-1, 1]) for (s = [-1, 1]) esp2_ranura(k, s);
}

// La pestaña va en la cara interior de la lengüeta, mirando hacia fuera del
// cabezal: es la única parte de la unión que flexa, y flexa en el plano de las
// capas. 1,5 de pared × 3,0 de ancho × 7,0 de voladizo, 0,18 de resalte: 0,84 %.
module junta_hembra_pos() {
    for (k = [-1, 1]) translate([0, k * esp2_y(), 0])
        rotate([0, 0, (k > 0 ? 90 : 270) - esp2_pest_ang / 2])
            rotate_extrude(angle = esp2_pest_ang, $fn = 96)
                polygon([[esp2_rb() + 0.01,        esp2_gar_z - 0.30],
                         [esp2_rb() - esp2_pest,   esp2_gar_z + 0.15],
                         [esp2_rb() - esp2_pest,   esp2_gar_z + esp2_gar_h - 0.15],
                         [esp2_rb() + 0.01,        esp2_gar_z + esp2_gar_h + 0.30]]);
}
module junta_extra() { }
module junta_extra_montado() { }'''

VERSIONES = {
    "sanding_stick_v2.scad": (V2_HEAD, V2_PARAMS, V2_JUNTA),
    "sanding_stick_v3.scad": (V3_HEAD, V3_PARAMS, V3_JUNTA),
    "sanding_stick_v4.scad": (V4_HEAD, V4_PARAMS, V4_JUNTA),
    "sanding_stick_v5.scad": (V5_HEAD, V5_PARAMS, V5_JUNTA),
    "sanding_stick_v6.scad": (V6_HEAD, V6_PARAMS, V6_JUNTA),
    "sanding_stick_v7.scad": (V7_HEAD, V7_PARAMS, V7_JUNTA),
    "sanding_stick_v8.scad": (V8_HEAD, V8_PARAMS, V8_JUNTA),
    "sanding_stick_v9.scad": (V9_HEAD, V9_PARAMS, V9_JUNTA),
    "sanding_stick_v10.scad": (V10_HEAD, V10_PARAMS, V10_JUNTA),
}

if __name__ == "__main__":
    for nombre, (cab, par, junta) in VERSIONES.items():
        txt = cab + "\n" + COMUN.replace("__PARAMS__", par).replace("__JUNTA__", junta)
        with open(os.path.join(AQUI, nombre), "w", encoding="utf-8", newline="\n") as f:
            f.write(txt)
        print("escrito", nombre, len(txt), "bytes")
