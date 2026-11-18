// include constants for align values
include<constants.scad>

// include utils
include<utils.scad>

// include all screws
include<screws/LUXPZ-screw.scad>

// the implemented screw standards (canonical names)
DN_SCREW_STANDARDS = ["LUXPZ"];

// __private__ the canonical name of a screw standard, or an error listing the implemented ones
function __dn_screw_standard(standard, ctx) =
    let(s = deez_nuts_standard(standard))
    assert(!is_undef(s) && len([for (b = DN_SCREW_STANDARDS) if (b == s) b]) > 0,
        str("[", ctx, "] standard: ", standard, " is not implemented! Available: ", DN_SCREW_STANDARDS))
    s;


// parse avaliable screws
// '-> argument 'descriptor' e.g. "M3x16" (the total length)
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module screw(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _s = __dn_screw_standard(standard, "SCREW");
    if (_s=="LUXPZ")
    {
        LUXPZ_screw(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
}


// parse avaliable screws
module screw_hole(  descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS, zet=undef)
{
    _s = __dn_screw_standard(standard, "SCREW-HOLE");
    if (_s=="LUXPZ")
    {
        LUXPZ_screw_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
}


// screw diameter functions
__dn_screw_diameter_functions = [["LUXPZ",      function(x,y) LUXPZ_get_head_diameter(x,y)]];

// return head deameter
// - undef for an unknown standard or size
function get_screw_head_diameter(descriptor, standard, is_circumscribed=false) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_screw_diameter_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor, is_circumscribed);


// screw functions
__dn_screw_height_functions = [  ["LUXPZ", function(x) LUXPZ_get_head_height(x)]];

// return head height
// - undef for an unknown standard or size
function get_screw_head_height(descriptor, standard) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_screw_height_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor);
