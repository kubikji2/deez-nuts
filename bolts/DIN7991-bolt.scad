include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// DIN 7991 (ISO 10642): hexagon socket countersunk head bolt; the length is the total length
// TODO verify the values against the standard (M4 head height 1.3 is likely a typo)

// the hole is sunk this much below the surface (the head does not stick out)
__DN_DIN7991_SINK = 0.25;

// dictionary to convert the shaft diameter to the head params
DIN7991_DIC = [ [2.0,   [ 4.0, 1.2]],
                [2.5,   [ 5.0, 1.3]],
                [3.0,   [ 6.0, 1.7]],
                [4.0,   [ 8.0, 1.3]],
                [5.0,   [10.0, 2.8]],
                [6.0,   [12.0, 3.3]]];
//                        '    '-> head height
//                        '-> head diameter

// DIN7991 bolt
// '-> argument 'descriptor' e.g. "M3x20" (the total length, including the head)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN7991_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN7991-bolt");
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN7991_DIC, "DIN7991-bolt", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true, zet=zet);
}



// DIN7991 bolt hole
module DIN7991_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN7991-bolt-hole");
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN7991_DIC, "DIN7991-bolt-hole", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model: sunk by __DN_DIN7991_SINK below the surface
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:DIN7991-bolt-hole"))
        translate([0,0,-__DN_DIN7991_SINK])
            basic_bolt_hole(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true,
                            sh_off=sh_off, hh_off=hh_off+__DN_DIN7991_SINK, clearance=clearance, eps=eps);

}


// DIN7991 get head diameter
// NOTE: argument is_circumscribed is irrelevant for this round head
function DIN7991_get_head_diameter(descriptor, is_circumscribed) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN7991_DIC);


// DIN7991 get head height
function DIN7991_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN7991_DIC);
