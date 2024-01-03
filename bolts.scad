// include constants for align values
include<constants.scad>

// include utils for diampeter parsin
include<utils.scad>

include<bolts/DIN84A-bolt.scad>
include<bolts/DIN933-bolt.scad>
include<bolts/DIN912-bolt.scad>


// parse avaliable bolts
module bolt(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false)
{
    if (standard == "DIN84A")
    {
        DIN84A_bolt(descriptor=descriptor, align=align, visual=visual);
    }
    else if(standard == "DIN933")
    {
        DIN933_bolt(descriptor=descriptor, align=align, visual=visual);
    }
    else if(standard == "DIN912")
    {
        DIN912_bolt(descriptor=descriptor, align=align, visual=visual);
    }
    else
    {
        assert(false, str("[BOLT] standard: ", standard, " is not implemented!"));
    }
}


// parse avaliable bolts
module bolt_hole(   descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS)
{
    if (standard == "DIN84A")
    {
        DIN84A_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps);
    }
    else if(standard == "DIN933")
    {
        DIN933_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps);
    }
    else if(standard == "DIN912")
    {
        DIN912_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps);
    }
    else
    {
        assert(false, str("[BOLT-HOLE] standard: ", standard, " is not implemented!"));
    }
}


// bolt functions 
__dn_bolt_functions = [["DIN84A", function(x,y) DIN84A_get_head_diameter(x,y)],
                       ["DIN933", function(x,y) DIN933_get_head_diameter(x,y)],
                       ["DIN912", function(x,y) DIN912_get_head_diameter(x,y)]];

// return head deameter
// circumradius vs inradius
function get_bolt_head_diameter(descriptor, standard, is_inradius=false) =
    let(fnc = deez_nuts_find_in_dic(key=standard, dic=__dn_bolt_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor, is_inradius);
