// Gallery: every nut standard in every size (rows: standards, columns: sizes).
// Render (F6) to check that every part is a valid manifold; the last row shows align and zet.

include<../deez-nuts.scad>
$fa = 6; $fs = 0.3;

_rows = [["DIN439", DIN439_DIC], ["DIN562", DIN562_DIC], ["DIN934", DIN934_DIC], ["DIN985", DIN985_DIC]];

for (i = [0:len(_rows)-1])
    for (j = [0:len(_rows[i][1])-1])
        translate([j*20, i*20, 0])
            nut(_rows[i][1][j][0], _rows[i][0], visual=true);

// align, zet and descriptors
translate([0, -20, 0])
{
    nut("M3", "DIN934", align=DN_ALIGN_BOTTOM);
    translate([10, 0, 0]) nut("M3", "DIN934", align=DN_ALIGN_MIDDLE);
    translate([20, 0, 0]) nut("M3x10", "DIN934", align=DN_ALIGN_TOP);
    translate([35, 0, 0]) nut("M3", "ISO 4032", zet="x");
    translate([50, 0, 0]) nut("M3", "DIN562", zet="y", visual=true);
}
