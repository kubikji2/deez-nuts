// screws: the list of the implemented standards and the modules and functions for all of them
// NOTE: included by deez-nuts.scad (after the records in screws/)

// the records of the implemented screw standards
DN_SCREWS = [DN_DIN7505];

// the canonical names of the implemented screw standards
DN_SCREW_STANDARDS = [for (r = DN_SCREWS) r[__DN_STD_NAME]];


// a screw
// '-> arguments as for bolt(); e.g. screw("M4x30", "DIN7505") (the total length)
module screw(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
    deez_nuts_fastener(__dn_standard_record(standard, DN_SCREWS, "SCREW"), descriptor,
                       align=align, visual=visual, zet=zet, ctx="SCREW");


// a hole for a screw
// '-> arguments as for bolt_hole(); the dimensions are the maxima unless $dn_tolerance is set
module screw_hole(  descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS, zet=undef, teardrop=false)
    deez_nuts_fastener_hole(__dn_standard_record(standard, DN_SCREWS, "SCREW-HOLE"), descriptor,
                            align=align, sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps,
                            zet=zet, teardrop=teardrop, ctx="SCREW-HOLE");


// return head diameter (undef for an unknown standard or size)
function get_screw_head_diameter(descriptor, standard, is_circumscribed=false) =
    let(r = deez_nuts_find_standard(standard, DN_SCREWS))
    is_undef(r) ? undef : deez_nuts_fastener_head_diameter(r, descriptor, is_circumscribed);


// return head height (undef for an unknown standard or size)
function get_screw_head_height(descriptor, standard) =
    let(r = deez_nuts_find_standard(standard, DN_SCREWS))
    is_undef(r) ? undef : deez_nuts_fastener_head_height(r, descriptor);
