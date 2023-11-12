include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
DIN934_DIC = [  [2.0,   [ 4.0,  1.5]],
                [3.0,   [ 5.4,  2.3]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head diameter


// DIN934 nut
module DIN934_nut(d, align=DN_BOTTOM)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN934_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, align=align);    
}


// DIN934 nut hole
module DIN934_nut_hole( d, align=DN_BOTTOM,
                        h_off=0, clearance=0.1, eps=dn_eps)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN934_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align, eps=eps,
                    h_off=h_off, clearance=clearance);

}