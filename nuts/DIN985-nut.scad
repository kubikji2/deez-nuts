include <../constants.scad>
include <../utils.scad>
include <../basic-nut.scad>


// TODO add all dimensions
// dictionary to convert the shaft diameter to the nut params
// based on: https://www.beaconcorporation.co.uk/products/nuts/din-985-dimensions/
//           https://monsterbolts.com/products/nuts-din985-zn10-9
DIN985_DIC = [  [2.5,   [ 5.0,  3.4]],
                [3.0,   [ 5.4,  3.9]],
                [6.0,   []]];
//                        |     '-> nut height 
//                        '-> width (side-to-side)

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


// DIN985 get diameter
function DIN985_get_diameter(d, is_circumscribed) =
    let(diameter=basic_nut_get_diameter(d=d, dic=DIN985_DIC))
    is_circumscribed ? deez_nutz_polygon_width_to_circumscribed_diameter(diameter, 6) : diameter;


// DIN985 get height
function DIN985_get_height(d) =
    basic_nut_get_height(d=d, dic=DIN985_DIC);