// Gallery: bolt, screw and nut holes cut into blocks, cut in half to show the inside.
// Render (F6) to check that every combination gives a valid manifold.

include<../deez-nuts.scad>
$fa = 6; $fs = 0.3;

// a block with the hole, the front half removed
module show(size=[14, 14, 24])
    difference()
    {
        cubepp(size, align="z");
        children();
        cubepp([size[0] + 2, size[1], size[2] + 2], align="Y", center=false);
    }

// bolt holes: top of the head flush with the top of the block
_bolts = ["DIN84A", "DIN933", "DIN912", "DIN7380-1", "DIN7991"];
for (i = [0:len(_bolts)-1])
    translate([i*20, 0, 0])
        show() translate([0, 0, 24]) bolt_hole("M3x16", _bolts[i], align=DN_ALIGN_TOP, sh_off=10, hh_off=2);
translate([len(_bolts)*20, 0, 0])
    show() translate([0, 0, 24]) screw_hole("M3x16", "LUXPZ", align=DN_ALIGN_TOP, sh_off=10, hh_off=2);

// nut holes: plain, with a side slot, with a vertical access hole, a square nut
translate([0, 30, 0])
{
    show([14, 14, 10]) translate([0, 0, 4]) nut_hole("M3", "DIN934");
    translate([20, 0, 0]) show([14, 14, 10]) translate([0, 0, 4]) nut_hole("M3", "DIN934", s_off=10);
    translate([40, 0, 0]) show([14, 14, 10]) translate([0, 0, 4]) nut_hole("M3", "DIN934", h_off=4);
    translate([60, 0, 0]) show([14, 14, 10]) translate([0, 0, 4]) nut_hole("M3", "DIN562", s_off=10);
}

// horizontal holes (zet)
translate([0, 60, 0])
{
    show([30, 14, 14]) translate([-15, 0, 7]) bolt_hole("M3x20", "DIN912", zet="x", hh_off=5);
    translate([40, 0, 0]) show([14, 14, 14]) translate([0, 0, 7]) nut_hole("M3", "DIN934", zet="x", s_off=10);
}
