include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
DIN439_DIC = [  [3.0,   [ 5.4,  1.8]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head diameter


// DIN439 nut
module DIN439_nut(d, align=DN_ALIGN_BOTTOM, visual=false)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN439_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN439-nut] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, r=d/2, align=align, visual=visual);    
}


// DIN439 nut hole
module DIN439_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0, 
                        h_off=0, clearance=0.1, h_clearance=undef)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN439_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN439-nut-hole] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance);

}