// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// __private__ solidpp align string of a nut (or a nut hole) for the deez-nuts align
function __dn_nut_align(align, ctx) =
    assert(align == DN_ALIGN_BOTTOM || align == DN_ALIGN_MIDDLE || align == DN_ALIGN_TOP,
        str("[DEEZ-NUTS:", ctx, "] align must be DN_ALIGN_BOTTOM (\"", DN_ALIGN_BOTTOM, "\"), DN_ALIGN_MIDDLE (\"",
            DN_ALIGN_MIDDLE, "\") or DN_ALIGN_TOP (\"", DN_ALIGN_TOP, "\"), got ", align))
    align == DN_ALIGN_BOTTOM ? "z" : align == DN_ALIGN_TOP ? "Z" : "";

// __private__ the width across the flats of a regular polygon with 'fn' sides from 'd'
// (across the flats) or 'D' (across the corners)
function __dn_nut_width(d, D, fn, ctx) =
    assert(__deez_nuts__count_undef_in_list([d, D]) == 1,
        str("[DEEZ-NUTS:", ctx, "] define exactly one d=", d ," or D=", D, "!"))
    is_undef(D) ? d : D*cos(180/fn);


// basic nut
// '-> argument 'd' is inner (side-to-side) diameter, i.e. the width across the flats
// '-> argument 'D' is outer (corner-to-corner) diameter
// '-> argument 'h' is nut height
// '-> argument 'r' is hole radius (visual only)
// '-> argument 'align' is nut alignment (DN_ALIGN_BOTTOM, DN_ALIGN_MIDDLE, DN_ALIGN_TOP)
// '-> argument 'visual' adds the hole
// '-> argument 'zet' defines the axis of the nut: "z" (default), "x" or "y" (as solidpp)
module basic_nut(d=undef, D=undef, h=undef, r=undef, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _w = __dn_nut_width(d, D, 6, "basic-nut");
    _align = __dn_nut_align(align, "basic-nut");

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-nut"))
    difference()
    {
        cylinderpp(d=_w, h=h, align=_align, fn=6, polygon="flats");

        if(visual)
        {
            cylinderpp(r=r, h=3*h, align="");
        }
    }

}


// basic nut hole
// '-> argument 'd' is inner (side-to-side) diameter, i.e. the width across the flats
// '-> argument 'D' is outer (corner-to-coren) diameter
// '-> argument 'h' is nut height
// '-> argument 'align' is nut alignment
// '-> argument 'h_off' defines the nut vertical access hole height (below the nut)
// '-> argument 's_off' defines the nut horizontal access hole length (towards +x)
// '-> argument 'clearance' defines clearance (added to each flat)
// '-> argument 'h_clearnace' defines the clearance in vertical axis
//     '-> note that 'h_clearance' overrides 'clearance'
// '-> argument 'zet' defines the axis of the nut: "z" (default), "x" or "y" (as solidpp)
module basic_nut_hole(  d=undef, D=undef, h=undef, align=DN_ALIGN_BOTTOM,
                        h_off=0, s_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{

    _w = __dn_nut_width(d, D, 6, "basic-nut-hole");
    _wc = _w + 2*clearance;

    _h_clearance = is_undef(h_clearance) ? clearance : h_clearance;
    _h = h + 2*_h_clearance;

    _data = (align==DN_ALIGN_BOTTOM) ?
                [-_h_clearance, 0] :
                (align==DN_ALIGN_TOP) ?
                    [_h_clearance, -h] :
                    [0, -h/2];

    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-nut-hole"))
    {
        // basic shape
        translate(_nut_tf)
        if (s_off != 0)
        {
            // if there is non-zero s_off, add side hole
            hull()
            {
                basic_nut(d=_wc, h=_h, align=align);
                translate([s_off,0,0])
                    basic_nut(d=_wc, h=_h, align=align);
            }
        }
        else
        {
            basic_nut(d=_wc, h=_h, align=align);
        }

        // add hole
        if (h_off > 0)
            translate(_hole_tf)
                cylinderpp(d=_wc, h=h_off, align="Z", fn=6, polygon="flats");
    }
}


// basic implementation to get head diameter from the provided
function basic_nut_get_diameter(d, dic) =
    let(
        _dic_data = deez_nuts_find_in_dic(key=deez_nuts_nut_diameter(d), dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[0];


// basic implementation to get head height from the provided
function basic_nut_get_height(d, dic) =
    let(
        _dic_data = deez_nuts_find_in_dic(key=deez_nuts_nut_diameter(d), dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[1];
