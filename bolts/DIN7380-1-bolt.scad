include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// dictionary to convert the shaft diameter to the head params
DIN73801_DIC = [    [3.0,   [  5.7,  1.65]],
                    [4.0,   [  7.6,  2.20]],
                    [5.0,   [  9.5,  2.75]],
                    [6.0,   [ 10.5,  3.30]]];
//                              '     '-> head height 
//                              '-> head diameter

// DIN73801 bolt
module DIN73801_bolt(descriptor, align, visual=false)
{
    // TODO update visual
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN73801_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN73801-bolt] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];
    
    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false, head_fn=6);
}



// DIN73801 bolt hole
module DIN73801_bolt_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN73801_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN73801-bolt-hole] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, head_fn=6);

}


// DIN73801 get head diameter
function DIN73801_get_head_diameter(descriptor, is_inradius) =
    let(_sf = is_inradius ? 1 : 1/sin(60))
    _sf*basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN73801_DIC, is_inradius=is_inradius);

// DIN73801 get head height
function DIN73801_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN73801_DIC);