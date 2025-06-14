include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// konstant to increase the size, but at this point IDK, IDC
lxk = 0.25;

// dictionary to convert the shaft diameter to the head params
LUXPZ_DIC = [   [2.5,   [ 5.0+lxk,  (( 5.0-2.5)/2)/(tan(45))+lxk]],
                [3.0,   [ 6.0+lxk,  (( 6.0-3.0)/2)/(tan(45))+lxk]],
                [3.5,   [ 7.0+lxk,  (( 7.0-3.5)/2)/(tan(45))+lxk]],
                [4.0,   [ 8.0+lxk,  (( 8.0-4.0)/2)/(tan(45))+lxk]],
                [4.5,   [ 9.0+lxk,  (( 9.0-4.5)/2)/(tan(45))+lxk]],
                [5.0,   [10.0+lxk,  ((10.0-5.0)/2)/(tan(45))+lxk]],
                [6.0,   [12.0+lxk,  ((12.0-6.0)/2)/(tan(45))+lxk]]];
//                        '          '-> head height 
//                        '-> head diameter


// LUXPZ screw
module LUXPZ_screw(descriptor, align, visual=false)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=LUXPZ_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:LUXPZ-screw] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true);
}



// LUXPZ screw hole
module LUXPZ_screw_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=LUXPZ_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:LUXPZ-screw-hole] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    
    hd = _dic_data[0]+2*clearance;
    hh = _dic_data[1]+clearance;

    // construct model
    translate([0,0,-lxk])
        basic_bolt_hole(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true,
                        sh_off=sh_off, hh_off=hh_off+lxk, clearance=clearance, eps=eps);

}

// LUXPZ get diameter
function LUXPZ_get_head_diameter(descriptor, is_inradius) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=LUXPZ_DIC, is_inradius=is_inradius);

// LUXPZ get height
function LUXPZ_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=LUXPZ_DIC);