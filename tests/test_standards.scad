// Tests of the records of all standards and of the get_* functions; no geometry is produced.
// Run: openscad -o /tmp/out.echo tests/test_standards.scad
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

// the number of columns of each shape
_columns = [["socket", 4], ["button", 4], ["cheese", 4], ["hex", 2], ["countersunk", 4],
            ["countersunk-z", 2], ["hex-insert", 3], ["square", 2]];

// a valid dimension: a positive number, or [min, nominal, max] with 0 < min <= nominal <= max
function __t_dim_ok(v) =
    is_num(v) ? v > 0 :
    is_list(v) && len(v) == 3 && v[0] > 0 && v[0] <= v[1] && v[1] <= v[2];

// the problems of a row (an empty list when it is valid)
function __t_row_problems(r, row) =
    let(n = deez_nuts_find_in_dic(r[__DN_STD_SHAPE], _columns), d = row[0], c = row[1])
    [
        if (!is_num(d) || d <= 0) "d",
        if (len(c) != n) str("expected ", n, " columns"),
        // the head (the nut) and its height are required; extra columns may be undef (unknown)
        for (i = [0:1:len(c)-1]) if ((i < 2 || !is_undef(c[i])) && !__t_dim_ok(c[i])) str("column ", i),
        if (deez_nuts_dimension(c[0], DN_TOLERANCE_MIN) <= d) "the head (nut) is not wider than d",
        if (r[__DN_STD_SHAPE] == "hex-insert" && deez_nuts_dimension(c[2]) > deez_nuts_dimension(c[1], DN_TOLERANCE_MIN))
            "the metal part is higher than the nut",
    ];

// ------------------------------------------------------------------ records

_t_records = [
    for (r = DN_STANDARDS) each [
        check(str(r[__DN_STD_NAME], " record"), dn_is_standard(r), true),
        check(str(r[__DN_STD_NAME], " shape"), !is_undef(deez_nuts_find_in_dic(r[__DN_STD_SHAPE], _columns)), true),
        check(str(r[__DN_STD_NAME], " kind"), r[__DN_STD_KIND] == "bolt" || r[__DN_STD_KIND] == "nut" || r[__DN_STD_KIND] == "screw", true),
        check(str(r[__DN_STD_NAME], " length"), r[__DN_STD_LENGTH] == "shaft" || r[__DN_STD_LENGTH] == "total", true),
        check(str(r[__DN_STD_NAME], " source"), len(r[__DN_STD_SOURCE]) > 0, true),
        check(str(r[__DN_STD_NAME], " rows"), [for (row = r[__DN_STD_SIZES]) let(p = __t_row_problems(r, row)) if (len(p) > 0) [row[0], p]], []),
        check(str(r[__DN_STD_NAME], " sizes ascending"),
              let(k = deez_nuts_standard_sizes(r)) len([for (i = [1:1:len(k)-1]) if (k[i] <= k[i-1]) 1]), 0),
    ]
];

_t_kinds = [
    check("bolts", [for (r = DN_BOLTS) if (r[__DN_STD_KIND] != "bolt") r[__DN_STD_NAME]], []),
    check("nuts", [for (r = DN_NUTS) if (r[__DN_STD_KIND] != "nut") r[__DN_STD_NAME]], []),
    check("screws", [for (r = DN_SCREWS) if (r[__DN_STD_KIND] != "screw") r[__DN_STD_NAME]], []),
];

// M2 to M12 (M2.5 included) where the standard covers them
_t_coverage = [
    check("DIN912 sizes", deez_nuts_standard_sizes(DN_DIN912), [2, 2.5, 3, 4, 5, 6, 8, 10, 12]),
    check("ISO4017 sizes", deez_nuts_standard_sizes(DN_ISO4017), [2, 2.5, 3, 4, 5, 6, 8, 10, 12]),
    check("ISO4032 sizes", deez_nuts_standard_sizes(DN_ISO4032), [2, 2.5, 3, 4, 5, 6, 8, 10, 12]),
    check("DIN934 sizes", deez_nuts_standard_sizes(DN_DIN934), [2, 2.5, 3, 4, 5, 6, 8, 10, 12]),
];

// ------------------------------------------------------------------ get_* functions

_t_bolts = [
    for (r = concat(DN_BOLTS, DN_SCREWS)) for (row = r[__DN_STD_SIZES])
        let(desc = str("M", row[0], "x30"), w = deez_nuts_dimension(row[1][0]), k = deez_nuts_dimension(row[1][1]),
            bolt = r[__DN_STD_KIND] == "bolt") each [
        check(str(r[__DN_STD_NAME], " ", desc, " head diameter"),
              bolt ? get_bolt_head_diameter(desc, r[__DN_STD_NAME], false) : get_screw_head_diameter(desc, r[__DN_STD_NAME], false), w),
        check(str(r[__DN_STD_NAME], " ", desc, " head height"),
              bolt ? get_bolt_head_height(desc, r[__DN_STD_NAME]) : get_screw_head_height(desc, r[__DN_STD_NAME]), k),
        check(str(r[__DN_STD_NAME], " ", desc, " head circumscribed"),
              bolt ? get_bolt_head_diameter(desc, r[__DN_STD_NAME], true) : get_screw_head_diameter(desc, r[__DN_STD_NAME], true),
              r[__DN_STD_SHAPE] == "hex" ? w/cos(30) : w),
    ]
];

_t_nuts = [
    for (r = DN_NUTS) for (row = r[__DN_STD_SIZES])
        let(w = deez_nuts_dimension(row[1][0]), h = deez_nuts_dimension(row[1][1])) each [
        check(str(r[__DN_STD_NAME], " M", row[0], " width"), get_nut_diameter(row[0], r[__DN_STD_NAME], false), w),
        check(str(r[__DN_STD_NAME], " M", row[0], " height"), get_nut_height(row[0], r[__DN_STD_NAME]), h),
        check(str(r[__DN_STD_NAME], " M", row[0], " circumscribed"), get_nut_diameter(row[0], r[__DN_STD_NAME], true),
              w/cos(r[__DN_STD_SHAPE] == "square" ? 45 : 30)),
        check(str(r[__DN_STD_NAME], " M", row[0], " by descriptor"), get_nut_height(str("M", row[0]), r[__DN_STD_NAME]), h),
        check(str(r[__DN_STD_NAME], " M", row[0], " by bolt descriptor"), get_nut_height(str("M", row[0], "x10"), r[__DN_STD_NAME]), h),
    ]
];

// ------------------------------------------------------------------ DIN vs ISO, tolerances, aliases

_t_values = [
    check("DIN933 M10 across flats", get_bolt_head_diameter("M10x20", "DIN933", false), 17),
    check("ISO4017 M10 across flats", get_bolt_head_diameter("M10x20", "ISO4017", false), 16),
    check("DIN934 M8 height", get_nut_height(8, "DIN934"), 6.5),
    check("ISO4032 M8 height", get_nut_height(8, "ISO4032"), 6.8),
    check("DIN7991 M3 head", get_bolt_head_diameter("M3x10", "DIN7991"), 6),
    check("ISO10642 M3 head", get_bolt_head_diameter("M3x10", "ISO10642"), 6.72),
    check("min", let($dn_tolerance = DN_TOLERANCE_MIN) get_bolt_head_height("M3x10", "DIN912"), 2.86),
    check("max", let($dn_tolerance = DN_TOLERANCE_MAX) get_bolt_head_diameter("M3x10", "DIN912"), 5.68),
    check("ISO name of a bolt", get_bolt_head_height("M3x10", "ISO 4762"), get_bolt_head_height("M3x10", "DIN912")),
    check("unknown standard", get_bolt_head_height("M3x10", "DIN999"), undef),
    check("unknown size", get_bolt_head_height("M7x10", "DIN912"), undef),
    check("unknown nut size", get_nut_height(7, "DIN934"), undef),
    check("a nut standard is not a bolt", get_bolt_head_height("M3x10", "DIN934"), undef),
];

// ------------------------------------------------------------------ deprecated names

_t_deprecated = [
    check("DIN912_DIC", deez_nuts_find_in_dic(3, DIN912_DIC), [5.5, 3]),
    check("DIN933_DIC", deez_nuts_find_in_dic(3, DIN933_DIC), [5.5, 2]),
    check("DIN985_DIC", deez_nuts_find_in_dic(3, DIN985_DIC), [5.5, 4]),
    check("DIN934_get_height", DIN934_get_height(3), 2.4),
    check("DIN933_get_head_diameter", DIN933_get_head_diameter("M3x10", false), 5.5),
    check("LUXPZ_get_head_height", LUXPZ_get_head_height("M4x10"), 2.5),
];

echo("ALL TESTS PASSED");
