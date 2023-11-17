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


