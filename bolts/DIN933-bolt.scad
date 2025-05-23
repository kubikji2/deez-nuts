include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// dictionary to convert the shaft diameter to the head params
// based on:
// https://www.dingfastener.com/din-933/
DIN933_DIC = [  [ 3.0,   [ 6.0,  2.0]],
                [ 4.0,   [ 7.7,  2.8]],
                [10.0,   [19.0,  6.4]]];
//                        '     '-> head height 
//                        '-> head diameter

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
    hd = _dic_data[0];
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
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, head_fn=6);

}


// DIN933 get head diameter
function DIN933_get_head_diameter(descriptor, is_inradius) =
    let(_sf = is_inradius ? 1 : 1/sin(60))
    _sf*basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN933_DIC, is_inradius=is_inradius);

// DIN933 get head height
function DIN933_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN933_DIC);