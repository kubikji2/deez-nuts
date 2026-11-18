include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// LUXPZ: Pozidriv countersunk wood screw (no standard); the length is the total length
// TODO find the standard (e.g. DIN 7997 / ISO 7050-like); the head is computed for a 90 deg countersink

// a constant to increase the size of the head
__DN_LUXPZ_LXK = 0.25;

// the hole is sunk this much below the surface (the head does not stick out)
__DN_LUXPZ_SINK = 0.25;

// dictionary to convert the shaft diameter to the head params
LUXPZ_DIC = [   [2.5,   [ 5.0+__DN_LUXPZ_LXK,  (( 5.0-2.5)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [3.0,   [ 6.0+__DN_LUXPZ_LXK,  (( 6.0-3.0)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [3.5,   [ 7.0+__DN_LUXPZ_LXK,  (( 7.0-3.5)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [4.0,   [ 8.0+__DN_LUXPZ_LXK,  (( 8.0-4.0)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [4.5,   [ 9.0+__DN_LUXPZ_LXK,  (( 9.0-4.5)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [5.0,   [10.0+__DN_LUXPZ_LXK,  ((10.0-5.0)/2)/(tan(45))+__DN_LUXPZ_LXK]],
                [6.0,   [12.0+__DN_LUXPZ_LXK,  ((12.0-6.0)/2)/(tan(45))+__DN_LUXPZ_LXK]]];
//                        '                     '-> head height
//                        '-> head diameter

// LUXPZ screw
// '-> argument 'descriptor' e.g. "M3x20" (the total length, including the head)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module LUXPZ_screw(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:LUXPZ-screw");
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, LUXPZ_DIC, "LUXPZ-screw", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true, zet=zet);
}



// LUXPZ screw hole
module LUXPZ_screw_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:LUXPZ-screw-hole");
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, LUXPZ_DIC, "LUXPZ-screw-hole", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model: sunk by __DN_LUXPZ_SINK below the surface
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:LUXPZ-screw-hole"))
        translate([0,0,-__DN_LUXPZ_SINK])
            basic_bolt_hole(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true,
                            sh_off=sh_off, hh_off=hh_off+__DN_LUXPZ_SINK, clearance=clearance, eps=eps);

}


// LUXPZ get head diameter
// NOTE: argument is_circumscribed is irrelevant for this round head
function LUXPZ_get_head_diameter(descriptor, is_circumscribed) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=LUXPZ_DIC);


// LUXPZ get head height
function LUXPZ_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=LUXPZ_DIC);
