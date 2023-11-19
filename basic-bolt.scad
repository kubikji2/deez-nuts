// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// basic bolt module
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'th' defines total height 
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_ALIGN_TOP for aligning to the head top
//     '-> DN_ALIGN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_ALIGN_BOTTOM for aligning to the shaft bottom
// '-> argument 'is_sloped' defines whether the head is sloped
// '-> argument 'head_fn' defines the fn for the head
module basic_bolt(  hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                    align=DN_ALIGN_BOTTOM, is_sloped=false, head_fn=$fn)
{
    
    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt] define exactly two variables from {hh=", sh ,", sh=", sh,", th=", th,"}"));

    // define sh and hh
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;

    // compute transforms
    _tf = deez_nuts_align_to_transform(sh=_sh, hh=_hh, align=align);
    _eps = min(DN_EPS, _hh);

    // construct model
    translate(_tf)
    {
        // shaft
        cylinderpp(d=sd, h=_sh+_eps, align="z");
        
        // head
        _hd1 = is_sloped ? sd : hd;
        _hd2 = is_sloped ? hd : hd;
        translate([0,0,_sh])
            cylinderpp(d1=_hd1, d2=_hd2, h=_hh, align="z", $fn=head_fn); 
    } 
}


// basic bolt hole
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
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
// '-> argument 'head_fn' defines the fn for the head
module basic_bolt_hole( hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                        align=DN_ALIGN_BOTTOM, is_sloped=false, sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, head_fn=$fn)
{

    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt-hole] define exactly two variables from {hh=", hh ,", sh=", sh,", th=", th,"}"));

    // define sh and hh to get _tf
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;
    
    // define hd and sd
    _hdc = hd + 2*clearance;  
    _sdc = sd + 2*clearance;

    _tf = deez_nuts_align_to_transform(sh=_sh, hh=_hh, align=align);
        
    // adding custom bolt
    translate(add_vecs([0,0,-clearance],_tf))
        basic_bolt( hh=_hh+2*clearance, hd=_hdc, sh=_sh, sd=_sdc,
                    align=DN_ALIGN_BOTTOM, is_sloped=is_sloped, head_fn=head_fn);

    // adding head access hole
    _h_eps = min(eps, hh_off);
    _hh_off = hh_off + _h_eps;
    translate(add_vecs([0,0,_hh+_sh-_h_eps+clearance],_tf))
        cylinderpp(h=_hh_off, d=_hdc, align="z", $fn=head_fn);

    // adding shaft access hole
    _s_eps = min(eps, sh_off);
    translate(add_vecs([0,0,_s_eps],_tf))
        cylinderpp(h=sh_off + _s_eps, d=_sdc, align="Z"); 

}