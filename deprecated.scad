// DEPRECATED: the modules, functions and tables of the single standards (before the records)
// every call echoes the replacement; the tables are the nominal values of the records
// NOTE: included by deez-nuts.scad

// __private__ the old table [d, [width, height]] of a record (nominal values)
function __dn_legacy_dic(record) =
    [for (e = record[__DN_STD_SIZES]) [e[0], [deez_nuts_dimension(e[1][0], DN_TOLERANCE_NOMINAL),
                                             deez_nuts_dimension(e[1][1], DN_TOLERANCE_NOMINAL)]]];

// __private__ the deprecation message
function __dn_deprecated(old, new) = str("[DEEZ-NUTS] DEPRECATED: ", old, " -> use ", new);

// DIN84A
DIN84A_DIC = __dn_legacy_dic(DN_DIN84A);

module DIN84A_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN84A_bolt(descriptor, ...)", "bolt(descriptor, \"DIN84A\", ...)"));
    deez_nuts_fastener(DN_DIN84A, descriptor, align=align, visual=visual, zet=zet, ctx="DIN84A-bolt");
}

module DIN84A_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("DIN84A_bolt_hole(descriptor, ...)", "bolt_hole(descriptor, \"DIN84A\", ...)"));
    deez_nuts_fastener_hole(DN_DIN84A, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="DIN84A-bolt-hole");
}

function DIN84A_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("DIN84A_get_head_diameter(descriptor, ...)", "get_bolt_head_diameter(descriptor, \"DIN84A\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN84A, descriptor, is_circumscribed);

function DIN84A_get_head_height(descriptor) =
    echo(__dn_deprecated("DIN84A_get_head_height(descriptor)", "get_bolt_head_height(descriptor, \"DIN84A\")"))
    deez_nuts_fastener_head_height(DN_DIN84A, descriptor);

// DIN933
DIN933_DIC = __dn_legacy_dic(DN_DIN933);

module DIN933_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN933_bolt(descriptor, ...)", "bolt(descriptor, \"DIN933\", ...)"));
    deez_nuts_fastener(DN_DIN933, descriptor, align=align, visual=visual, zet=zet, ctx="DIN933-bolt");
}

module DIN933_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("DIN933_bolt_hole(descriptor, ...)", "bolt_hole(descriptor, \"DIN933\", ...)"));
    deez_nuts_fastener_hole(DN_DIN933, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="DIN933-bolt-hole");
}

function DIN933_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("DIN933_get_head_diameter(descriptor, ...)", "get_bolt_head_diameter(descriptor, \"DIN933\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN933, descriptor, is_circumscribed);

function DIN933_get_head_height(descriptor) =
    echo(__dn_deprecated("DIN933_get_head_height(descriptor)", "get_bolt_head_height(descriptor, \"DIN933\")"))
    deez_nuts_fastener_head_height(DN_DIN933, descriptor);

// DIN912
DIN912_DIC = __dn_legacy_dic(DN_DIN912);

module DIN912_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN912_bolt(descriptor, ...)", "bolt(descriptor, \"DIN912\", ...)"));
    deez_nuts_fastener(DN_DIN912, descriptor, align=align, visual=visual, zet=zet, ctx="DIN912-bolt");
}

module DIN912_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("DIN912_bolt_hole(descriptor, ...)", "bolt_hole(descriptor, \"DIN912\", ...)"));
    deez_nuts_fastener_hole(DN_DIN912, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="DIN912-bolt-hole");
}

function DIN912_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("DIN912_get_head_diameter(descriptor, ...)", "get_bolt_head_diameter(descriptor, \"DIN912\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN912, descriptor, is_circumscribed);

function DIN912_get_head_height(descriptor) =
    echo(__dn_deprecated("DIN912_get_head_height(descriptor)", "get_bolt_head_height(descriptor, \"DIN912\")"))
    deez_nuts_fastener_head_height(DN_DIN912, descriptor);

// DIN73801
DIN73801_DIC = __dn_legacy_dic(DN_DIN7380_1);

module DIN73801_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN73801_bolt(descriptor, ...)", "bolt(descriptor, \"DIN7380-1\", ...)"));
    deez_nuts_fastener(DN_DIN7380_1, descriptor, align=align, visual=visual, zet=zet, ctx="DIN73801-bolt");
}

module DIN73801_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("DIN73801_bolt_hole(descriptor, ...)", "bolt_hole(descriptor, \"DIN7380-1\", ...)"));
    deez_nuts_fastener_hole(DN_DIN7380_1, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="DIN73801-bolt-hole");
}

function DIN73801_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("DIN73801_get_head_diameter(descriptor, ...)", "get_bolt_head_diameter(descriptor, \"DIN7380-1\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN7380_1, descriptor, is_circumscribed);

function DIN73801_get_head_height(descriptor) =
    echo(__dn_deprecated("DIN73801_get_head_height(descriptor)", "get_bolt_head_height(descriptor, \"DIN7380-1\")"))
    deez_nuts_fastener_head_height(DN_DIN7380_1, descriptor);

// DIN7991
DIN7991_DIC = __dn_legacy_dic(DN_DIN7991);

module DIN7991_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN7991_bolt(descriptor, ...)", "bolt(descriptor, \"DIN7991\", ...)"));
    deez_nuts_fastener(DN_DIN7991, descriptor, align=align, visual=visual, zet=zet, ctx="DIN7991-bolt");
}

module DIN7991_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("DIN7991_bolt_hole(descriptor, ...)", "bolt_hole(descriptor, \"DIN7991\", ...)"));
    deez_nuts_fastener_hole(DN_DIN7991, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="DIN7991-bolt-hole");
}

function DIN7991_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("DIN7991_get_head_diameter(descriptor, ...)", "get_bolt_head_diameter(descriptor, \"DIN7991\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN7991, descriptor, is_circumscribed);

function DIN7991_get_head_height(descriptor) =
    echo(__dn_deprecated("DIN7991_get_head_height(descriptor)", "get_bolt_head_height(descriptor, \"DIN7991\")"))
    deez_nuts_fastener_head_height(DN_DIN7991, descriptor);

// LUXPZ
LUXPZ_DIC = __dn_legacy_dic(DN_DIN7505);

module LUXPZ_screw(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("LUXPZ_screw(descriptor, ...)", "screw(descriptor, \"DIN7505\", ...)"));
    deez_nuts_fastener(DN_DIN7505, descriptor, align=align, visual=visual, zet=zet, ctx="LUXPZ-screw");
}

module LUXPZ_screw_hole(descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0, clearance=0.1, eps=DN_EPS, zet=undef)
{
    echo(__dn_deprecated("LUXPZ_screw_hole(descriptor, ...)", "screw_hole(descriptor, \"DIN7505\", ...)"));
    deez_nuts_fastener_hole(DN_DIN7505, descriptor, align=align, sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet, ctx="LUXPZ-screw-hole");
}

function LUXPZ_get_head_diameter(descriptor, is_circumscribed=true) =
    echo(__dn_deprecated("LUXPZ_get_head_diameter(descriptor, ...)", "get_screw_head_diameter(descriptor, \"DIN7505\", ...)"))
    deez_nuts_fastener_head_diameter(DN_DIN7505, descriptor, is_circumscribed);

function LUXPZ_get_head_height(descriptor) =
    echo(__dn_deprecated("LUXPZ_get_head_height(descriptor)", "get_screw_head_height(descriptor, \"DIN7505\")"))
    deez_nuts_fastener_head_height(DN_DIN7505, descriptor);

// DIN439
DIN439_DIC = __dn_legacy_dic(DN_DIN439);

module DIN439_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN439_nut(d, ...)", "nut(d, \"DIN439\", ...)"));
    deez_nuts_nut(DN_DIN439, d, align=align, visual=visual, zet=zet, ctx="DIN439-nut");
}

module DIN439_nut_hole(d, align=DN_ALIGN_BOTTOM, s_off=0, h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    echo(__dn_deprecated("DIN439_nut_hole(d, ...)", "nut_hole(d, \"DIN439\", ...)"));
    deez_nuts_nut_hole(DN_DIN439, d, align=align, s_off=s_off, h_off=h_off, clearance=clearance,
                       h_clearance=h_clearance, zet=zet, ctx="DIN439-nut-hole");
}

function DIN439_get_diameter(d, is_circumscribed=true) =
    echo(__dn_deprecated("DIN439_get_diameter(d, ...)", "get_nut_diameter(d, \"DIN439\", ...)"))
    deez_nuts_nut_width(DN_DIN439, d, is_circumscribed);

function DIN439_get_height(d) =
    echo(__dn_deprecated("DIN439_get_height(d)", "get_nut_height(d, \"DIN439\")"))
    deez_nuts_nut_height(DN_DIN439, d);

// DIN562
DIN562_DIC = __dn_legacy_dic(DN_DIN562);

module DIN562_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN562_nut(d, ...)", "nut(d, \"DIN562\", ...)"));
    deez_nuts_nut(DN_DIN562, d, align=align, visual=visual, zet=zet, ctx="DIN562-nut");
}

module DIN562_nut_hole(d, align=DN_ALIGN_BOTTOM, s_off=0, h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    echo(__dn_deprecated("DIN562_nut_hole(d, ...)", "nut_hole(d, \"DIN562\", ...)"));
    deez_nuts_nut_hole(DN_DIN562, d, align=align, s_off=s_off, h_off=h_off, clearance=clearance,
                       h_clearance=h_clearance, zet=zet, ctx="DIN562-nut-hole");
}

function DIN562_get_diameter(d, is_circumscribed=true) =
    echo(__dn_deprecated("DIN562_get_diameter(d, ...)", "get_nut_diameter(d, \"DIN562\", ...)"))
    deez_nuts_nut_width(DN_DIN562, d, is_circumscribed);

function DIN562_get_height(d) =
    echo(__dn_deprecated("DIN562_get_height(d)", "get_nut_height(d, \"DIN562\")"))
    deez_nuts_nut_height(DN_DIN562, d);

// DIN934
DIN934_DIC = __dn_legacy_dic(DN_DIN934);

module DIN934_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN934_nut(d, ...)", "nut(d, \"DIN934\", ...)"));
    deez_nuts_nut(DN_DIN934, d, align=align, visual=visual, zet=zet, ctx="DIN934-nut");
}

module DIN934_nut_hole(d, align=DN_ALIGN_BOTTOM, s_off=0, h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    echo(__dn_deprecated("DIN934_nut_hole(d, ...)", "nut_hole(d, \"DIN934\", ...)"));
    deez_nuts_nut_hole(DN_DIN934, d, align=align, s_off=s_off, h_off=h_off, clearance=clearance,
                       h_clearance=h_clearance, zet=zet, ctx="DIN934-nut-hole");
}

function DIN934_get_diameter(d, is_circumscribed=true) =
    echo(__dn_deprecated("DIN934_get_diameter(d, ...)", "get_nut_diameter(d, \"DIN934\", ...)"))
    deez_nuts_nut_width(DN_DIN934, d, is_circumscribed);

function DIN934_get_height(d) =
    echo(__dn_deprecated("DIN934_get_height(d)", "get_nut_height(d, \"DIN934\")"))
    deez_nuts_nut_height(DN_DIN934, d);

// DIN985
DIN985_DIC = __dn_legacy_dic(DN_DIN985);

module DIN985_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    echo(__dn_deprecated("DIN985_nut(d, ...)", "nut(d, \"DIN985\", ...)"));
    deez_nuts_nut(DN_DIN985, d, align=align, visual=visual, zet=zet, ctx="DIN985-nut");
}

module DIN985_nut_hole(d, align=DN_ALIGN_BOTTOM, s_off=0, h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    echo(__dn_deprecated("DIN985_nut_hole(d, ...)", "nut_hole(d, \"DIN985\", ...)"));
    deez_nuts_nut_hole(DN_DIN985, d, align=align, s_off=s_off, h_off=h_off, clearance=clearance,
                       h_clearance=h_clearance, zet=zet, ctx="DIN985-nut-hole");
}

function DIN985_get_diameter(d, is_circumscribed=true) =
    echo(__dn_deprecated("DIN985_get_diameter(d, ...)", "get_nut_diameter(d, \"DIN985\", ...)"))
    deez_nuts_nut_width(DN_DIN985, d, is_circumscribed);

function DIN985_get_height(d) =
    echo(__dn_deprecated("DIN985_get_height(d)", "get_nut_height(d, \"DIN985\")"))
    deez_nuts_nut_height(DN_DIN985, d);

// DIN912 groove (the socket of an M3, visual only)
module DIN912_groove(fn = 6)
{
    echo(__dn_deprecated("DIN912_groove()", "bolt(descriptor, \"DIN912\", visual=true)"));
    translate([0, 0, -0.001])
        cylinderpp(d=2.5, h=1.3 + 0.002, align="z", fn=6, polygon="flats");
}
