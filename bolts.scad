include<constants.scad>

include<bolts/DIN84A-bolt.scad>
include<bolts/DIN933-bolt.scad>

// parse avaliable bolts
module bolt(descriptor, standard, align=DN_BOTTOM)
{
    if (standard=="DIN84A")
    {
        DIN84A_bolt(descriptor=descriptor, align=align);
    }
    else if(standard=="DIN933")
    {
        DIN933_bolt(descriptor=descriptor, align=align);
    }
    else
    {
        assert(false, "[BOLT] standard: ", standard, " is not implemented!");
    }
}
