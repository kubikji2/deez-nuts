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
// '-> argument 'zet' defines the axis of the bolt: "z" (default), "x" or "y" (as solidpp); the head
//     points towards +zet
module basic_bolt(  hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                    align=DN_ALIGN_BOTTOM, is_sloped=false, head_fn=undef,
                    head_polygon="corners", zet=undef, head_angle=undef, cross_section=undef)
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
                    cylinderpp(d=hd, h=_hh-_hc, align="z", fn=head_fn, polygon=head_polygon,
                               cross_section=_head_cs);
        }
    }
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
    // "socket", "button", "cheese"
        [dims[0], dims[1], false, undef, "corners", undef];

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
        basic_bolt(hh=_head[1], hd=_head[0], sd=_l[0], sh=_l[1], th=_l[2], align=align,
                   is_sloped=_head[2], head_fn=_head[3], head_polygon=_head[4], head_angle=_head[5]);

        if (visual)
            translate(_tf)
            {
                // the hexagon socket
                if ((_shape == "socket" || _shape == "button" || _shape == "countersunk") && !is_undef(_dims[3]))
                    translate([0, 0, _top + DN_EPS])
                        cylinderpp(d=_dims[2], h=_dims[3] + DN_EPS, align="Z", fn=6, polygon="flats");

                // the slot
                if (_shape == "cheese" && !is_undef(_dims[3]))
                    translate([0, 0, _top + DN_EPS])
                        cubepp([_head[0] + 1, _dims[2], _dims[3] + DN_EPS], align="Z");
            }
    }
}


// a hole for a bolt or a screw of a standard record; used by bolt_hole() and screw_hole()
module deez_nuts_fastener_hole( record, descriptor, align=DN_ALIGN_BOTTOM, sh_off=0, hh_off=0,
                                clearance=0.1, eps=DN_EPS, zet=undef, teardrop=false, ctx="BOLT-HOLE")
{
    _l = __dn_fastener_lengths(record, descriptor, str("DEEZ-NUTS:", ctx));
    _dims = __dn_standard_dims(record, _l[0], ctx, descriptor);
    _head = __dn_fastener_head(record, _dims);

    basic_bolt_hole(hh=_head[1], hd=_head[0], sd=_l[0], sh=_l[1], th=_l[2], align=align,
                    is_sloped=_head[2], sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps,
                    head_fn=_head[3], head_polygon=_head[4], zet=zet, head_angle=_head[5],
                    teardrop=teardrop);
}


// the head diameter of a bolt or a screw of a standard record (undef for an unknown size)
// '-> for a hexagon head: the diameter across the corners (is_circumscribed=true) or the width
//     across the flats (false); for round heads 'is_circumscribed' has no effect
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
