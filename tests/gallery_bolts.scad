// Gallery: every bolt and screw standard in every size (rows: standards, columns: sizes).
// Render (F6) to check that every part is a valid manifold; the last row shows align and zet.

include<../deez-nuts.scad>
$fa = 6; $fs = 0.3;

_rows = [["DIN84A", DIN84A_DIC, "bolt"], ["DIN933", DIN933_DIC, "bolt"], ["DIN912", DIN912_DIC, "bolt"],
         ["DIN7380-1", DIN73801_DIC, "bolt"], ["DIN7991", DIN7991_DIC, "bolt"], ["LUXPZ", LUXPZ_DIC, "screw"]];

for (i = [0:len(_rows)-1])
    for (j = [0:len(_rows[i][1])-1])
        let(d = _rows[i][1][j][0], desc = str("M", d, "x", 4*d))
            translate([j*25, i*25, 0])
                if (_rows[i][2] == "bolt")
                    bolt(desc, _rows[i][0], visual=true);
                else
                    screw(desc, _rows[i][0], visual=true);

// align and zet
translate([0, -30, 0])
{
    bolt("M3x12", "DIN912", align=DN_ALIGN_BOTTOM);
    translate([12, 0, 0]) bolt("M3x12", "DIN912", align=DN_ALIGN_MIDDLE);
    translate([24, 0, 0]) bolt("M3x12", "DIN912", align=DN_ALIGN_TOP);
    translate([40, 0, 0]) bolt("M3x12", "ISO 4762", zet="x");
    translate([70, 0, 0]) bolt("M3x12", "ISO 4762", zet="y", visual=true);
}
