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
pieza = "conjunto";           // ["mango","cabezal","test_ajuste","conjunto","interferencia"]
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
mango_chaflan_frontal = 1.0;
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
function plano_efectivo() = (variante_mango == "doble" && plano_antirrodadura == 0)
    ? (mango_diametro - junta_d()) / 2 - 0.4 : plano_antirrodadura;
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
    pts = concat(
        [[0, 0], [radio_mango(0) - mango_chaflan, 0]],
        [for (i = [0 : n]) let(z = mango_chaflan + (mango_largo - mango_chaflan - chf) * i / n) [radio_mango(z), z]],
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
            translate([0, 0, mango_largo]) junta_macho(1);
            if (variante_mango == "doble") mirror([0, 0, 1]) junta_macho(-1);
        }
        ranuras_mango();
        if (variante_mango == "doble") junta_hueco_macho();
        if (pl > 0)
            translate([-50, -mango_diametro / 2 - 20, -junta_largo() - 5])
                cube([100, 20 + pl, mango_largo + 2 * junta_largo() + 10]);
    }
}

// ---------------------------------------------------------------------
//  CABEZAL  (orientación de impresión: cara de lijado en z = 0)
// ---------------------------------------------------------------------
module a_eje_cuerpo(a) { translate(P(a)) rotate([0, a, 0]) rotate([0, -90, 0]) children(); }
module a_boca(a) { a_eje_cuerpo(a) translate([0, 0, cuerpo_largo]) mirror([0, 0, 1]) children(); }

module cuerpo(a) {
    r = cuerpo_d / 2; ch = cuerpo_chaflan;
    a_eje_cuerpo(a) rotate_extrude()
        polygon([[0, 0], [r, 0], [r, cuerpo_largo - ch], [r - ch, cuerpo_largo], [0, cuerpo_largo]]);
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
        a_boca(a) junta_hembra_neg();
        translate([-200, -200, -100]) cube([400, 400, 100]);
    }
    a_boca(a) junta_hembra_pos();
}

// ---------------------------------------------------------------------
//  TEST DE AJUSTE: cuerpo con la hembra + tapón con el macho
// ---------------------------------------------------------------------
module test_ajuste() {
    difference() {
        cuerpo(0);
        a_boca(0) junta_hembra_neg();
        translate([-200, -200, -100]) cube([400, 400, 100]);
    }
    a_boca(0) junta_hembra_pos();
    translate([19, 0, 0]) {
        cylinder(d = mango_diametro, h = 8);
        translate([0, 0, 8]) junta_macho(1);
    }
}

// ---------------------------------------------------------------------
//  CONJUNTO
// ---------------------------------------------------------------------
module mango_montado() {
    a = ang_efectivo();
    d = [-cos(a), 0, sin(a)];
    M = P(a) + cuerpo_largo * d;
    translate(M) rotate([0, 90 + a, 0]) rotate([0, 0, junta_giro() * giro_vista])
        translate([0, 0, -mango_largo]) children();
}
module conjunto() {
    color("#d9a441") cabezal();
    color("#4a6fa5") mango_montado() mango();
}
// Comprobación: el volumen debe ser ~0. Si sale grande, macho y hembra chocan.
//   openscad -o x.stl -D 'pieza="interferencia"' -D mango_largo=8 -D ranuras_num=0 ...
module interferencia() { intersection() { cabezal(); mango_montado() mango(); } }

// ---------------------------------------------------------------------
if (pieza == "mango") mango();
else if (pieza == "cabezal") cabezal();
else if (pieza == "test_ajuste") test_ajuste();
else if (pieza == "interferencia") interferencia();
else conjunto();
'''

# =====================================================================
#  V2 · BAYONETA DE 1/4 DE VUELTA
# =====================================================================
V2_HEAD = r'''// =====================================================================
//  SANDING STICK BAY90 — v2 · unión de BAYONETA de 1/4 de vuelta
//  Versión 2.0 · 2026-09-07 · Jorge (con Claude) · OpenSCAD 2021.01+
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
bay_rampa     = 0.25;  // cuánto baja el techo del canal a lo largo del giro
bay_muesca    = 0.06;  // resalte de retención antes del asiento (0 = sin clic)
bay_aprieto   = 0.03;  // interferencia en el asiento final
bay_chaflan   = 0.8;   // chaflán de la punta del vástago y de la boca
bay_pasos     = 44;    // resolución angular del canal helicoidal
bay_sentido   = -1;    // -1 = bloquea girando el cabezal a derechas'''

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
    rg = bay_rg(); ro = bay_rp() + 1.2; w = bay_ranura_ang();
    rotate([0, 0, -w / 2]) translate([0, 0, bay_z - 0.15])
        linear_extrude(height = bay_largo - bay_z + 1.5) sector2d(rg, ro, w);
    // El canal arranca dos pasos ANTES de la ranura de entrada para que los dos
    // negativos se solapen en volumen y no queden slivers en la unión.
    N = bay_pasos; tot = bay_ang_total();
    for (i = [-2 : N - 1]) {
        f0 = tot * i / N; f1 = tot * (i + 1) / N;
        rotate([0, 0, sentido * (f0 - w / 2)]) translate([0, 0, bay_z - 0.15])
            linear_extrude(height = bay_techo(max(f0, 0)) - bay_z + 0.15)
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
}'''

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
module junta_hembra_pos() { }'''

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
module junta_hembra_pos() { }'''

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
module junta_hembra_pos() { }'''

VERSIONES = {
    "sanding_stick_v2.scad": (V2_HEAD, V2_PARAMS, V2_JUNTA),
    "sanding_stick_v3.scad": (V3_HEAD, V3_PARAMS, V3_JUNTA),
    "sanding_stick_v4.scad": (V4_HEAD, V4_PARAMS, V4_JUNTA),
    "sanding_stick_v5.scad": (V5_HEAD, V5_PARAMS, V5_JUNTA),
}

if __name__ == "__main__":
    for nombre, (cab, par, junta) in VERSIONES.items():
        txt = cab + "\n" + COMUN.replace("__PARAMS__", par).replace("__JUNTA__", junta)
        with open(os.path.join(AQUI, nombre), "w", encoding="utf-8", newline="\n") as f:
            f.write(txt)
        print("escrito", nombre, len(txt), "bytes")
