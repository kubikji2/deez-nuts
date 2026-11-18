// Gallery: every nut standard in every size (rows: standards, columns: sizes).
// Render (F6) to check that every part is a valid manifold; the last row shows align and zet.

include<../deez-nuts.scad>
$fa = 6; $fs = 0.3;

for (i = [0:len(DN_NUTS)-1])
    let(r = DN_NUTS[i], sizes = deez_nuts_standard_sizes(r))
        for (j = [0:len(sizes)-1])
            translate([j*25, i*25, 0])
                nut(sizes[j], r[__DN_STD_NAME], visual=true);

// align, zet and descriptors
translate([0, -25, 0])
{
    nut("M3", "DIN934", align=DN_ALIGN_BOTTOM);
    translate([10, 0, 0]) nut("M3", "DIN934", align=DN_ALIGN_MIDDLE);
    translate([20, 0, 0]) nut("M3x10", "DIN934", align=DN_ALIGN_TOP);
    translate([35, 0, 0]) nut("M3", "ISO 4032", zet="x");
    translate([50, 0, 0]) nut("M3", "DIN562", zet="y", visual=true);
    translate([65, 0, 0]) nut("M3", "DIN985", zet="x", visual=true);
}
