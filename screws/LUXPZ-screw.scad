include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>


// dictionary to convert the shaft diameter to the head params
LUXPZ_DIC = [   [3.0,   [ 5.9,  2.2]],
                [3.5,   [ 6.9,  2.2]],
                [4.0,   [ 7.9,  2.8]],
                [4.5,   [ 8.9,  3.2]],
                [6.0,   [11.8,  4.2]]];
//                        '     '-> head height 
//                        '-> head diameter


// LUXPZ screw
module LUXPZ_screw(descriptor, align)
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
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps);

}
