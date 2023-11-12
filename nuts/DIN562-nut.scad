include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// include solidpp
include <../solidpp/solidpp.scad>

// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
DIN562_DIC = [  [3.0,   [ 5.4,  1.8]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head side



// DIN562 nut
module DIN562_nut(d, align=DN_BOTTOM)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN562_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    _align = (align==DN_BOTTOM) ? 
                "z" :
                (align==DN_TOP) ?
                    "Z" : "";

    // construct model
    cubepp([hd,hd,hh], align=_align);    
}


// DIN562 nut hole
module DIN562_nut_hole( d, align=DN_BOTTOM,
                        h_off=0, clearance=0.1, eps=dn_eps)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN562_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align, eps=eps,
                    h_off=h_off, clearance=clearance);

    _d = hd + 2*clearance;
    _h = hh + 2*clearance;

    _data = (align==DN_BOTTOM) ? 
                [-clearance, 0, "z"] :
                (align==DN_TOP) ?
                    [clearance, -hh, "Z"] :
                    [0, -hh/2, ""];
    
    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];
    _align = _data[2];
   
    // basic shape
    translate(_nut_tf) 
        cubepp([_d, _d, _h], align=_align);
    
    // add hole
    translate(_hole_tf)
        cubepp([_d, _d, _h+h_off], align="Z"); 

}
