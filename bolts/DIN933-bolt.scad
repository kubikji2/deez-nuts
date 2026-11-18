include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// DIN 933 (ISO 4017): hexagon head bolt; the length is the length of the shaft
// TODO verify the values against the standard
// dictionary to convert the shaft diameter to the head params
// based on:
// https://www.dingfastener.com/din-933/
DIN933_DIC = [  [ 3.0,   [ 5.4,  2.0]],
                [ 4.0,   [ 6.9,  2.8]],
                [10.0,   [16.9,  6.4]]];
//                        '     '-> head height
//                        '-> head width (side-to-side)

// DIN933 bolt
// '-> argument 'descriptor' e.g. "M3x20" (the length of the shaft)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN933_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN933-bolt");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN933_DIC, "DIN933-bolt", descriptor);
    hd = _dic_data[0];  // the width across the flats: built with polygon="flats"
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
               head_fn=6, head_polygon="flats", zet=zet);
}



// DIN933 bolt hole
module DIN933_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN933-bolt-hole");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN933_DIC, "DIN933-bolt-hole", descriptor);
    hd = _dic_data[0];  // the width across the flats: built with polygon="flats"
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps,
                    head_fn=6, head_polygon="flats", zet=zet);

}


// DIN933 get head diameter
// '-> is_circumscribed=true: the diameter across the corners, false: the width across the flats
function DIN933_get_head_diameter(descriptor, is_circumscribed) =
    let(diameter=basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN933_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 6) : diameter;


// DIN933 get head height
function DIN933_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN933_DIC);
