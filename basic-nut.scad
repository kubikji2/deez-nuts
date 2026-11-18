// basic nuts and nut holes: the geometry shared by all nuts
// NOTE: included by deez-nuts.scad (with solidpp, the constants and the utils)


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
// '-> argument 'teardrop' false (default), true or the face letter of the printing up direction
//     (across the axis): the hexagon is turned so that a corner points up (printable without
//     supports when the axis is horizontal in the printed part)
module basic_nut_hole(  d=undef, D=undef, h=undef, align=DN_ALIGN_BOTTOM,
                        h_off=0, s_off=0, clearance=0.1, h_clearance=undef, zet=undef, teardrop=false)
{
    _up = deez_nuts_teardrop_up(teardrop, zet, "DEEZ-NUTS:basic-nut-hole");
    // the corners of the hexagon are on +-x; turn them to +-y for an up direction along y
    _rz = is_undef(_up) || _up == "x" || _up == "X" ? 0 : 30;

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
                rotate([0,0,_rz]) basic_nut(d=_wc, h=_h, align=align);
                translate([s_off,0,0])
                    rotate([0,0,_rz]) basic_nut(d=_wc, h=_h, align=align);
            }
        }
        else
        {
            rotate([0,0,_rz]) basic_nut(d=_wc, h=_h, align=align);
        }

        // add hole
        if (h_off > 0)
            translate(_hole_tf)
                rotate([0,0,_rz]) cylinderpp(d=_wc, h=h_off, align="Z", fn=6, polygon="flats");
    }
}


// basic square nut
// '-> argument 'd' the width (across the flats), 'h' the height, 'r' the hole radius (visual only)
// '-> arguments 'align', 'visual' and 'zet' as for basic_nut
module basic_square_nut(d, h, r=undef, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-square-nut"))
    difference()
    {
        cubepp([d, d, h], align=__dn_nut_align(align, "basic-square-nut"));

        if (visual)
            cylinderpp(r=r, h=3*h, align="");
    }
}


// basic square nut hole
// '-> the same arguments and placement as basic_nut_hole ('d' is the width of the square);
//     'h_off' the vertical access hole below the nut, 's_off' the side slot towards +x
module basic_square_nut_hole(   d, h, align=DN_ALIGN_BOTTOM,
                                h_off=0, s_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    _h_clearance = is_undef(h_clearance) ? clearance : h_clearance;

    _w = d + 2*clearance;
    _h = h + 2*_h_clearance;
    _align = __dn_nut_align(align, "basic-square-nut-hole");

    _data = (align==DN_ALIGN_BOTTOM) ?
                [-_h_clearance, 0] :
                (align==DN_ALIGN_TOP) ?
                    [_h_clearance, -h] :
                    [0, -h/2];

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-square-nut-hole"))
    {
        // basic shape (with the side slot)
        translate([0,0,_data[0]])
            hull()
            {
                cubepp([_w, _w, _h], align=_align);
                translate([s_off,0,0])
                    cubepp([_w, _w, _h], align=_align);
            }

        // add hole
        if (h_off > 0)
            translate([0,0,_data[1]])
                cubepp([_w, _w, h_off], align="Z");
    }
}


// basic hexagon nut with a non-metallic insert (visual: the insert is a lighter ring on the top)
// '-> argument 'd' the width across the flats, 'h' the total height, 'm' the height of the metal part
// '-> arguments 'r', 'align', 'visual' and 'zet' as for basic_nut ('align' uses the total height)
module basic_insert_nut(d, h, m, r=undef, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _z0 = align == DN_ALIGN_BOTTOM ? 0 : align == DN_ALIGN_TOP ? -h : -h/2;
    _check = __dn_nut_align(align, "basic-insert-nut");

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-insert-nut"))
    translate([0, 0, _z0])
    {
        if (!visual)
        {
            basic_nut(d=d, h=h, align=DN_ALIGN_BOTTOM);
        }
        else
        {
            difference()
            {
                union()
                {
                    basic_nut(d=d, h=m, align=DN_ALIGN_BOTTOM);
                    // the insert housing: a round collar of the rest of the height
                    translate([0, 0, m - DN_EPS])
                        cylinderpp(d=0.95*d, h=h - m + DN_EPS, align="z", mod_list=[rounding(min(0.4*(h - m), 0.1*d), "to")]);
                }
                cylinderpp(r=r, h=3*h, align="");
            }
        }
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


// ---------------------------------------------------------------------------- standards

// a nut of a standard record (see standards.scad); used by nut()
module deez_nuts_nut(record, d, align=DN_ALIGN_BOTTOM, visual=false, zet=undef, ctx="NUT")
{
    _d = deez_nuts_nut_diameter(d, str("DEEZ-NUTS:", ctx));
    _dims = __dn_standard_dims(record, _d, ctx);
    _shape = record[__DN_STD_SHAPE];

    if (_shape == "square")
        basic_square_nut(d=_dims[0], h=_dims[1], r=_d/2, align=align, visual=visual, zet=zet);
    else if (_shape == "hex-insert")
        basic_insert_nut(d=_dims[0], h=_dims[1], m=_dims[2], r=_d/2, align=align, visual=visual, zet=zet);
    else
        basic_nut(d=_dims[0], h=_dims[1], r=_d/2, align=align, visual=visual, zet=zet);
}


// a nut hole of a standard record; used by nut_hole()
// '-> a nut with an insert gets the hole of its total height
module deez_nuts_nut_hole(  record, d, align=DN_ALIGN_BOTTOM, s_off=0, h_off=0,
                            clearance=0.1, h_clearance=undef, zet=undef, teardrop=false, ctx="NUT-HOLE")
{
    _d = deez_nuts_nut_diameter(d, str("DEEZ-NUTS:", ctx));
    _dims = __dn_standard_dims(record, _d, ctx);

    if (record[__DN_STD_SHAPE] == "square")
        basic_square_nut_hole(d=_dims[0], h=_dims[1], align=align, h_off=h_off, s_off=s_off,
                              clearance=clearance, h_clearance=h_clearance, zet=zet);
    else
        basic_nut_hole(d=_dims[0], h=_dims[1], align=align, h_off=h_off, s_off=s_off,
                       clearance=clearance, h_clearance=h_clearance, zet=zet, teardrop=teardrop);
}


// the width of a nut of a standard record (undef for an unknown size)
// '-> is_circumscribed=true: the diameter across the corners, false: the width across the flats
function deez_nuts_nut_width(record, d, is_circumscribed=true) =
    let(dims = deez_nuts_standard_dims(record, deez_nuts_nut_diameter(d)))
    is_undef(dims) ? undef :
    is_circumscribed ?
        deez_nutz_polygon_width_to_circumscribed_diameter(dims[0], record[__DN_STD_SHAPE] == "square" ? 4 : 6) :
        dims[0];

// the height of a nut of a standard record (the total height for a nut with an insert)
function deez_nuts_nut_height(record, d) =
    let(dims = deez_nuts_standard_dims(record, deez_nuts_nut_diameter(d)))
    is_undef(dims) ? undef : dims[1];
