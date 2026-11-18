include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// DIN 439 B (ISO 4035): thin hexagon nut
// TODO verify the values against the standard, add all dimensions
// dictionary to convert the shaft diameter to the nut params
// based on: https://www.fasteners.eu/standards/DIN/439-B/
DIN439_DIC = [  [2.0,   [ 4.0,  1.2]],
                [2.5,   [ 5.0,  1.6]],
                [3.0,   [ 5.4,  1.8]],
                [6.0,   [10.0,  3.2]]];
//                        |     '-> nut height
//                        '-> nut width (side-to-side)


// DIN439 nut
// '-> argument 'd' the size: a number (3) or a descriptor ("M3", or the bolt "M3x10")
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'visual' adds the hole
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN439_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN439-nut");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN439_DIC, "DIN439-nut");
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut(d=hd, h=hh, r=_d/2, align=align, visual=visual, zet=zet);

}


// DIN439 nut hole
// '-> argument 'h_off' the vertical access hole below the nut, 's_off' the side slot towards +x
module DIN439_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0,
                        h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN439-nut-hole");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN439_DIC, "DIN439-nut-hole");
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance, zet=zet);

}


// DIN439 get diameter
// '-> is_circumscribed=true: the diameter across the corners, false: the width across the flats
function DIN439_get_diameter(d, is_circumscribed) =
    let(diameter=basic_nut_get_diameter(d=d, dic=DIN439_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 6) : diameter;


// DIN439 get height
function DIN439_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN439_DIC);
