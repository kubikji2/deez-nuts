include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// konstant to increase the size, but at this point IDK, IDC
lxk = 0.25;

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
module DIN7991_bolt(descriptor, align, visual=false)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN7991_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN7991-bolt] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true);
}



// DIN7991 bolt hole
module DIN7991_bolt_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    th = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN7991_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN7991-bolt-hole] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    
    hd = _dic_data[0]+2*clearance;
    hh = _dic_data[1]+clearance;

    // construct model
    translate([0,0,-lxk])
        basic_bolt_hole(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true,
                        sh_off=sh_off, hh_off=hh_off+lxk, clearance=clearance, eps=eps);

}

// DIN7991 get diameter
function DIN7991_get_head_diameter(descriptor, is_inradius) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN7991_DIC, is_inradius=is_inradius);

// DIN7991 get height
function DIN7991_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN7991_DIC);