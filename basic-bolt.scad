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

}