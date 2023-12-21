include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the head params
DIN985_DIC = [  [3.0,   [ 5.4,  3.9]],
                [6.0,   []]];
//                        '     '-> head height 
//                        '-> head diameter

// DIN985 nut
module DIN985_nut(d, align=DN_ALIGN_BOTTOM, visual=false)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN985_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN985-nut] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    if (visual)
    {
        // TODO fix hardcoded offset
        _off = (align==DN_ALIGN_BOTTOM) ? 
                hh - 1 :
                (align==DN_ALIGN_TOP) ?
                    0 : (hh-1)/2;

        render(2)
        difference(){
            union()
            {
                basic_nut(d=hd, h=hh-1, r=d/2, align=align, visual=visual);   
                
                translate([0,0,_off])
                    scale([1, 1, 1.5])
                        rotate_extrude(convexity=2)
                            translate([2, 0, 0])
                                circle(d = 1.2);
            }

            //cylinderpp(h = 3*hh, r = 1.5, align = "");
        }
    }
    else
    {
        basic_nut(d=hd, h=hh, align=align);   
    }
}


// DIN985 nut hole
module DIN985_nut_hole( d, align=DN_ALIGN_BOTTOM, s_off=0, 
                        h_off=0, clearance=0.1, h_clearance=undef)
{

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=d, dic=DIN985_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN985-nut-hole] undefined entry for d=", d, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_nut_hole( d=hd, h=hh, align=align,
                    h_off=h_off, s_off=s_off,
                    clearance=clearance,
                    h_clearance=h_clearance);

}