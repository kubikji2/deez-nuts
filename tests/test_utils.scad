// Tests of the deez-nuts utilities (descriptors, standards, tables); no geometry is produced.
// Run: openscad -o /tmp/out.echo tests/test_utils.scad
// A failed test stops with an assert naming the test; the last echo is "ALL TESTS PASSED".

include<../deez-nuts.scad>

function __t_eq(a, b, eps=1e-6) =
    is_num(a) && is_num(b) ?
        abs(a - b) <= eps :
        is_list(a) && is_list(b) ?
            len(a) == len(b) && len([for (i = [0:1:len(a)-1]) if (!__t_eq(a[i], b[i], eps)) 1]) == 0 :
            a == b;

function check(name, got, expected, eps=1e-6) =
    assert(__t_eq(got, expected, eps), str("TEST FAILED: ", name, "\n  got:      ", got, "\n  expected: ", expected))
    true;

// ------------------------------------------------------------------ descriptors

_t_descriptors = [
    check("M3x20",              deez_nuts_parse_descriptor("M3x20"),    [3, 20, true]),
    check("M2.5x10",            deez_nuts_parse_descriptor("M2.5x10"),  [2.5, 10, true]),
    check("M12x100",            deez_nuts_parse_descriptor("M12x100"),  [12, 100, true]),
    check("M3x12.5",            deez_nuts_parse_descriptor("M3x12.5"),  [3, 12.5, true]),
    check("lower case m3x20",   deez_nuts_parse_descriptor("m3x20"),    [3, 20, true]),
    check("upper case M3X20",   deez_nuts_parse_descriptor("M3X20"),    [3, 20, true]),
    check("M3 without length",  deez_nuts_parse_descriptor("M3"),       [3, undef, true]),
    check("M2.5 without length", deez_nuts_parse_descriptor("M2.5"),    [2.5, undef, true]),
    check("with length",        deez_nuts_parse_descriptor_with_length("M4x8"), [4, 8, true]),
    check("float",              [float("3"), float("2.5"), float("12"), float("0.75")], [3, 2.5, 12, 0.75]),
    check("number strings",     [__dn_is_number_string("2.5"), __dn_is_number_string("2.5.1"),
                                 __dn_is_number_string("a"), __dn_is_number_string("."),
                                 __dn_is_number_string("")], [true, false, false, false, false]),
];

// ------------------------------------------------------------------ nut sizes

_t_nut_sizes = [
    check("nut number",         deez_nuts_nut_diameter(3),          3),
    check("nut M3",             deez_nuts_nut_diameter("M3"),       3),
    check("nut of a bolt",      deez_nuts_nut_diameter("M2.5x10"),  2.5),
];

// ------------------------------------------------------------------ standards and aliases

_t_standards = [
    check("canonical",          deez_nuts_standard("DIN912"),       "DIN912"),
    check("ISO alias",          deez_nuts_standard("ISO4762"),      "DIN912"),
    check("spaces",             deez_nuts_standard("ISO 4762"),     "DIN912"),
    check("lower case",         deez_nuts_standard("iso 4762"),     "DIN912"),
    check("dash",               deez_nuts_standard("DIN-912"),      "DIN912"),
    check("DIN7380-1",          deez_nuts_standard("DIN7380-1"),    "DIN7380-1"),
    check("DIN73801",           deez_nuts_standard("DIN73801"),     "DIN7380-1"),
    check("ISO 7380-1",         deez_nuts_standard("ISO 7380-1"),   "DIN7380-1"),
    check("ISO 7380-2",         deez_nuts_standard("ISO 7380-2"),   "ISO7380-2"),
    check("DIN 7380-2",         deez_nuts_standard("DIN 7380-2"),   "ISO7380-2"),
    check("DIN EN ISO 7380-2",  deez_nuts_standard("DIN EN ISO 7380-2"), "ISO7380-2"),
    check("DIN 84 A",           deez_nuts_standard("DIN 84 A"),     "DIN84A"),
    check("DIN 84",             deez_nuts_standard("DIN 84"),       "DIN84A"),
    check("ISO 1207 own table", deez_nuts_standard("ISO 1207"),     "ISO1207"),
    check("ISO 10642 own table", deez_nuts_standard("ISO10642"),    "ISO10642"),
    check("ISO 4017 own table", deez_nuts_standard("ISO4017"),      "ISO4017"),
    check("ISO 4032 own table", deez_nuts_standard("ISO4032"),      "ISO4032"),
    check("ISO 10511 own table", deez_nuts_standard("ISO10511"),    "ISO10511"),
    check("ISO 4035 own table", deez_nuts_standard("ISO4035"),      "ISO4035"),
    check("DIN 439 B",          deez_nuts_standard("DIN439B"),      "DIN439"),
    check("deprecated LUXPZ",   deez_nuts_standard("LUXPZ"),        "DIN7505"),
    check("unknown",            deez_nuts_standard("DIN999"),       undef),
    check("not a string",       deez_nuts_standard(912),            undef),
    check("every bolt standard is canonical",
          [for (s = DN_BOLT_STANDARDS) deez_nuts_standard(s)], DN_BOLT_STANDARDS),
    check("every nut standard is canonical",
          [for (s = DN_NUT_STANDARDS) deez_nuts_standard(s)], DN_NUT_STANDARDS),
    check("every screw standard is canonical",
          [for (s = DN_SCREW_STANDARDS) deez_nuts_standard(s)], DN_SCREW_STANDARDS),
    check("names and aliases are unique",
          let(n = [for (r = DN_STANDARDS) each concat([r[__DN_STD_NAME]], r[__DN_STD_ALIASES], r[__DN_STD_DEPRECATED])],
              k = [for (x = n) deez_nuts_normalize_name(x)])
          len([for (i = [0:1:len(k)-1]) for (j = [0:1:len(k)-1]) if (i < j && k[i] == k[j]) 1]), 0),
    check("aliases constants", [deez_nuts_standard(DN_BOLT_HEX), deez_nuts_standard(DN_SCREW_PHILLIP),
                                deez_nuts_standard(DN_BOLT_BUTTON_HEAD)], ["DIN912", "DIN7505", "DIN7380-1"]),
];

// ------------------------------------------------------------------ tolerances and teardrops

_t_tolerances = [
    check("number",             deez_nuts_dimension(5),                                5),
    check("nominal default",    deez_nuts_dimension([4, 5, 6]),                        5),
    check("min",                deez_nuts_dimension([4, 5, 6], DN_TOLERANCE_MIN),      4),
    check("max",                deez_nuts_dimension([4, 5, 6], DN_TOLERANCE_MAX),      6),
    check("$dn_tolerance",      let($dn_tolerance = "max") deez_nuts_dimension([4, 5, 6]), 6),
    check("dims with $dn_tolerance", let($dn_tolerance = "min") deez_nuts_standard_dims(DN_DIN912, 3)[0], 5.32),
    check("dims nominal",       deez_nuts_standard_dims(DN_DIN912, 3), [5.5, 3, 2.5, 1.3]),
    check("dims unknown size",  deez_nuts_standard_dims(DN_DIN912, 7), undef),
    check("holes default to max", deez_nuts_hole_tolerance(), DN_TOLERANCE_MAX),
    check("holes follow $dn_tolerance", let($dn_tolerance = DN_TOLERANCE_NOMINAL) deez_nuts_hole_tolerance(),
          DN_TOLERANCE_NOMINAL),
    check("hole dims", __dn_standard_dims(DN_DIN912, 3, "T", tolerance=deez_nuts_hole_tolerance()), [5.68, 3, 2.5, 1.3]),
];

_t_teardrops = [
    check("none",               [deez_nuts_teardrop_up(false, "x"), deez_nuts_teardrop_up(undef, "x")], [undef, undef]),
    // zet="x": the local x is the parent -z, the local y is the parent y
    check("zet x, true",        deez_nuts_teardrop_up(true, "x"),  "x"),
    check("zet x, Z",           deez_nuts_teardrop_up("Z", "x"),   "x"),
    check("zet x, z",           deez_nuts_teardrop_up("z", "x"),   "X"),
    check("zet x, Y",           deez_nuts_teardrop_up("Y", "x"),   "Y"),
    // zet="y": the local y is the parent -z, the local x is the parent x
    check("zet y, true",        deez_nuts_teardrop_up(true, "y"),  "y"),
    check("zet y, X",           deez_nuts_teardrop_up("X", "y"),   "X"),
    // zet="z": a vertical hole printed lying
    check("zet z, Y",           deez_nuts_teardrop_up("Y", "z"),   "Y"),
    check("zet undef, x",       deez_nuts_teardrop_up("x", undef), "x"),
];

// ------------------------------------------------------------------ tables, polygons, align

_t_misc = [
    check("find",               deez_nuts_find_in_dic(3, [[2, "a"], [3, "b"]]), "b"),
    check("find missing",       deez_nuts_find_in_dic(4, [[2, "a"], [3, "b"]]), undef),
    check("keys",               deez_nuts_dic_keys([[2, "a"], [3, "b"]]), [2, 3]),
    check("hexagon",            deez_nutz_polygon_width_to_circumscribed_diameter(10, 6), 20/sqrt(3)),
    check("square",             deez_nutz_polygon_width_to_circumscribed_diameter(10, 4), 10*sqrt(2)),
    check("inscribed",          deez_nutz_polygon_width_to_inscribed_diameter(10, 6), 10),
    check("align bottom",       deez_nuts_align_to_transform(10, 2, DN_ALIGN_BOTTOM), [0, 0, 0]),
    check("align middle",       deez_nuts_align_to_transform(10, 2, DN_ALIGN_MIDDLE), [0, 0, -10]),
    check("align top",          deez_nuts_align_to_transform(10, 2, DN_ALIGN_TOP),    [0, 0, -12]),
    check("zet",                [deez_nuts_zet_rotation(undef), deez_nuts_zet_rotation("z"),
                                 deez_nuts_zet_rotation("x"), deez_nuts_zet_rotation("y")],
                                [[0, 0, 0], [0, 0, 0], [0, 90, 0], [-90, 0, 0]]),
    check("upper",              deez_nuts_upper("iso 4762-a"), "ISO 4762-A"),
    check("strip",              __dn_strip("ISO 7380-1", " -"), "ISO73801"),
];

echo("ALL TESTS PASSED");
