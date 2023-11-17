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
module DIN439_nut(d, align=DN_ALIGN_BOTTOM)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN439_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, align=align);    
}


// DIN439 nut hole
module DIN439_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0,
                        h_off=0, clearance=0.1, eps=DN_EPS)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN439_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align, eps=eps,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance);

}