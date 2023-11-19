include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
DIN985_DIC = [  [3.0,   [ 5.4,  3.9]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head diameter

// DIN985 nut
module DIN985_nut(d, align=DN_ALIGN_BOTTOM)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN985_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN985-nut] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, align=align);    
}


// DIN985 nut hole
module DIN985_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0, 
                        h_off=0, clearance=0.1, h_clearance=undef)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN985_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN985-nut-hole] undefined entry for d=", sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance);

}