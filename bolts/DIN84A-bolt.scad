include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// DIN 84 A (ISO 1207): slotted cheese head bolt; the length is the length of the shaft
// TODO verify the values against the standard
// dictionary to convert the shaft diameter to the head params
DIN84A_DIC = [  [2.0,   [ 3.8,  1.2]],
                [3.0,   [ 5.4,  2.1]]];
//                        '     '-> head height
//                        '-> head diameter

// DIN84A bolt
// '-> argument 'descriptor' e.g. "M3x20" (the length of the shaft)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN84A_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN84A-bolt");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN84A_DIC, "DIN84A-bolt", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false, zet=zet);
}



// DIN84A bolt hole
module DIN84A_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN84A-bolt-hole");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN84A_DIC, "DIN84A-bolt-hole", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, zet=zet);

}


// DIN84A get head diameter
// NOTE: argument is_circumscribed is irrelevant for this cylindrical-headed bolt
function DIN84A_get_head_diameter(descriptor, is_circumscribed) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN84A_DIC);


// DIN84A get head height
function DIN84A_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN84A_DIC);
