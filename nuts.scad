// include constants for align values
include<constants.scad>

// include utils
include<utils.scad>

// include avaliable nuts
include<nuts/DIN439-nut.scad>
include<nuts/DIN562-nut.scad>
include<nuts/DIN934-nut.scad>
include<nuts/DIN985-nut.scad>

// the implemented nut standards (canonical names; see deez_nuts_standard() for the aliases)
DN_NUT_STANDARDS = ["DIN439", "DIN562", "DIN934", "DIN985"];

// __private__ the canonical name of a nut standard, or an error listing the implemented ones
function __dn_nut_standard(standard, ctx) =
    let(s = deez_nuts_standard(standard))
    assert(!is_undef(s) && len([for (b = DN_NUT_STANDARDS) if (b == s) b]) > 0,
        str("[", ctx, "] standard: ", standard, " is not implemented! Available: ", DN_NUT_STANDARDS,
            " (and their ISO names)"))
    s;


// parse avaliable nuts
// '-> argument 'd' the size: a number (3) or a descriptor ("M3", or the bolt "M3x10")
// '-> argument 'standard' e.g. "DIN934" or its ISO name "ISO4032" (spaces and dashes are ignored)
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module nut(d, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _s = __dn_nut_standard(standard, "NUT");
    if (_s=="DIN439")
    {
        DIN439_nut(d=d, align=align, visual=visual, zet=zet);
    }
    else if (_s=="DIN562")
    {
        DIN562_nut(d=d, align=align, visual=visual, zet=zet);
    }
    else if (_s=="DIN934")
    {
        DIN934_nut(d=d, align=align, visual=visual, zet=zet);
    }
    else if (_s=="DIN985")
    {
        DIN985_nut(d=d, align=align, visual=visual, zet=zet);
    }
}


// parse avaliable nuts
module nut_hole(d, standard, align=DN_ALIGN_BOTTOM, s_off=0,
                h_off=0, clearance=0.1, h_clearance=undef, zet=undef)
{
    _s = __dn_nut_standard(standard, "NUT-HOLE");
    if (_s=="DIN439")
    {
        DIN439_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance, zet=zet);
    }
    else if (_s=="DIN562")
    {
        DIN562_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance, zet=zet);
    }
    else if (_s=="DIN934")
    {
        DIN934_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance, zet=zet);
    }
    else if (_s=="DIN985")
    {
        DIN985_nut_hole(d=d, align=align, s_off=s_off, h_off=h_off,
                        clearance=clearance, h_clearance=h_clearance, zet=zet);
    }
}


// nut diameter functions
__dn_nut_diameter_functions = [ ["DIN439", function(x,y) DIN439_get_diameter(x,y)],
                                ["DIN562", function(x,y) DIN562_get_diameter(x,y)],
                                ["DIN934", function(x,y) DIN934_get_diameter(x,y)],
                                ["DIN985", function(x,y) DIN985_get_diameter(x,y)]];

// return nut diameter
// - argument 'd' a number (3) or a descriptor ("M3", "M3x10")
// - undef for an unknown standard or size
function get_nut_diameter(d, standard, is_circumscribed=true) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_nut_diameter_functions))
    is_undef(fnc) ?
        undef :
        fnc(d, is_circumscribed);


// nut height functions
__dn_nut_height_functions = [   ["DIN439", function(d) DIN439_get_height(d)],
                                ["DIN562", function(d) DIN562_get_height(d)],
                                ["DIN934", function(d) DIN934_get_height(d)],
                                ["DIN985", function(d) DIN985_get_height(d)]];

// return nut height
// - undef for an unknown standard or size
function get_nut_height(d, standard) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_nut_height_functions))
    is_undef(fnc) ?
        undef :
        fnc(d);
