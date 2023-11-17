// include constants for align values
include<constants.scad>

// include avaliable nuts
include<nuts/DIN439-nut.scad>
include<nuts/DIN562-nut.scad>
include<nuts/DIN934-nut.scad>
include<nuts/DIN985-nut.scad>


// parse avaliable nuts
module nut(d, standard, align=DN_BOTTOM)
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
        assert(false, "[NUT] standard: ", standard, " is not implemented!");
    }
}
