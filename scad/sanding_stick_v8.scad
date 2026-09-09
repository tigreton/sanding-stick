// =====================================================================
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
module junta_extra_montado() { cun_cuna(); }

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
