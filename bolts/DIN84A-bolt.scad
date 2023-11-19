include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// dictionary to convert the shaft diameter to the head params
DIN84A_DIC = [  [2.0,   [ 3.8,  1.2]],
                [3.0,   [ 5.4,  2.1]]];
//                        '     '-> head height 
//                        '-> head diameter

// DIN84A bolt
module DIN84A_bolt(descriptor, align)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN84A_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN841-bolt] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];
    
    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false);
}



// DIN84A bolt hole
module DIN84A_bolt_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN84A_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN841-bolt-hole] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps);

}