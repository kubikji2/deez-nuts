// nuts: the list of the implemented standards and the modules and functions for all of them
// NOTE: included by deez-nuts.scad (after the records in nuts/)

// the records of the implemented nut standards
DN_NUTS = [DN_DIN934, DN_ISO4032, DN_DIN439, DN_ISO4035, DN_DIN985, DN_ISO10511, DN_DIN562];

// the canonical names of the implemented nut standards
DN_NUT_STANDARDS = [for (r = DN_NUTS) r[__DN_STD_NAME]];


// a nut
// '-> argument 'd' the size: a number (3) or a descriptor ("M3", or the bolt "M3x10")
// '-> argument 'standard' e.g. "DIN934" or "ISO 4032" (case, spaces and dashes are ignored)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'visual' adds the hole (and the insert of a nut with an insert)
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
// '-> the dimensions follow $dn_tolerance (DN_TOLERANCE_NOMINAL by default)
module nut(d, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
    deez_nuts_nut(__dn_standard_record(standard, DN_NUTS, "NUT"), d,
                  align=align, visual=visual, zet=zet, ctx="NUT");


// a nut hole
// '-> arguments as for nut(), and:
// '-> argument 's_off' a side slot towards +x, to insert the nut from the side
// '-> argument 'h_off' an access hole below the nut
// '-> argument 'clearance' added on every side, across the flats (default 0.1)
// '-> argument 'h_clearance' the clearance along the axis (default 'clearance')
// '-> argument 'teardrop' false (default), true or the face letter of the up direction of the
//     printing (across the axis): a corner of the hexagon points up (square nuts: no effect)
// '-> the dimensions are the maxima of the standard (DN_TOLERANCE_MAX) unless $dn_tolerance is set
module nut_hole(d, standard, align=DN_ALIGN_BOTTOM, s_off=0,
                h_off=0, clearance=0.1, h_clearance=undef, zet=undef, teardrop=false)
    deez_nuts_nut_hole(__dn_standard_record(standard, DN_NUTS, "NUT-HOLE"), d,
                       align=align, s_off=s_off, h_off=h_off, clearance=clearance,
                       h_clearance=h_clearance, zet=zet, teardrop=teardrop, ctx="NUT-HOLE");


// return nut diameter (undef for an unknown standard or size)
// - argument 'd' a number (3) or a descriptor ("M3", "M3x10")
function get_nut_diameter(d, standard, is_circumscribed=true) =
    let(r = deez_nuts_find_standard(standard, DN_NUTS))
    is_undef(r) ? undef : deez_nuts_nut_width(r, d, is_circumscribed);


// return nut height (undef for an unknown standard or size); the total height of a nut with an insert
function get_nut_height(d, standard) =
    let(r = deez_nuts_find_standard(standard, DN_NUTS))
    is_undef(r) ? undef : deez_nuts_nut_height(r, d);
