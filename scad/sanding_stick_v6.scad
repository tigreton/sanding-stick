// =====================================================================
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
mango_chaflan_frontal = 0.4;

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
