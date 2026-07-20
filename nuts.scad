// include constants for align values
include<constants.scad>

// include avaliable nuts
include<nuts/DIN439-nut.scad>
include<nuts/DIN562-nut.scad>
include<nuts/DIN934-nut.scad>
include<nuts/DIN985-nut.scad>


// parse avaliable nuts
module nut(d, standard, align=DN_ALIGN_BOTTOM, visual=false)
{
    if (standard=="DIN439")
    {
        DIN439_nut(d=d, align=align, visual=visual);
    }
    else if (standard=="DIN562")
    {
        DIN562_nut(d=d, align=align, visual=visual);
    }
    else if (standard=="DIN934")
    {
        DIN934_nut(d=d, align=align, visual=visual);
    }
    else if (standard=="DIN985")
    {
        DIN985_nut(d=d, align=align, visual=visual);
    }
    else
    {
        assert(false, str("[NUT] standard: ", standard, " is not implemented!"));
    }
}


// parse avaliable nuts
module nut_hole(d, standard, align=DN_ALIGN_BOTTOM, s_off=0,
                h_off=0, clearance=0.1, h_clearance=undef)
{
    if (standard=="DIN439")
    {
        DIN439_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance);
    }
    else if (standard=="DIN562")
    {
        DIN562_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance);
    }
    else if (standard=="DIN934")
    {
        DIN934_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance);
    }
    else if (standard=="DIN985")
    {
        DIN985_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance);
    }
    else
    {
        assert(false, "[NUT-HOLE] standard: ", standard, " is not implemented!");
    }
}


// nut diameter functions 
__dn_nut_diameter_functions = [ ["DIN439", function(x,y) DIN439_get_diameter(x,y)],
                                ["DIN562", function(x,y) DIN562_get_diameter(x,y)],
                                ["DIN934", function(x,y) DIN934_get_diameter(x,y)],
                                ["DIN985", function(x,y) DIN985_get_diameter(x,y)]];

// return nut diameter
function get_nut_diameter(d, standard, is_circumscribed=true) =
    let(fnc = deez_nuts_find_in_dic(key=standard, dic=__dn_nut_diameter_functions))
    is_undef(fnc) ?
        undef :
        fnc(d, is_circumscribed);


// nut height functions 
__dn_nut_height_functions = [   ["DIN439", function(d) DIN439_get_height(d)],
                                ["DIN562", function(d) DIN562_get_height(d)],
                                ["DIN934", function(d) DIN934_get_height(d)],
                                ["DIN985", function(d) DIN985_get_height(d)]];

// return nut height
function get_nut_height(d, standard) =
    let(fnc = deez_nuts_find_in_dic(key=standard, dic=__dn_nut_height_functions))
    is_undef(fnc) ?
        undef :
        fnc(d);