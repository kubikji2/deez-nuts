// include constants for align values
include<constants.scad>

// include all screws
include<screws/LUXPZ-screw.scad>


// parse avaliable screws
module screw(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false)
{
    if (standard=="LUXPZ")
    {
        LUXPZ_screw(descriptor=descriptor, align=align, visual=visual);
    }
    else
    {
        assert(false, str("[SCREW] standard: ", standard, " is not implemented!"));
    }
}


// parse avaliable screws
module screw_hole(  descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS)
{
    if (standard=="LUXPZ")
    {
        LUXPZ_screw_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps);
    }
    else
    {
        assert(false, str("[SCREW-HOLE] standard: ", standard, " is not implemented!"));
    }
}


// screw diameter functions 
__dn_screw_diameter_functions = [["LUXPZ",      function(x,y) LUXPZ_get_head_diameter(x,y)]];

// return head deameter
// circumradius vs inradius
function get_screw_head_diameter(descriptor, standard, is_inradius=false) =
    let(fnc = deez_nuts_find_in_dic(key=standard, dic=__dn_screw_diameter_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor, is_inradius);


// screw functions 
__dn_screw_height_functions = [  ["LUXPZ", function(x) LUXPZ_get_head_height(x)]];

// return head deameter
// circumradius vs inradius
function get_screw_head_height(descriptor, standard) =
    let(fnc = deez_nuts_find_in_dic(key=standard, dic=__dn_screw_height_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor);