// include constants for align values
include<constants.scad>

// include avaliable nuts
include<nuts/DIN439-nut.scad>
include<nuts/DIN562-nut.scad>
include<nuts/DIN934-nut.scad>
include<nuts/DIN985-nut.scad>


// parse avaliable nuts
module nut(d, standard, align=DN_ALIGN_BOTTOM)
{
    if (standard=="DIN439")
    {
        DIN439_nut(d=d, align=align);
    }
    else if (standard=="DIN562")
    {
        DIN562_nut(d=d, align=align);
    }
    else if (standard=="DIN934")
    {
        DIN934_nut(d=d, align=align);
    }
    else if (standard=="DIN985")
    {
        DIN985_nut(d=d, align=align);
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
