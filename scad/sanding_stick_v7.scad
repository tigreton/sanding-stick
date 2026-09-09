// =====================================================================
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
// =====================================================================

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
mango_chaflan_frontal = 1.7;

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
module junta_extra_montado() { }

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
