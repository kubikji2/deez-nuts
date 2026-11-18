// include constants for align values
include<constants.scad>

// include utils for diampeter parsin
include<utils.scad>

include<bolts/DIN84A-bolt.scad>
include<bolts/DIN933-bolt.scad>
include<bolts/DIN912-bolt.scad>
include<bolts/DIN7380-1-bolt.scad>
include<bolts/DIN7991-bolt.scad>

// the implemented bolt standards (canonical names; see deez_nuts_standard() for the aliases)
DN_BOLT_STANDARDS = ["DIN84A", "DIN933", "DIN912", "DIN7380-1", "DIN7991"];

// __private__ the canonical name of a bolt standard, or an error listing the implemented ones
function __dn_bolt_standard(standard, ctx) =
    let(s = deez_nuts_standard(standard))
    assert(!is_undef(s) && len([for (b = DN_BOLT_STANDARDS) if (b == s) b]) > 0,
        str("[", ctx, "] standard: ", standard, " is not implemented! Available: ", DN_BOLT_STANDARDS,
            " (and their ISO names)"))
    s;


// parse avaliable bolts
// '-> argument 'descriptor' e.g. "M3x20"
// '-> argument 'standard' e.g. "DIN912" or its ISO name "ISO4762" (spaces and dashes are ignored)
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module bolt(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    _s = __dn_bolt_standard(standard, "BOLT");
    if (_s == "DIN84A")
    {
        DIN84A_bolt(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
    else if(_s == "DIN933")
    {
        DIN933_bolt(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
    else if(_s == "DIN912")
    {
        DIN912_bolt(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
    else if (_s == "DIN7380-1")
    {
        DIN73801_bolt(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
    else if (_s == "DIN7991")
    {
        DIN7991_bolt(descriptor=descriptor, align=align, visual=visual, zet=zet);
    }
}


// parse avaliable bolts
module bolt_hole(   descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS, zet=undef)
{
    _s = __dn_bolt_standard(standard, "BOLT-HOLE");
    if (_s == "DIN84A")
    {
        DIN84A_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
    else if(_s == "DIN933")
    {
        DIN933_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
    else if(_s == "DIN912")
    {
        DIN912_bolt_hole(   descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
    else if (_s == "DIN7380-1")
    {
        DIN73801_bolt_hole( descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
    else if (_s == "DIN7991")
    {
        DIN7991_bolt_hole(  descriptor=descriptor, align=align,
                            sh_off=sh_off, hh_off=hh_off,
                            clearance=clearance, eps=eps, zet=zet);
    }
}


// bolt diameter functions
__dn_bolt_diameter_functions = [["DIN84A",      function(x,y) DIN84A_get_head_diameter(x,y)],
                                ["DIN933",      function(x,y) DIN933_get_head_diameter(x,y)],
                                ["DIN912",      function(x,y) DIN912_get_head_diameter(x,y)],
                                ["DIN7380-1",   function(x,y) DIN73801_get_head_diameter(x,y)],
                                ["DIN7991",     function(x,y) DIN7991_get_head_diameter(x,y)]];

// return head deameter
// circumradius vs inradius
// - argument 'is_circumscribed' takes an effect only for the non-circular bolt heads
//   '-> by default, the the circum-diameter is used, as it is expected that the ddiameter
//       is used to drill a hole using cylinder + $fn=N combination
// - undef for an unknown standard or size
function get_bolt_head_diameter(descriptor, standard, is_circumscribed=true) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_bolt_diameter_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor, is_circumscribed);


// bolt functions
__dn_bolt_height_functions = [  ["DIN84A",      function(x) DIN84A_get_head_height(x)],
                                ["DIN933",      function(x) DIN933_get_head_height(x)],
                                ["DIN912",      function(x) DIN912_get_head_height(x)],
                                ["DIN7380-1",   function(x) DIN73801_get_head_height(x)],
                                ["DIN7991",     function(x) DIN7991_get_head_height(x)]];

// return head height
// - undef for an unknown standard or size
function get_bolt_head_height(descriptor, standard) =
    let(fnc = deez_nuts_find_in_dic(key=deez_nuts_standard(standard), dic=__dn_bolt_height_functions))
    is_undef(fnc) ?
        undef :
        fnc(descriptor);
