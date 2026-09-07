// =====================================================================
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
// =====================================================================

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
bay_sentido   = -1;    // -1 = bloquea girando el cabezal a derechas

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
}

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
