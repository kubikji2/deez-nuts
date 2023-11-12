// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// custom bolt module
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_TOP for aligning to the head top
//     '-> DN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_BOTTOM for aligning to the shaft bottom
module custom_bolt(hh, hd, sh, sd, align)
{
    _tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
    _eps = min(dn_eps, hh);

    translate(_tf)
    {
        cylinderpp(d=sd, h=sh+_eps, align="z");
        translate([0,0,sh])
            cylinderpp(d=hd, h=hh, align="z"); 
    } 
}


// custom bolt hole
// '-> argument 'hh' defines head height
// '-> argument 'hd' defines head diameter
// '-> argument 'sh' defines shaft height
// '-> argument 'sd' defines shaft diameter
// '-> argument 'align' defines alignemnent with expected values
//     '-> DN_TOP for aligning to the head top
//     '-> DN_MIDDLE for aligning to the head bottom (shaft top)
//     '-> DN_BOTTOM for aligning to the shaft bottom
// '-> argument 'sh_off' defines offset from the shaft bottom further down
// '-> argument 'hh_off' defines offset from the head top further up
// '-> argument 'clearance' defines clearance for both head and shaft
// '-> argument 'eps' defines epsilon
module custom_bolt_hole(hh, hd, sh, sd, align, sh_off=0, hh_off=0, clearance=0.1, eps=dn_eps)
{

    _hd = hd + clearance;
    _sd = sd + clearance;

    _tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
    
    
    // adding custom bolt
    custom_bolt(hh=hh, hd=_hd, sh=sh, sd=_sd, align=align);

    // adding head access hole
    _h_eps = min(eps, hh_off);
    _hh_off = hh_off + clearance + hh + _h_eps;
    translate(add_vecs([0,0,sh+_h_eps-clearance],_tf))
        cylinderpp(h=_hh_off, d=_hd, align="z");

    // adding shaft access hole
    _s_eps = min(eps, sh_off);
    translate(add_vecs([0,0,_s_eps],_tf))
        cylinderpp(h=sh_off + _s_eps, d=_sd, align="Z"); 

}