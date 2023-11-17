// include constants for align values
include<constants.scad>

// include all screws
include<screws/LUXPZ-screw.scad>


// parse avaliable screws
module screw(descriptor, standard, align=DN_BOTTOM)
{
    if (standard=="LUXPZ")
    {
        LUXPZ_screw(descriptor=descriptor, align=align);
    }
    else
    {
        assert(false, "[SCREW] standard: ", standard, " is not implemented!");
    }
}


// parse avaliable screws
module screw_hole(  descriptor, standard, align=DN_BOTTOM,
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
        assert(false, "[SCREW-HOLE] standard: ", standard, " is not implemented!");
    }
}
