// bolts: the list of the implemented standards and the modules and functions for all of them
// NOTE: included by deez-nuts.scad (after the records in bolts/)

// the records of the implemented bolt standards
DN_BOLTS = [DN_DIN84A, DN_ISO1207, DN_DIN933, DN_ISO4017, DN_DIN912, DN_DIN7380_1, DN_ISO7380_2,
            DN_DIN7991, DN_ISO10642];

// the canonical names of the implemented bolt standards
DN_BOLT_STANDARDS = [for (r = DN_BOLTS) r[__DN_STD_NAME]];


// a bolt
// '-> argument 'descriptor' e.g. "M3x20" (the length as the standard measures it, see the README)
// '-> argument 'standard' e.g. "DIN912" or "ISO 4762" (case, spaces and dashes are ignored)
// '-> argument 'align' DN_ALIGN_BOTTOM (the end of the shaft at z = 0, default), DN_ALIGN_MIDDLE
//     (the bottom of the head) or DN_ALIGN_TOP (the top of the head)
// '-> argument 'visual' adds details for pictures (the socket, the slot)
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp); the head points towards +zet
// '-> the dimensions follow $dn_tolerance (DN_TOLERANCE_NOMINAL by default)
module bolt(descriptor, standard, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
    deez_nuts_fastener(__dn_standard_record(standard, DN_BOLTS, "BOLT"), descriptor,
                       align=align, visual=visual, zet=zet, ctx="BOLT");


// a hole for a bolt
// '-> arguments as for bolt(), and:
// '-> argument 'sh_off' extends the hole of the shaft beyond its end
// '-> argument 'hh_off' extends the hole of the head above it (to sink the head)
// '-> argument 'clearance' added on every side (default 0.1)
// '-> argument 'teardrop' false (default), true or the face letter the tip points to (the up
//     direction of the printing, across the hole): the round parts get a teardrop cross-section
// '-> the dimensions are the maxima of the standard (DN_TOLERANCE_MAX) unless $dn_tolerance is set
module bolt_hole(   descriptor, standard, align=DN_ALIGN_BOTTOM,
                    sh_off=0, hh_off=0,
                    clearance=0.1, eps=DN_EPS, zet=undef, teardrop=false)
    deez_nuts_fastener_hole(__dn_standard_record(standard, DN_BOLTS, "BOLT-HOLE"), descriptor,
                            align=align, sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps,
                            zet=zet, teardrop=teardrop, ctx="BOLT-HOLE");


// return head diameter (undef for an unknown standard or size)
// - argument 'is_circumscribed' takes an effect only for the non-circular bolt heads
//   '-> by default, the the circum-diameter is used, as it is expected that the ddiameter
//       is used to drill a hole using cylinder + $fn=N combination
function get_bolt_head_diameter(descriptor, standard, is_circumscribed=true) =
    let(r = deez_nuts_find_standard(standard, DN_BOLTS))
    is_undef(r) ? undef : deez_nuts_fastener_head_diameter(r, descriptor, is_circumscribed);


// return head height (undef for an unknown standard or size)
function get_bolt_head_height(descriptor, standard) =
    let(r = deez_nuts_find_standard(standard, DN_BOLTS))
    is_undef(r) ? undef : deez_nuts_fastener_head_height(r, descriptor);
