// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// custom screw module
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'th' defines total height 
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_TOP for aligning to the head top
//     '-> DN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_BOTTOM for aligning to the shaft bottom
// '-> argument 'is_sloped' defines whether the head is sloped
module basic_bolt(hh=undef, hd=undef, sh=undef, sd=undef, th=undef, align=DN_BOTTOM, is_sloped=false)
{
    
    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt] define exactly two variables from {sh=", sh ,", sd=", sd,", th=", th,"}"));

    // define sh and hh
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;

    // compute transforms
    _tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
    _eps = min(dn_eps, hh);

    // construct model
    translate(_tf)
    {
        // shaft
        cylinderpp(d=sd, h=sh+_eps, align="z");
        
        // head
        _hd1 = is_sloped ? sd : hd;
        _hd2 = is_sloped ? hd : hd;
        translate([0,0,sh])
            cylinderpp(d1=_hd1, d2=_hd2, h=hh, align="z"); 
    } 
}


// custom screw hole
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'th' defines total height 
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_TOP for aligning to the head top
//     '-> DN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_BOTTOM for aligning to the shaft bottom
// '-> argument 'is_sloped' defines whether the head is sloped
// '-> argument 'sh_off' defines offset from the shaft bottom further down
// '-> argument 'hh_off' defines offset from the head top further up
// '-> argument 'clearance' defines clearance for both head and shaft
// '-> argument 'eps' defines epsilon
module basic_bolt_hole( hh=undef, hd=undef, sh=undef, sd=undef, th=undef,
                        align=DN_BOTTOM, is_sloped=false, sh_off=0, hh_off=0,
                        clearance=0.1, eps=dn_eps)
{

    // check number of required arguments
    assert( __deez_nuts__count_undef_in_list([hh, sh, th]) == 1,
            str("[DEEZ-NUTS:basic-bolt-hole] define exactly two variables from {sh=", sh ,", sd=", sd,", th=", th,"}"));

    // define sh and hh to get _tf
    _sh = is_undef(sh) ? th-hh : sh;
    _hh = is_undef(hh) ? th-sh : hh;
    
    // define hd and sd
    _hdc = hd + clearance;  
    _sdc = sd + clearance;

    _tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
        
    // adding custom bolt
    translate(add_vecs([0,0,0],_tf))
        basic_bolt( hh=_hh+clearance, hd=_hdc, sh=_sh-clearance, sd=_sdc,
                    align=DN_BOTTOM, is_sloped=is_sloped);

    // adding head access hole
    _h_eps = min(eps, hh_off);
    _hh_off = hh_off + _h_eps;
    translate(add_vecs([0,0,hh+sh+_h_eps],_tf))
        cylinderpp(h=_hh_off, d=_hdc, align="z");

    // adding shaft access hole
    _s_eps = min(eps, sh_off);
    translate(add_vecs([0,0,_s_eps],_tf))
        cylinderpp(h=sh_off + _s_eps, d=_sdc, align="Z"); 

}