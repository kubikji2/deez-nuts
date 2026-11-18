include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// DIN 7380-1 (ISO 7380-1): hexagon socket button head bolt; the length is the length of the shaft
// TODO verify the values against the standard
// dictionary to convert the shaft diameter to the head params
DIN73801_DIC = [    [3.0,   [  5.7,  1.65]],
                    [4.0,   [  7.6,  2.20]],
                    [5.0,   [  9.5,  2.75]],
                    [6.0,   [ 10.5,  3.30]]];
//                              '     '-> head height
//                              '-> head diameter

// DIN7380-1 bolt
// '-> argument 'descriptor' e.g. "M3x20" (the length of the shaft)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN73801_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN7380-1-bolt");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN73801_DIC, "DIN7380-1-bolt", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false, zet=zet);
}



// DIN73801 bolt hole
module DIN73801_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN7380-1-bolt-hole");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN73801_DIC, "DIN7380-1-bolt-hole", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, zet=zet);

}


// DIN73801 get head diameter
// NOTE: argument is_circumscribed is irrelevant for this cylindrical-headed bolt
function DIN73801_get_head_diameter(descriptor, is_circumscribed) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN73801_DIC);


// DIN73801 get head height
function DIN73801_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN73801_DIC);
