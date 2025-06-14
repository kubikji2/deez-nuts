include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
// based on: https://www.dingfastener.com/din-934/
//           https://www.fasteners.eu/standards/DIN/934/
//           https://www.beaconcorporation.co.uk/products/nuts/din934-dimensions/
DIN934_DIC = [  [ 2.0,   [ 4.0,  1.6]],
                [ 2.5,   [ 5.0,  2.0]],
                [ 3.0,   [ 5.5,  2.4]],
                [ 6.0,   [10.0,  5.0]],
                [10.0,   [17.0,  8.0]]];
//                        '     '-> head height 
//                        '-> head diameter


// DIN934 nut
module DIN934_nut(d, align=DN_ALIGN_BOTTOM, visual=false)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN934_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN934-nut] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, r=d/2, align=align, visual=visual);

}


// DIN934 nut hole
module DIN934_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0, 
                        h_off=0, clearance=0.1, h_clearance=undef)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN934_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN934-nut-hole] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance);

}


// DIN934 get diameter
function DIN934_get_diameter(d, is_inradius) =
    let(sf = is_inradius ? 1 : 1/sin(60) )
    sf*basic_nut_get_diameter(d=d, dic=DIN934_DIC);

// DIN934 get height
function DIN934_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN934_DIC);