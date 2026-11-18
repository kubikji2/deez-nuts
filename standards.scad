// The records of the standards: every standard file defines one record with dn_standard(), and
// bolts.scad, nuts.scad and screws.scad list them. The generic modules (bolt(), nut(), ...) read
// the shape and the dimensions from the record.


// a standard record
// '-> 'name' the canonical name, e.g. "DIN912"
// '-> 'kind' "bolt", "nut" or "screw"
// '-> 'shape' the shape of the head (or the nut), defines the columns of 'sizes':
//     bolts and screws:
//       "socket"        cylindrical head with a hexagon socket   [dk, k, s, t]
//       "button"        button head with a hexagon socket        [dk, k, s, t]
//       "cheese"        cylindrical head with a slot             [dk, k, n, t]
//       "hex"           hexagon head                             [s, k]
//       "countersunk"   countersunk head (90 deg) with a socket  [dk, k, s, t]
//       "countersunk-z" countersunk head with a cross recess     [dk, k]
//     nuts:
//       "hex"           hexagon nut                              [s, m]
//       "hex-insert"    hexagon nut with a non-metallic insert   [s, h, m]
//       "square"        square nut                               [s, m]
//     where dk is the head diameter, s the width across the flats (of the head, the nut or the
//     socket), k the head height, m the height of the nut (of its metal part for "hex-insert"),
//     h the total height, t the depth of the socket or the slot, n the width of the slot
// '-> 'length' what the length of the descriptor measures: "shaft" (under the head) or "total"
// '-> 'aliases' other names (the ISO name, other spellings)
// '-> 'deprecated' old names that still work but echo a DEPRECATED message
// '-> 'sizes' the rows [d, [columns]]; a column is a number (a single value of the standard) or
//     a range [min, nominal, max] selected by $dn_tolerance
// '-> 'source' where the values come from
function dn_standard(name, kind, shape, length="shaft", aliases=[], deprecated=[], sizes=[], source=[]) =
    ["__DN_STANDARD__", name, kind, shape, length, aliases, deprecated, sizes, source];

// the fields of a record
__DN_STD_NAME = 1;
__DN_STD_KIND = 2;
__DN_STD_SHAPE = 3;
__DN_STD_LENGTH = 4;
__DN_STD_ALIASES = 5;
__DN_STD_DEPRECATED = 6;
__DN_STD_SIZES = 7;
__DN_STD_SOURCE = 8;

function dn_is_standard(r) = is_list(r) && len(r) == 9 && r[0] == "__DN_STANDARD__";

// the normalized form of a name: upper case, without spaces, dashes, dots and underscores
function deez_nuts_normalize_name(s) = __dn_strip(deez_nuts_upper(s), " -._");

// __private__ does the record answer to the (normalized) name; 0: no, 1: yes, 2: a deprecated name
function __dn_std_match(r, n) =
    deez_nuts_normalize_name(r[__DN_STD_NAME]) == n ||
    len([for (a = r[__DN_STD_ALIASES]) if (deez_nuts_normalize_name(a) == n) a]) > 0 ? 1 :
    len([for (a = r[__DN_STD_DEPRECATED]) if (deez_nuts_normalize_name(a) == n) a]) > 0 ? 2 : 0;

// the record of a standard from a list of records (undef if none)
function deez_nuts_find_standard(standard, records) =
    !is_string(standard) ? undef :
    let(n = deez_nuts_normalize_name(standard),
        found = [for (r = records) let(m = __dn_std_match(r, n)) if (m > 0) [r, m]])
    len(found) == 0 ? undef :
    found[0][1] == 2 ?
        echo(str("[DEEZ-NUTS] DEPRECATED: standard \"", standard, "\" -> use \"", found[0][0][__DN_STD_NAME], "\""))
        found[0][0] :
        found[0][0];

// the record of a standard, or an error listing the implemented ones
function __dn_standard_record(standard, records, ctx) =
    let(r = deez_nuts_find_standard(standard, records))
    assert(!is_undef(r),
        str("[", ctx, "] standard: ", standard, " is not implemented! Available: ",
            [for (s = records) s[__DN_STD_NAME]], " (and their ISO names)"))
    r;

// the sizes (nominal diameters) of a standard
function deez_nuts_standard_sizes(record) = [for (e = record[__DN_STD_SIZES]) e[0]];

// the dimensions of a size with $dn_tolerance applied, or an error listing the sizes
function __dn_standard_dims(record, d, ctx, descriptor=undef) =
    let(row = deez_nuts_find_in_dic(key=d, dic=record[__DN_STD_SIZES]))
    assert(!is_undef(row),
        str("[DEEZ-NUTS:", ctx, "] ", record[__DN_STD_NAME], ": undefined entry for d=", d,
            is_undef(descriptor) ? "" : str(" from descriptor \"", descriptor, "\""),
            ", available: ", deez_nuts_standard_sizes(record)))
    [for (v = row) deez_nuts_dimension(v)];

// the dimensions of a size (undef for an unknown size)
function deez_nuts_standard_dims(record, d) =
    let(row = deez_nuts_find_in_dic(key=d, dic=record[__DN_STD_SIZES]))
    is_undef(row) ? undef : [for (v = row) deez_nuts_dimension(v)];

// the canonical name of a standard of any kind (undef if unknown)
function deez_nuts_standard(standard) =
    let(r = deez_nuts_find_standard(standard, DN_STANDARDS))
    is_undef(r) ? undef : r[__DN_STD_NAME];
