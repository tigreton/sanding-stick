// =====================================================================
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
mango_chaflan_frontal = 0.6;

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
module junta_extra_montado() { pin_casquillo(); }

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
