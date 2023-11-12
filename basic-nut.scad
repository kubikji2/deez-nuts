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

    assert( __deez_nuts__count_undef_in_list([d, D]) == 1,
            str("[DEEZ-NUTS:basic-nut] define exactly one d=", d ," or D=", D, "!"));
    
    _D = is_undef(D) ? d/sin(60) : D;

    _align = (align==DN_BOTTOM) ? 
                "z" :
                (align==DN_TOP) ?
                    "Z" : "";

    cylinderpp(d=_D, h=h, align=_align, $fn=6);

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

    assert( __deez_nuts__count_undef_in_list([d, D]) == 1,
            str("[DEEZ-NUTS:basic-nut-hole] define exactly one d=", d ," or D=", D, "!"));
    
    _D = is_undef(D) ? d/sin(60) + 2*clearance : D + 2*clearance;
    _h = h + 2*clearance;

    _data = (align==DN_BOTTOM) ? 
                [-clearance, 0] :
                (align==DN_TOP) ?
                    [clearance, -h] :
                    [0, -h/2];
    
    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];
   
    // basic shape
    translate(_nut_tf) 
        basic_nut(D=_D, h=_h, align=align);
    
    // add hole
    translate(_hole_tf)
        cylinderpp(d=_D, h=h_off, align="Z", $fn=6); 
}
