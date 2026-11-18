// Gallery: every bolt and screw standard in every size (rows: standards, columns: sizes).
// Render (F6) to check that every part is a valid manifold; the last row shows align and zet.

include<../deez-nuts.scad>
$fa = 6; $fs = 0.3;

_rows = concat(DN_BOLTS, DN_SCREWS);

for (i = [0:len(_rows)-1])
    let(r = _rows[i], sizes = deez_nuts_standard_sizes(r))
        for (j = [0:len(sizes)-1])
            let(d = sizes[j], desc = str("M", d, "x", 3*d))
                translate([j*30, i*30, 0])
                    if (r[__DN_STD_KIND] == "bolt")
                        bolt(desc, r[__DN_STD_NAME], visual=true);
                    else
                        screw(desc, r[__DN_STD_NAME], visual=true);

// align, zet and the tolerance
translate([0, -30, 0])
{
    bolt("M3x12", "DIN912", align=DN_ALIGN_BOTTOM);
    translate([12, 0, 0]) bolt("M3x12", "DIN912", align=DN_ALIGN_MIDDLE);
    translate([24, 0, 0]) bolt("M3x12", "DIN912", align=DN_ALIGN_TOP);
    translate([40, 0, 0]) bolt("M3x12", "ISO 4762", zet="x");
    translate([70, 0, 0]) bolt("M3x12", "ISO 4762", zet="y", visual=true);
    translate([90, 0, 0]) bolt("M3x12", "DIN912", $dn_tolerance=DN_TOLERANCE_MIN);
    translate([100, 0, 0]) bolt("M3x12", "DIN912", $dn_tolerance=DN_TOLERANCE_MAX);
}
