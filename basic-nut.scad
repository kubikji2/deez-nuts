// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// basic nut
// '-> argument 'd' is inner (side-to-side) diameter
// '-> argument 'D' is outer (corner-to-coren) diameter
// '-> argument 'h' is nut height
// '-> argument 'align' is nut alignment
module basic_nut(d=undef, D=undef, h=undef, align=DN_BOTTOM)
{

}


// basic nut hole
// '-> argument 'd' is inner (side-to-side) diameter
// '-> argument 'D' is outer (corner-to-coren) diameter
// '-> argument 'h' is nut height
// '-> argument 'align' is nut alignment
// '-> argument 'h_off' defines the nut access hole
// '-> argument 'clearance' defines clearance
// '-> argument 'eps' defines epsilon
module basic_nut_hole(  d=undef, D=undef, h=undef, align=DN_BOTTOM,
                        h_off=0, clearance=0.1, eps=dn_eps)
{

}
