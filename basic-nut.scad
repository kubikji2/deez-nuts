// add solidpp
include <solidpp/solidpp.scad>

// add constants
include <constants.scad>
// add utils
include <utils.scad>


// basic nut
// '-> argument 'd' is inner (side-to-side) diameter
// '-> argument 'D' is outer (corner-to-corner) diameter
// '-> argument 'h' is nut height
// '-> argument 'r' is hole radius
// '-> argument 'align' is nut alignment
module basic_nut(d=undef, D=undef, h=undef, r=undef, align=DN_ALIGN_BOTTOM, visual=false)
{

    assert( __deez_nuts__count_undef_in_list([d, D]) == 1,
            str("[DEEZ-NUTS:basic-nut] define exactly one d=", d ," or D=", D, "!"));
    // TODO fix this
    _D = is_undef(D) ? d/sin(60) : D;

    _align = (align==DN_ALIGN_BOTTOM) ? 
                "z" :
                (align==DN_ALIGN_TOP) ?
                    "Z" : "";

    difference()
    {
        cylinderpp(d=_D, h=h, align=_align, $fn=6);

        if(visual)
        {
            cylinderpp(r=r, h=3*h, align="");
        }
    }
    
}


// basic nut hole
// '-> argument 'd' is inner (side-to-side) diameter
// '-> argument 'D' is outer (corner-to-coren) diameter
// '-> argument 'h' is nut height
// '-> argument 'align' is nut alignment
// '-> argument 'h_off' defines the nut vertical access hole height
// '-> argument 's_off' defines the nut horizontal access hole length
// '-> argument 'clearance' defines clearance
// '-> argument 'h_clearnace' defines the clearance in vertical axis
//     '-> note that 'h_clearance' overrides 'clearance'
module basic_nut_hole(  d=undef, D=undef, h=undef, align=DN_ALIGN_BOTTOM,
                        h_off=0, s_off=0, clearance=0.1, h_clearance=undef)
{

    assert( __deez_nuts__count_undef_in_list([d, D]) == 1,
            str("[DEEZ-NUTS:basic-nut-hole] define exactly one d=", d ," or D=", D, "!"));
    
    _h_clearance = is_undef(h_clearance) ? clearance : h_clearance;
    // TODO fix this
    _D = is_undef(D) ? d/sin(60) + 2*clearance : D + 2*clearance;
    _h = h + 2*_h_clearance;

    _data = (align==DN_ALIGN_BOTTOM) ? 
                [-_h_clearance, 0] :
                (align==DN_ALIGN_TOP) ?
                    [_h_clearance, -h] :
                    [0, -h/2];
    
    _nut_tf = [0,0,_data[0]];
    _hole_tf = [0,0,_data[1]];
   
    // basic shape
    translate(_nut_tf) 
    if (s_off != 0)
    {
        // if there is non-zero s_off, add side hole
        hull()
        {
            basic_nut(D=_D, h=_h, align=align);
            translate([s_off,0,0])
                basic_nut(D=_D, h=_h, align=align);
        }
    }
    else
    {
        basic_nut(D=_D, h=_h, align=align);
    }
    
    // add hole
    translate(_hole_tf)
        cylinderpp(d=_D, h=h_off, align="Z", $fn=6); 
}


// basic implementation to get head diameter from the provided
function basic_nut_get_diameter(d, dic) =
    let(
        _dic_data = deez_nuts_find_in_dic(key=d, dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[0];


// basic implementation to get head height from the provided
function basic_nut_get_height(d, dic) =
    let(
        _dic_data = deez_nuts_find_in_dic(key=d, dic=dic))
    is_undef(_dic_data) ?
        undef : _dic_data[1];