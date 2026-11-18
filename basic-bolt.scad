// basic bolt and bolt hole: the geometry shared by all bolts and screws
// NOTE: included by deez-nuts.scad (with solidpp, the constants and the utils)


// basic bolt module
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter (the width across the flats for head_polygon="flats")
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'th' defines total height
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_ALIGN_TOP for aligning to the head top
//     '-> DN_ALIGN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_ALIGN_BOTTOM for aligning to the shaft bottom
// '-> argument 'is_sloped' defines whether the head is sloped (countersunk)
// '-> argument 'head_fn' defines the number of sides of the head (undef: $fn, $fa, $fs)
// '-> argument 'head_polygon' defines how the head polygon relates to 'hd' (solidpp 'polygon'):
//     "corners" (default) puts the corners on 'hd', "flats" the flats (a hex head of the width 'hd')
// '-> argument 'head_angle' the angle of a sloped (countersunk) head, e.g. 90: the cone goes from 'sd'
//     to 'hd' at this angle and the rest of 'hh' is a cylinder; undef (default): the cone takes 'hh'
// '-> argument 'cross_section' the solidpp cross_section of the round parts (e.g. a teardrop)
// '-> argument 'head_mod_list' solidpp modifiers of the (cylindrical part of the) head, e.g. the dome
//     of a button head: [rounding([across, along], "to")]
// '-> argument 'head_chamfer' true: the 30 deg chamfer of the corners of a polygonal head (the top)
// '-> argument 'zet' defines the axis of the bolt: "z" (default), "x" or "y" (as solidpp); the head
//     points towards +zet
module basic_bolt(  hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                    align=DN_ALIGN_BOTTOM, is_sloped=false, head_fn=undef,
                    head_polygon="corners", zet=undef, head_angle=undef, cross_section=undef,
                    head_mod_list=[], head_chamfer=false)
{

    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt] define exactly two variables from {hh=", hh ,", sh=", sh,", th=", th,"}"));

    // define sh and hh
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;
    assert(_sh > 0 && _hh > 0,
           str("[DEEZ-NUTS:basic-bolt] the shaft and the head must be positive, got sh=", _sh, ", hh=", _hh));

    // compute transforms
    _tf = deez_nuts_align_to_transform(sh=_sh, hh=_hh, align=align);
    _eps = min(DN_EPS, _hh);

    // the cone of a sloped head and the cylinder above it
    _hc = !is_sloped ? 0 : is_undef(head_angle) ? _hh : min(_hh, (hd - sd)/2/tan(head_angle/2));

    // a polygonal head (e.g. a hexagon) keeps its shape
    _head_cs = head_polygon == "corners" ? cross_section : undef;

    // construct model
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-bolt"))
    translate(_tf)
    {
        // shaft
        cylinderpp(d=sd, h=_sh+_eps, align="z", cross_section=cross_section);

        // head
        translate([0,0,_sh])
        {
            if (_hc > 0)
                cylinderpp(d=[sd, hd], h=_hc, align="z", fn=head_fn, polygon=head_polygon,
                           cross_section=_head_cs);
            if (_hh - _hc > 0)
                translate([0,0,_hc])
                    // NOTE: no intersection() with a false if(): an empty child would empty it
                    if (head_chamfer)
                        intersection()
                        {
                            cylinderpp(d=hd, h=_hh-_hc, align="z", fn=head_fn, polygon=head_polygon,
                                       cross_section=_head_cs, mod_list=head_mod_list);
                            __dn_corner_chamfer(hd, _hh-_hc, head_fn, head_polygon, "t");
                        }
                    else
                        cylinderpp(d=hd, h=_hh-_hc, align="z", fn=head_fn, polygon=head_polygon,
                                   cross_section=_head_cs, mod_list=head_mod_list);
        }
    }
}


// __private__ the body that chamfers the corners of a polygonal head or nut by 30 deg: a cylinder
// through the corners, bevelled from 95 % of the width across the flats (at the face) outwards
// '-> 'w' the width ('polygon'="flats") or the corner diameter ("corners"), 'faces' "t", "b" or "tb"
module __dn_corner_chamfer(w, h, fn, polygon, faces)
{
    _n = is_undef(fn) ? 6 : fn;
    _e = polygon == "flats" ? w/cos(180/_n) : w;          // across the corners
    _s = polygon == "flats" ? w : w*cos(180/_n);          // across the flats
    _a = (_e - 0.95*_s)/2;                                // the chamfer across
    _b = min(_a*tan(30), 0.45*h);                         // and along the axis
    cylinderpp(d=_e + 2*DN_EPS, h=h, align="z", mod_list=[bevel([_a + DN_EPS, _b], faces == "tb" ? ["to", "bo"] : str(faces, "o"))]);
}


// basic bolt hole
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter (the width across the flats for head_polygon="flats")
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'th' defines total height
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_ALIGN_TOP for aligning to the head top
//     '-> DN_ALIGN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_ALIGN_BOTTOM for aligning to the shaft bottom
// '-> argument 'is_sloped' defines whether the head is sloped
// '-> argument 'sh_off' defines offset from the shaft bottom further down
// '-> argument 'hh_off' defines offset from the head top further up
// '-> argument 'clearance' defines clearance for both head and shaft
// '-> argument 'eps' defines epsilon
// '-> argument 'head_fn' defines the number of sides of the head (undef: $fn, $fa, $fs)
// '-> argument 'head_polygon' as for basic_bolt; the clearance is added across the flats too
// '-> argument 'zet' defines the axis of the hole: "z" (default), "x" or "y" (as solidpp)
// '-> argument 'head_angle' as for basic_bolt
// '-> argument 'teardrop' false (default), true or the face letter the tip points to (in the frame
//     of the call, across the hole): the round parts get a teardrop cross-section, printable
//     without supports when the hole is horizontal in the printed part
module basic_bolt_hole( hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                        align=DN_ALIGN_BOTTOM, is_sloped=false, sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, head_fn=undef, head_polygon="corners", zet=undef,
                        head_angle=undef, teardrop=false)
{

    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt-hole] define exactly two variables from {hh=", hh ,", sh=", sh,", th=", th,"}"));
    assert(sh_off >= 0 && hh_off >= 0,
           str("[DEEZ-NUTS:basic-bolt-hole] sh_off and hh_off must not be negative, got sh_off=", sh_off,
               ", hh_off=", hh_off));

    // define sh and hh to get _tf
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;

    // define hd and sd
    _hdc = hd + 2*clearance;
    _sdc = sd + 2*clearance;

    _tf = deez_nuts_align_to_transform(sh=_sh, hh=_hh, align=align);

    // the teardrop in the frame of the hole (built along z); a polygonal head stays polygonal
    _up = deez_nuts_teardrop_up(teardrop, zet, "DEEZ-NUTS:basic-bolt-hole");
    _cs = is_undef(_up) ? undef : teardrop(up=_up);
    _head_cs = head_polygon == "corners" ? _cs : undef;

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-bolt-hole"))
    {
        // adding custom bolt
        translate(add_vecs([0,0,-clearance],_tf))
            basic_bolt( hh=_hh+2*clearance, hd=_hdc, sh=_sh, sd=_sdc,
                        align=DN_ALIGN_BOTTOM, is_sloped=is_sloped, head_fn=head_fn,
                        head_polygon=head_polygon, head_angle=head_angle, cross_section=_cs);

        // adding head access hole
        if (hh_off > 0)
        {
            _h_eps = min(eps, hh_off);
            _hh_off = hh_off + _h_eps;
            translate(add_vecs([0,0,_hh+_sh-_h_eps+clearance],_tf))
                cylinderpp(h=_hh_off, d=_hdc, align="z", fn=head_fn, polygon=head_polygon,
                           cross_section=_head_cs);
        }

        // adding shaft access hole
        if (sh_off > 0)
        {
            _s_eps = min(eps, sh_off);
            translate(add_vecs([0,0,_s_eps],_tf))
                cylinderpp(h=sh_off + _s_eps, d=_sdc, align="Z", cross_section=_cs);
        }
    }
}


// basic implementation to get head diameter
// from provided descriptor and dictionary
function basic_bolt_get_head_diameter(descriptor, dic) =
    let(
        _parsed_data = deez_nuts_parse_descriptor(descriptor),
        sd = _parsed_data[0],
        _dic_data = deez_nuts_find_in_dic(key=sd, dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[0];


// basic implementation to get head height from the provided
function basic_bolt_get_head_height(descriptor, dic) =
    let(
        _parsed_data = deez_nuts_parse_descriptor(descriptor),
        sd = _parsed_data[0],
        _dic_data = deez_nuts_find_in_dic(key=sd, dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[1];


// ---------------------------------------------------------------------------- standards

// __private__ the parameters of basic_bolt for a standard record and a size:
// [hd, hh, is_sloped, head_fn, head_polygon, head_angle]
function __dn_fastener_head(record, dims) =
    let(shape = record[__DN_STD_SHAPE])
    shape == "hex" ?
        [dims[0], dims[1], false, 6, "flats", undef] :
    shape == "countersunk" || shape == "countersunk-z" ?
        [dims[0], dims[1], true, undef, "corners", 90] :
    // "socket", "button", "cheese", "button-flange" (the flange diameter: the bolt adds the button)
        [dims[0], dims[1], false, undef, "corners", undef];

// __private__ the dome of a button head: an elliptical rounding of the top edge from the edge of the
// socket (across the corners, with a margin) down to 'h' (the height of the dome) times 0.9, so a
// short cylindrical edge stays at the bottom; no socket known: a flat top of a third of the diameter
function __dn_button_dome(dk, h, s) =
    let(top = is_undef(s) ? dk/3 : min(1.25*s/cos(30), 0.6*dk))
    [rounding([(dk - top)/2, 0.9*h], "to")];

// __private__ the illustrative shape of a cylindrical head of a part (the holes keep the cylinder):
// '-> "button": the dome; "socket": a rounded top edge; "cheese": a slightly domed top
function __dn_head_mods(shape, dk, k, s) =
    shape == "button" ? __dn_button_dome(dk, k, s) :
    shape == "socket" ? [rounding(0.08*dk, "to")] :
    shape == "cheese" ? [rounding([0.12*dk, 0.25*k], "to")] :
    [];

// the approximate dimensions of a Pozidriv recess (illustrative): [diameter at the top, depth,
// width of the main wings], by the size (PZ0 to PZ4)
DN_POZIDRIV = [[0, [1.9, 1.2, 0.45]], [1, [3.2, 1.9, 0.7]], [2, [4.6, 2.6, 1.0]],
               [3, [6.4, 3.4, 1.45]], [4, [8.7, 4.6, 2.0]]];

// a Pozidriv recess (to be subtracted): the top at z = 0, going down
// '-> 'pz' the size (0 to 4), or 'dims' [diameter, depth, wing width] directly
module deez_nuts_pozidriv(pz=2, dims=undef)
{
    _p = is_undef(dims) ? deez_nuts_find_in_dic(pz, DN_POZIDRIV) : dims;
    assert(!is_undef(_p), str("[DEEZ-NUTS:pozidriv] unknown Pozidriv size ", pz, ", available: ",
                              deez_nuts_dic_keys(DN_POZIDRIV)));
    m = _p[0]; t = _p[1]; w = _p[2];

    union()
    {
        // the central cone
        cylinderpp(d=[0.35*w, 0.55*m], h=t, align="Z");

        // the two main wings: V-shaped slots, full width at the top, narrow at the bottom
        for (a = [0, 90])
            rotate([0, 0, a])
                hull()
                {
                    cubepp([m, w, DN_EPS], align="Z");
                    translate([0, 0, -t + DN_EPS]) cubepp([w, w, DN_EPS], align="Z");
                }

        // the four secondary wings between them (the Pozidriv ribs), shallower
        for (a = [45, 135])
            rotate([0, 0, a])
                hull()
                {
                    cubepp([0.7*m, 0.4*w, DN_EPS], align="Z");
                    translate([0, 0, -0.55*t + DN_EPS]) cubepp([0.4*w, 0.4*w, DN_EPS], align="Z");
                }
    }
}


// __private__ [sd, sh, th] from the descriptor and the length convention of the record
function __dn_fastener_lengths(record, descriptor, ctx) =
    let(p = deez_nuts_parse_descriptor_with_length(descriptor, ctx))
    record[__DN_STD_LENGTH] == "total" ? [p[0], undef, p[1]] : [p[0], p[1], undef];


// a bolt or a screw of a standard record (see standards.scad); used by bolt() and screw()
module deez_nuts_fastener(record, descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef, ctx="BOLT")
{
    _l = __dn_fastener_lengths(record, descriptor, str("DEEZ-NUTS:", ctx));
    _dims = __dn_standard_dims(record, _l[0], ctx, descriptor);
    _head = __dn_fastener_head(record, _dims);
    _shape = record[__DN_STD_SHAPE];

    _sh = is_undef(_l[1]) ? _l[2] - _head[1] : _l[1];
    _tf = deez_nuts_align_to_transform(sh=_sh, hh=_head[1], align=align);
    _top = _sh + _head[1];

    rotate(deez_nuts_zet_rotation(zet, str("DEEZ-NUTS:", ctx)))
    difference()
    {
        // the body (one child of the difference)
        union()
        if (_shape == "button-flange")
        {
            // the button (dk) over the full head height (its dome above the flange), and the
            // flange (dc, c) at its bottom
            basic_bolt(hh=_head[1], hd=_dims[4], sd=_l[0], sh=_l[1], th=_l[2], align=align,
                       head_mod_list=__dn_button_dome(_dims[4], _head[1] - _dims[5], _dims[2]));
            translate(_tf)
                translate([0, 0, _sh])
                    cylinderpp(d=_dims[0], h=_dims[5], align="z");
        }
        else
        {
            basic_bolt(hh=_head[1], hd=_head[0], sd=_l[0], sh=_l[1], th=_l[2], align=align,
                       is_sloped=_head[2], head_fn=_head[3], head_polygon=_head[4], head_angle=_head[5],
                       head_mod_list=__dn_head_mods(_shape, _head[0], _head[1], _dims[2]),
                       head_chamfer=_shape == "hex");
        }

        if (visual)
            translate(_tf)
            {
                // the hexagon socket
                if ((_shape == "socket" || _shape == "button" || _shape == "button-flange" || _shape == "countersunk")
                    && !is_undef(_dims[3]))
                    translate([0, 0, _top + DN_EPS])
                        cylinderpp(d=_dims[2], h=_dims[3] + DN_EPS, align="Z", fn=6, polygon="flats");

                // the Pozidriv recess
                if (_shape == "countersunk-z" && !is_undef(_dims[2]))
                    translate([0, 0, _top + DN_EPS])
                        deez_nuts_pozidriv(_dims[2]);

                // the slot
                if (_shape == "cheese" && !is_undef(_dims[3]))
                    translate([0, 0, _top + DN_EPS])
                        cubepp([_head[0] + 1, _dims[2], _dims[3] + DN_EPS], align="Z");
            }
    }
}


// a hole for a bolt or a screw of a standard record; used by bolt_hole() and screw_hole()
// '-> the dimensions are the maxima of the standard unless $dn_tolerance is set
module deez_nuts_fastener_hole( record, descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0,
                                clearance=0.1, eps=DN_EPS, zet=undef, teardrop=false, ctx="BOLT-HOLE")
{
    _l = __dn_fastener_lengths(record, descriptor, str("DEEZ-NUTS:", ctx));
    _dims = __dn_standard_dims(record, _l[0], ctx, descriptor, deez_nuts_hole_tolerance());
    _head = __dn_fastener_head(record, _dims);

    basic_bolt_hole(hh=_head[1], hd=_head[0], sd=_l[0], sh=_l[1], th=_l[2], align=align,
                    is_sloped=_head[2], sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps,
                    head_fn=_head[3], head_polygon=_head[4], zet=zet, head_angle=_head[5],
                    teardrop=teardrop);
}


// the head diameter of a bolt or a screw of a standard record (undef for an unknown size)
// '-> for a hexagon head: the diameter across the corners (is_circumscribed=true) or the width
//     across the flats (false); for round heads 'is_circumscribed' has no effect
// '-> for a head with a flange: the diameter of the flange
function deez_nuts_fastener_head_diameter(record, descriptor, is_circumscribed=true) =
    let(dims = deez_nuts_standard_dims(record, deez_nuts_parse_descriptor(descriptor)[0]))
    is_undef(dims) ? undef :
    record[__DN_STD_SHAPE] == "hex" && is_circumscribed ?
        deez_nutz_polygon_width_to_circumscribed_diameter(dims[0], 6) :
        dims[0];

// the head height of a bolt or a screw of a standard record (undef for an unknown size)
function deez_nuts_fastener_head_height(record, descriptor) =
    let(dims = deez_nuts_standard_dims(record, deez_nuts_parse_descriptor(descriptor)[0]))
    is_undef(dims) ? undef : dims[1];
