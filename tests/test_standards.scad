// Tests of the tables of all standards and of the get_* functions; no geometry is produced.
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

// [standard, table, kind]
_bolt_tables = [["DIN84A", DIN84A_DIC], ["DIN933", DIN933_DIC], ["DIN912", DIN912_DIC],
                ["DIN7380-1", DIN73801_DIC], ["DIN7991", DIN7991_DIC]];
_screw_tables = [["LUXPZ", LUXPZ_DIC]];
_nut_tables = [["DIN439", DIN439_DIC], ["DIN562", DIN562_DIC], ["DIN934", DIN934_DIC], ["DIN985", DIN985_DIC]];

// a valid entry: [d, [width or diameter, height]] with the head (nut) wider than the shaft
function __t_entry_ok(e) =
    is_num(e[0]) && e[0] > 0 && is_list(e[1]) && len(e[1]) >= 2 &&
    is_num(e[1][0]) && is_num(e[1][1]) && e[1][0] > e[0] && e[1][1] > 0;

// the sizes are unique
function __t_unique(dic) = let(k = deez_nuts_dic_keys(dic))
    len([for (i = [0:1:len(k)-1]) for (j = [0:1:len(k)-1]) if (i < j && k[i] == k[j]) 1]) == 0;

// ------------------------------------------------------------------ tables

_t_tables = [
    for (t = concat(_bolt_tables, _screw_tables, _nut_tables)) each [
        check(str(t[0], " entries"), [for (e = t[1]) if (!__t_entry_ok(e)) e], []),
        check(str(t[0], " unique sizes"), __t_unique(t[1]), true),
    ]
];

// ------------------------------------------------------------------ get_* functions

_t_bolts = [
    for (t = _bolt_tables) for (e = t[1]) let(desc = str("M", e[0], "x10"), w = e[1][0]) each [
        check(str(t[0], " ", desc, " head diameter"), get_bolt_head_diameter(desc, t[0], false), w),
        check(str(t[0], " ", desc, " head height"), get_bolt_head_height(desc, t[0]), e[1][1]),
        check(str(t[0], " ", desc, " head circumscribed"), get_bolt_head_diameter(desc, t[0], true),
              t[0] == "DIN933" ? w/cos(30) : w),
    ]
];

_t_screws = [
    for (t = _screw_tables) for (e = t[1]) let(desc = str("M", e[0], "x10")) each [
        check(str(t[0], " ", desc, " head diameter"), get_screw_head_diameter(desc, t[0]), e[1][0]),
        check(str(t[0], " ", desc, " head height"), get_screw_head_height(desc, t[0]), e[1][1]),
    ]
];

_t_nuts = [
    for (t = _nut_tables) for (e = t[1]) let(w = e[1][0]) each [
        check(str(t[0], " M", e[0], " width"), get_nut_diameter(e[0], t[0], false), w),
        check(str(t[0], " M", e[0], " height"), get_nut_height(e[0], t[0]), e[1][1]),
        check(str(t[0], " M", e[0], " circumscribed"), get_nut_diameter(e[0], t[0], true),
              w/cos(t[0] == "DIN562" ? 45 : 30)),
        check(str(t[0], " M", e[0], " by descriptor"), get_nut_height(str("M", e[0]), t[0]), e[1][1]),
        check(str(t[0], " M", e[0], " by bolt descriptor"), get_nut_height(str("M", e[0], "x10"), t[0]), e[1][1]),
    ]
];

// ------------------------------------------------------------------ aliases and unknowns

_t_aliases = [
    check("ISO name of a bolt", get_bolt_head_height("M3x10", "ISO 4762"), get_bolt_head_height("M3x10", "DIN912")),
    check("ISO name of a nut", get_nut_height(3, "iso4032"), get_nut_height(3, "DIN934")),
    check("unknown standard", get_bolt_head_height("M3x10", "DIN999"), undef),
    check("unknown size", get_bolt_head_height("M7x10", "DIN912"), undef),
    check("unknown nut size", get_nut_height(7, "DIN934"), undef),
];

echo("ALL TESTS PASSED");
