include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// include solidpp
include <../solidpp/solidpp.scad>

// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
// based on: https://www.beaconcorporation.co.uk/products/nuts/din-562-dimensions/
DIN562_DIC = [  [2.0,   [ 4.0,  1.4]],
                [2.5,   [ 5.0,  1.6]],
                [3.0,   [ 5.4,  1.8]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head side



// DIN562 nut
module DIN562_nut(d, align=DN_ALIGN_BOTTOM, visual=false)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN562_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN562-nut] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    _align = (align==DN_ALIGN_BOTTOM) ? 
                "z" :
                (align==DN_ALIGN_TOP) ?
                    "Z" : "";

    // construct model
    cubepp([hd,hd,hh], align=_align);    
}


// DIN562 nut hole
module DIN562_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0, 
                        h_off=0, clearance=0.1, h_clearance=undef)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN562_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN562-nut-hole] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    //basic_nut_hole( d=hd, h=hh, align=align,
    //                h_off=h_off, clearance=clearance);

    _h_clearance = is_undef(h_clearance) ? clearance : h_clearance;


    _d = hd + 2*clearance;
    _h = hh + 2*_h_clearance;

    _data = (align==DN_ALIGN_BOTTOM) ? 
                [-_h_clearance, 0, "z"] :
                (align==DN_ALIGN_TOP) ?
                    [_h_clearance, -hh, "Z"] :
                    [0, -hh/2, ""];
    
    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];
    _align = _data[2];
   
    // basic shape
    translate(_hole_tf) 
    if (s_off != 0)
    {
        // if there is non-zero s_off, add side hole
        hull()
        {
            cubepp([_d, _d, _h], align="z");
            translate([s_off,0,0])
                cubepp([_d, _d, _h], align="z");
        }
    }
    else
    { 
        cubepp([_d, _d, _h], align="z");
    }

    // add hole
    translate(_hole_tf)
        cubepp([_d, _d, _h+h_off], align="z"); 

}


// DIN562 get diameter
function DIN562_get_diameter(d, is_inradius) =
    let(sf = is_inradius ? 1 : 1/sin(45))
    sf*basic_nut_get_diameter(d=d, dic=DIN562_DIC);


// DIN562 get height
function DIN562_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN562_DIC);