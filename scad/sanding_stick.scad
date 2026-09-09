// =====================================================================
//  SANDING STICK HEX6 — lijador de varilla con cabezales intercambiables
//  Versión 1.0  ·  2026-09-07  ·  Jorge (con Claude)  ·  OpenSCAD 2021.01+
//  Impresora objetivo: Bambu Lab A1 Mini (180 x 180 x 180 mm)
//
//  Sistema:
//    · MANGO  tipo bolígrafo (Ø12 x 125 mm) con ESPIGA hexagonal en la punta.
//    · CABEZAL con CAVIDAD hexagonal; entra a presión (fricción) en la espiga.
//      (La espiga va en el mango y no en el cabezal para que TODOS los
//       cabezales se impriman planos, con la cara de lijado sobre la cama.)
//    · La lija se pega con adhesivo/cinta doble cara sobre la cara plana.
//
//  Uso por CLI (ejemplos):
//    openscad -o mango_recta.stl        -D 'pieza="mango"'   -D 'variante_mango="recta"'  sanding_stick.scad
//    openscad -o pala_16_45.stl         -D 'pieza="cabezal"' -D 'tipo="pala"' -D ancho=16 -D angulo=45 sanding_stick.scad
//    openscad -o test_ajuste.stl        -D 'pieza="test_ajuste"' sanding_stick.scad
//
//  Tipos de cabezal:
//    "pala"                rectángulo plano. angulo = 0 | 45 | 90 (cara respecto al eje del mango)
//    "triangulo"           paleta triangular plana (punta hacia delante) para esquinas
//    "prisma_tri"          barra de sección triangular equilátera (3 caras) para ranuras en V
//    "medio_tubo_convexo"  media caña convexa (lija superficies cóncavas)
//    "medio_tubo_concavo"  canal semicircular (lija varillas / cantos redondos)
// =====================================================================

/* [Pieza a generar] */
pieza = "conjunto";           // ["mango","cabezal","test_ajuste","conjunto"]
variante_mango = "recta";     // ["recta","ergonomica","doble"]

/* [Cabezal] */
tipo = "pala";                // ["pala","triangulo","prisma_tri","medio_tubo_convexo","medio_tubo_concavo"]
ancho = 16;                   // ancho de la cara de lijado (8 ó 16 recomendados)
angulo = 0;                   // 0 | 45 | 90   (solo para tipo "pala")
largo_pala = -1;              // -1 = automático (40 a 0°, 25 a 45°, 16 a 90°)
espesor = -1;                 // -1 = automático (3 mm si ancho<=10, si no 4 mm)
radio_esquinas = 1.5;         // redondeo de las esquinas de la pala
largo_barra = 40;             // longitud de prisma / medios tubos
pared_canal = -1;             // medio tubo cóncavo: pared lateral (-1 = auto: 1.5 si ancho<=10, si no 2)
fondo_canal = 2;              // medio tubo cóncavo: grosor bajo el canal

/* [Mango] */
mango_diametro = 12;
mango_largo = 125;
mango_chaflan = 1.5;          // chaflán del extremo trasero (apoya en la cama)
mango_chaflan_frontal = 1.0;  // chaflán del extremo. Es lo que le queda de asiento
                              // al cabezal: aquí la boca del hexágono llega a r=3,95
                              // y el hombro a r=5,00, así que apoyan de sobra
ranuras_num = 7;              // anillos de agarre
ranuras_ancho = 1.6;
ranuras_prof = 0.6;
ranuras_paso = 4;
ranuras_inicio = 14;          // distancia del 1er anillo al hombro de la espiga
plano_antirrodadura = 0;      // 0 = ninguno. >0 = profundidad del plano lateral. (la variante "doble" lo fuerza)
// Variante ergonómica (perfil suavizado)
ergo_d_frente = 11;
ergo_d_max = 14;
ergo_pos_max = 55;            // distancia desde el frente donde está el diámetro máximo
ergo_d_atras = 10.5;

/* [Unión hexagonal] */
hex_af = 6;                   // entre caras de la espiga (across flats)
hex_largo = 12;               // longitud de la espiga
holgura = 0.15;               // holgura POR LADO. Cavidad = hex_af + 2*holgura. Ajustar con test_ajuste
chaflan_espiga = 0.8;
chaflan_cavidad = 0.8;
fondo_cavidad = 0.5;          // aire extra en el fondo de la cavidad

/* [Cuerpo del cabezal] */
cuerpo_d = 12;                // = mango_diametro para que quede enrasado
cuerpo_largo = 16;            // >= hex_largo + fondo_cavidad + 3 mm de pared
cuerpo_zc = 5.5;              // altura del eje sobre la cama (crea un plano de apoyo de ~5 mm)
cuerpo_chaflan = 0.8;
cuello = 8;                   // longitud de la transición cuerpo→pala (hull)
cuello_90 = 3;                // altura de la transición en los cabezales a 90°

/* [Calidad] */
$fn = 64;
fn_hex = 6;

// ---------------------------------------------------------------------
//  Funciones auxiliares
// ---------------------------------------------------------------------
function esp() = espesor > 0 ? espesor : (ancho <= 10 ? 3 : 4);
function largo_p(a) = largo_pala > 0 ? largo_pala : (a == 0 ? 40 : (a == 45 ? 25 : 16));
function x0_pala(a) = -largo_p(a) * (a / 90) / 2;       // 0 → 0 ; 45 → -L/4 ; 90 → -L/2
function pared_c() = pared_canal > 0 ? pared_canal : (ancho <= 10 ? 1.5 : 2);
function canal_d() = ancho - 2 * pared_c();
function ang_efectivo() = (tipo == "pala") ? angulo : 0;
function P(a) = (a == 90) ? [0, 0, esp() + cuello_90] : [0, 0, cuerpo_zc];
function coseno(t) = (1 - cos(180 * t)) / 2;            // suavizado 0..1
function r_ergo_s(s) = s <= ergo_pos_max
    ? ergo_d_frente / 2 + (ergo_d_max - ergo_d_frente) / 2 * coseno(s / ergo_pos_max)
    : ergo_d_max / 2 + (ergo_d_atras - ergo_d_max) / 2 * coseno((s - ergo_pos_max) / (mango_largo - ergo_pos_max));
// radio del mango a la altura z (z=0 extremo trasero, z=mango_largo hombro de la espiga)
function radio_mango(z) = (variante_mango == "ergonomica") ? r_ergo_s(mango_largo - z) : mango_diametro / 2;
function plano_efectivo() = (variante_mango == "doble" && plano_antirrodadura == 0)
    ? (mango_diametro - hex_af) / 2 : plano_antirrodadura;
function ranura_s0() = (variante_mango == "doble")
    ? (mango_largo - (ranuras_num - 1) * ranuras_paso) / 2 : ranuras_inicio;

// ---------------------------------------------------------------------
//  Hexágono / espiga / cavidad
// ---------------------------------------------------------------------
module hex2d(af, giro = 0) { rotate(giro) circle(d = af / cos(30), $fn = fn_hex); }
module hex_prisma(af, h, giro = 0) { linear_extrude(height = h) hex2d(af, giro); }

// Espiga con punta achaflanada. Base en z=0, crece hacia +Z.
module espiga(af = hex_af, h = hex_largo, ch = chaflan_espiga, giro = 0) {
    hex_prisma(af, h - ch, giro);
    translate([0, 0, h - ch]) linear_extrude(height = ch, scale = (af - 2 * ch) / af) hex2d(af, giro);
}

// Cavidad (negativo). Boca en z=0 (achaflanada), profundidad h hacia +Z.
module cavidad(af = hex_af + 2 * holgura, h = hex_largo + fondo_cavidad, ch = chaflan_cavidad, giro = 0) {
    translate([0, 0, -0.01]) linear_extrude(height = ch + 0.02, scale = af / (af + 2 * ch)) hex2d(af + 2 * ch, giro);
    translate([0, 0, -0.01]) hex_prisma(af, h + 0.01, giro);
}

// ---------------------------------------------------------------------
//  MANGO  (se imprime de pie, espiga hacia arriba; "doble" tumbado sobre el plano)
// ---------------------------------------------------------------------
module perfil_mango() {
    n = 80;
    chf = mango_chaflan_frontal;
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
            translate([0, 0, mango_largo]) espiga(giro = 0);
            if (variante_mango == "doble") mirror([0, 0, 1]) espiga(giro = 0);
        }
        ranuras_mango();
        if (pl > 0)   // plano lateral en -Y (cara de apoyo para imprimir tumbado)
            translate([-50, -mango_diametro / 2 - 20, -hex_largo - 5]) cube([100, 20 + pl, mango_largo + 2 * hex_largo + 10]);
    }
}

// ---------------------------------------------------------------------
//  CABEZAL  (en orientación de impresión: cara de lijado en z=0)
//  Eje del cuerpo: parte de P(a) en dirección (-cos a, 0, sin a)
// ---------------------------------------------------------------------
module a_eje_cuerpo(a) { translate(P(a)) rotate([0, a, 0]) rotate([0, -90, 0]) children(); }

module cuerpo(a) {
    r = cuerpo_d / 2; ch = cuerpo_chaflan;
    a_eje_cuerpo(a) rotate_extrude()
        polygon([[0, 0], [r, 0], [r, cuerpo_largo - ch], [r - ch, cuerpo_largo], [0, cuerpo_largo]]);
}
// Base del cuello: Ø ligeramente menor que el cuerpo para que la superficie
// reglada del hull nunca quede tangente al cilindro (evita aristas no-manifold).
module cuerpo_base(a) { a_eje_cuerpo(a) cylinder(d = cuerpo_d - 0.6, h = 3); }
module cavidad_cuerpo(a) {
    a_eje_cuerpo(a) translate([0, 0, cuerpo_largo]) mirror([0, 0, 1]) cavidad(giro = 30);  // giro 30 → caras planas arriba/abajo
}

// --- formas 2D de las paletas (en XY, el eje del mango es X) ---
module pala_2d(a) {
    L = largo_p(a); x0 = x0_pala(a); rr = radio_esquinas; W = ancho;
    if (a == 90) {
        translate([x0, -W / 2]) offset(r = rr) offset(delta = -rr) square([L, W]);
    } else {
        hull() {
            translate([x0, -W / 2]) square([L - rr, W]);
            translate([x0 + L - rr, -W / 2 + rr]) circle(rr);
            translate([x0 + L - rr,  W / 2 - rr]) circle(rr);
        }
    }
}
module triangulo_2d() {
    Lt = ancho <= 10 ? 22 : 30; rr = 0.8;
    offset(r = rr) offset(delta = -rr) polygon([[0, -ancho / 2], [0, ancho / 2], [Lt, 0]]);
}

// Hombro: ensancha la paleta hasta el diámetro del cuerpo cuando la cara es
// más estrecha que el mango. Refuerza el cuello y evita geometría degenerada.
module hombro_2d(a) {
    if (ancho < cuerpo_d - 0.5) {
        L = (tipo == "triangulo") ? (ancho <= 10 ? 22 : 30) : largo_p(a);
        x0 = x0_forma(a);
        Lh = min(cuello + 6, L * 0.8);
        hull() {
            translate([x0 + cuerpo_d / 2, 0]) circle(d = cuerpo_d);
            translate([x0 + Lh, -ancho / 2]) square([0.01, ancho]);
        }
    }
}

// --- sólidos de las paletas / barras (cara de lijado en z=0) ---
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
function x0_forma(a) = (tipo == "pala") ? x0_pala(a) : 0;

module cabezal() {
    a = ang_efectivo();
    difference() {
        union() {
            cuerpo(a);
            forma_activa(a);
            hull() {   // cuello de transición
                cuerpo_base(a);
                intersection() {
                    forma_activa(a);
                    translate([x0_forma(a) - 0.01, -100, -1]) cube([(a == 90) ? largo_p(a) + 0.02 : cuello, 200, 100]);
                }
            }
        }
        cavidad_cuerpo(a);
        translate([-200, -200, -100]) cube([400, 400, 100]);   // nada por debajo de la cama
    }
}

// ---------------------------------------------------------------------
//  TEST DE AJUSTE: bloque con cavidad (como el cabezal) + tapón con espiga (como el mango)
// ---------------------------------------------------------------------
module test_ajuste() {
    difference() {
        cuerpo(0);
        cavidad_cuerpo(0);
        translate([-200, -200, -100]) cube([400, 400, 100]);
    }
    translate([16, 0, 0]) {
        cylinder(d = mango_diametro, h = 8);
        translate([0, 0, 8]) espiga(giro = 0);
    }
}

// ---------------------------------------------------------------------
//  CONJUNTO (vista previa montada)
// ---------------------------------------------------------------------
module conjunto() {
    a = ang_efectivo();
    d = [-cos(a), 0, sin(a)];
    M = P(a) + cuerpo_largo * d;    // boca de la cavidad
    color("#d9a441") cabezal();
    color("#4a6fa5") translate(M) rotate([0, 90 + a, 0]) rotate([0, 0, 30]) translate([0, 0, -mango_largo]) mango();
}

// ---------------------------------------------------------------------
if (pieza == "mango") mango();
else if (pieza == "cabezal") cabezal();
else if (pieza == "test_ajuste") test_ajuste();
else conjunto();
