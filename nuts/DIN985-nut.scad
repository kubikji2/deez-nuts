include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// DIN 985 (ISO 10511): prevailing torque (nylon insert) hexagon nut
// TODO verify the values against the standard, add all dimensions
// dictionary to convert the shaft diameter to the nut params
// based on: https://www.beaconcorporation.co.uk/products/nuts/din-985-dimensions/
//           https://monsterbolts.com/products/nuts-din985-zn10-9
DIN985_DIC = [  [2.5,   [ 5.0,  3.4]],
                [3.0,   [ 5.4,  3.9]]];
//                        |     '-> nut height
//                        '-> width (side-to-side)

// DIN985 nut
// '-> argument 'd' the size: a number (3) or a descriptor ("M3", or the bolt "M3x10")
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'visual' adds the hole
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN985_nut(d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN985-nut");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN985_DIC, "DIN985-nut");
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    if (visual)
    {
        // TODO the nylon ring is fixed (r=2, d=1.2) and the hexagon is 1 lower
        _off = (align==DN_ALIGN_BOTTOM) ?
                hh - 1 :
                (align==DN_ALIGN_TOP) ?
                    0 : (hh-1)/2;

        rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:DIN985-nut"))
        render(2)
        union()
        {
            basic_nut(d=hd, h=hh-1, r=_d/2, align=align, visual=visual);

            translate([0,0,_off])
                scale([1, 1, 1.5])
                    rotate_extrude(convexity=2)
                        translate([2, 0, 0])
                            circle(d = 1.2);
        }
    }
    else
    {
        basic_nut(d=hd, h=hh, align=align, zet=zet);
    }

}


// DIN985 nut hole
// '-> argument 'h_off' the vertical access hole below the nut, 's_off' the side slot towards +x
module DIN985_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0,
                        h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    _d = deez_nuts_nut_diameter(d, "DEEZ-NUTS:DIN985-nut-hole");

    // parserd dic data
    _dic_data = __dn_table_entry(_d, DIN985_DIC, "DIN985-nut-hole");
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance, zet=zet);

}


// DIN985 get diameter
// '-> is_circumscribed=true: the diameter across the corners, false: the width across the flats
function DIN985_get_diameter(d, is_circumscribed) =
    let(diameter=basic_nut_get_diameter(d=d, dic=DIN985_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 6) : diameter;


// DIN985 get height
function DIN985_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN985_DIC);
