include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// DIN 562: thin square nut
// TODO verify the values against the standard, add all dimensions
// dictionary to convert the shaft diameter to the nut params
// based on: https://www.beaconcorporation.co.uk/products/nuts/din-562-dimensions/
DIN562_DIC = [  [2.0,   [ 4.0,  1.4]],
                [2.5,   [ 5.0,  1.6]],
                [3.0,   [ 5.4,  1.8]]];
//                        |     '-> nut height
//                        '-> nut width (side-to-side)



// DIN562 nut
// '-> argument 'd' the size: a number (3) or a descriptor ("M3", or the bolt "M3x10")
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'visual' adds the hole
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN562_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN562-nut");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN562_DIC, "DIN562-nut");
    hd = _dic_data[0];
    hh = _dic_data[1];

    _align = __dn_nut_align(align, "DIN562-nut");

    // construct model
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:DIN562-nut"))
    difference()
    {
        cubepp([hd,hd,hh], align=_align);

        if (visual)
            cylinderpp(d=_d, h=3*hh, align="");
    }
}


// DIN562 nut hole
// '-> the same arguments and placement as the hexagon nut holes (e.g. DIN934_nut_hole):
//     'h_off' the vertical access hole below the nut, 's_off' the side slot towards +x
module DIN562_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0,
                        h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN562-nut-hole");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN562_DIC, "DIN562-nut-hole");
    hd = _dic_data[0];
    hh = _dic_data[1];

    _h_clearance = is_undef(h_clearance) ? clearance : h_clearance;

    _w = hd + 2*clearance;
    _h = hh + 2*_h_clearance;
    _align = __dn_nut_align(align, "DIN562-nut-hole");

    _data = (align==DN_ALIGN_BOTTOM) ?
                [-_h_clearance, 0] :
                (align==DN_ALIGN_TOP) ?
                    [_h_clearance, -hh] :
                    [0, -hh/2];

    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:DIN562-nut-hole"))
    {
        // basic shape
        translate(_nut_tf)
        if (s_off != 0)
        {
            // if there is non-zero s_off, add side hole
            hull()
            {
                cubepp([_w, _w, _h], align=_align);
                translate([s_off,0,0])
                    cubepp([_w, _w, _h], align=_align);
            }
        }
        else
        {
            cubepp([_w, _w, _h], align=_align);
        }

        // add hole
        if (h_off > 0)
            translate(_hole_tf)
                cubepp([_w, _w, h_off], align="Z");
    }
}


// DIN562 get diameter
// '-> is_circumscribed=true: the diagonal of the square, false: the width
function DIN562_get_diameter(d, is_circumscribed) =
    let(diameter=basic_nut_get_diameter(d=d, dic=DIN562_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 4) : diameter;


// DIN562 get height
function DIN562_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN562_DIC);
