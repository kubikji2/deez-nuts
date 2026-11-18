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
    check("DIN 84 A",           deez_nuts_standard("DIN 84 A"),     "DIN84A"),
    check("ISO10642",           deez_nuts_standard("ISO10642"),     "DIN7991"),
    check("ISO4017",            deez_nuts_standard("ISO4017"),      "DIN933"),
    check("ISO4032",            deez_nuts_standard("ISO4032"),      "DIN934"),
    check("ISO10511",           deez_nuts_standard("ISO10511"),     "DIN985"),
    check("ISO4035",            deez_nuts_standard("ISO4035"),      "DIN439"),
    check("unknown",            deez_nuts_standard("DIN999"),       undef),
    check("not a string",       deez_nuts_standard(912),            undef),
    check("every bolt standard is canonical",
          [for (s = DN_BOLT_STANDARDS) deez_nuts_standard(s)], DN_BOLT_STANDARDS),
    check("every nut standard is canonical",
          [for (s = DN_NUT_STANDARDS) deez_nuts_standard(s)], DN_NUT_STANDARDS),
    check("every screw standard is canonical",
          [for (s = DN_SCREW_STANDARDS) deez_nuts_standard(s)], DN_SCREW_STANDARDS),
    check("aliases constants", [deez_nuts_standard(DN_BOLT_HEX), deez_nuts_standard(DN_SCREW_PHILLIP),
                                deez_nuts_standard(DN_BOLT_BUTTON_HEAD)], ["DIN912", "LUXPZ", "DIN7380-1"]),
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
