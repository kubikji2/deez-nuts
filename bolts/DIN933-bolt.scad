include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// dictionary to convert the shaft diameter to the head params
// based on:
// https://www.dingfastener.com/din-933/
DIN933_DIC = [  [ 3.0,   [ 5.4,  2.0]],
                [ 4.0,   [ 6.9,  2.8]],
                [10.0,   [16.9,  6.4]]];
//                        '     '-> head height 
//                        '-> head width (side-to-side)

// DIN933 bolt
module DIN933_bolt(descriptor, align, visual=false)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN933_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN933-bolt] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = deez_nutz_polygon_width_to_circumscribed_diameter(_dic_data[0], 6);
    hh = _dic_data[1];
    
    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false, head_fn=6);
}



// DIN933 bolt hole
module DIN933_bolt_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN933_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN933-bolt-hole] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = deez_nutz_polygon_width_to_circumscribed_diameter(_dic_data[0], 6);
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, head_fn=6);

}


// DIN933 get head diameter
function DIN933_get_head_diameter(descriptor, is_circumscribed) =
    let(diameter=basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN933_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 6) : diameter;


// DIN933 get head height
function DIN933_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN933_DIC);