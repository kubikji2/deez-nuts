// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


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
// '-> argument 'zet' defines the axis of the bolt: "z" (default), "x" or "y" (as solidpp); the head
//     points towards +zet
module basic_bolt(  hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                    align=DN_ALIGN_BOTTOM, is_sloped=false, head_fn=undef,
                    head_polygon="corners", zet=undef)
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

    // construct model
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-bolt"))
    translate(_tf)
    {
        // shaft
        cylinderpp(d=sd, h=_sh+_eps, align="z");

        // head
        _hd1 = is_sloped ? sd : hd;
        translate([0,0,_sh])
            cylinderpp(d=[_hd1, hd], h=_hh, align="z", fn=head_fn, polygon=head_polygon);
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
module basic_bolt_hole( hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                        align=DN_ALIGN_BOTTOM, is_sloped=false, sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, head_fn=undef, head_polygon="corners", zet=undef)
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

    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:basic-bolt-hole"))
    {
        // adding custom bolt
        translate(add_vecs([0,0,-clearance],_tf))
            basic_bolt( hh=_hh+2*clearance, hd=_hdc, sh=_sh, sd=_sdc,
                        align=DN_ALIGN_BOTTOM, is_sloped=is_sloped, head_fn=head_fn,
                        head_polygon=head_polygon);

        // adding head access hole
        if (hh_off > 0)
        {
            _h_eps = min(eps, hh_off);
            _hh_off = hh_off + _h_eps;
            translate(add_vecs([0,0,_hh+_sh-_h_eps+clearance],_tf))
                cylinderpp(h=_hh_off, d=_hdc, align="z", fn=head_fn, polygon=head_polygon);
        }

        // adding shaft access hole
        if (sh_off > 0)
        {
            _s_eps = min(eps, sh_off);
            translate(add_vecs([0,0,_s_eps],_tf))
                cylinderpp(h=sh_off + _s_eps, d=_sdc, align="Z");
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
