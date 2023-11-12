// add constants
include <constants.scad>


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
module custom_bolt_hole(hh, hd, sh, sd, align, sh_off=0, hh_off=0, clearance=0.1, eps=0.01)
{

}