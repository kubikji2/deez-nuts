

// return the translation for the particular align (the bolt is built from z = 0 upwards:
// the shaft from 0 to 'sh', the head from 'sh' to 'sh + hh')
// '-> DN_ALIGN_BOTTOM: the bottom of the shaft at z = 0
// '-> DN_ALIGN_MIDDLE: the bottom of the head (the top of the shaft) at z = 0
// '-> DN_ALIGN_TOP: the top of the head at z = 0
function deez_nuts_align_to_transform(sh, hh, align) =
    assert(align == DN_ALIGN_BOTTOM || align == DN_ALIGN_MIDDLE || align == DN_ALIGN_TOP,
        str("[DEEZ-NUTS] align must be DN_ALIGN_BOTTOM (\"", DN_ALIGN_BOTTOM, "\"), DN_ALIGN_MIDDLE (\"",
            DN_ALIGN_MIDDLE, "\") or DN_ALIGN_TOP (\"", DN_ALIGN_TOP, "\"), got ", align))
    align == DN_ALIGN_BOTTOM ?
        [0, 0, 0] :
        align == DN_ALIGN_MIDDLE ?
            [0, 0, -sh] :
            [0, 0, -sh-hh];


// adding alias
function dn_align2tf(sh, hh, align) = deez_nuts_align_to_transform(sh, hh, align);


// rotation of the part for the argument 'zet' (the axis of the bolt or the nut), the same
// convention as solidpp: "z" (default) keeps it, "x" turns the head towards +x, "y" towards +y
function deez_nuts_zet_rotation(zet, ctx="DEEZ-NUTS") =
    assert(is_undef(zet) || zet == "x" || zet == "y" || zet == "z" || zet == "X" || zet == "Y" || zet == "Z",
        str("[", ctx, "] zet must be \"x\", \"y\" or \"z\", got ", zet))
    __solidpp__get_rotation_from_zet(zet, [0, 0, 0]);


// __private__ recursive implementaion of __solidpp__count_undef_in_list
function __dn__count_undef_in_list(l, idx, res) =
    len(l) == idx ?
        res :
        __dn__count_undef_in_list(l, idx+1, res + (is_undef(l[idx]) ? 1 : 0));

// __protected__ function to compute number of undef elements in the array
function __deez_nuts__count_undef_in_list(l) =
    is_list(l) ?
        __dn__count_undef_in_list(l, 0, 0) :
        undef;


// ---------------------------------------------------------------------------- strings

// __private__ is the string a decimal number: digits with at most one "." (and at least one digit)
function __dn_is_number_string(s) =
    is_string(s) && len(s) > 0 &&
    len([for (c = s) if (c != "." && (ord(c) < ord("0") || ord(c) > ord("9"))) c]) == 0 &&
    len([for (c = s) if (c == ".") c]) <= 1 &&
    len([for (c = s) if (c != ".") c]) > 0;

// recursive function to convert the string to the float
// '-> the string must be a decimal number such as "3", "2.5" or "12"
function float(s, num=0, cnt=0, d_cnt=0) =
    assert(cnt > 0 || __dn_is_number_string(s), str("[DEEZ-NUTS] \"", s, "\" is not a number"))
    cnt == len(s) ?
        num :
        let(c=s[len(s)-cnt-1])
            let(num = ord(c) != ord(".") ?
                        num+(10^(cnt-d_cnt))*(ord(c)-ord("0")) :
                        num/(10^cnt),
                d_cnt = ord(c) != ord(".") ?
                        d_cnt :
                        cnt+1)
            float(s, num=num, cnt=cnt+1, d_cnt=d_cnt);

// __private__ substring [from, to)
function __dn_substr(s, from, to) =
    to <= from ? "" : chr([for (i = [from:1:to-1]) ord(s[i])]);

// upper case of a string (ASCII letters only)
function deez_nuts_upper(s) =
    chr([for (c = s) let(o = ord(c)) o >= ord("a") && o <= ord("z") ? o - 32 : o]);

// __private__ the string without the given characters
function __dn_strip(s, chars) =
    chr([for (c = s) if (len([for (k = chars) if (k == c) 1]) == 0) ord(c)]);

// __private__ the index of the first occurrence of the character 'c' in 's' (undef if none)
// '-> search() would warn "search term not found" when the character is missing
function __dn_index_of(s, c) =
    let(idx = [for (i = [0:1:len(s)-1]) if (s[i] == c) i])
    len(idx) == 0 ? undef : idx[0];


// ---------------------------------------------------------------------------- descriptors

// parser for the descriptor of a bolt, a screw or a nut: "M<d>" or "M<d>x<length>"
// '-> e.g. "M3x20" -> [3, 20, true], "M2.5x10" -> [2.5, 10, true], "M3" -> [3, undef, true]
// '-> the letters are case-insensitive ("m3X20" works too)
// '-> returns [diameter, length (undef without the length), is_metric]
function deez_nuts_parse_descriptor(s) =
    assert(is_string(s) && len(s) >= 2,
        str("[DEEZ-NUTS] the descriptor must be a string such as \"M3x20\" or \"M3\", got ", s))
    let(
        u = deez_nuts_upper(s),
        is_metric = u[0] == "M",
        x_idx = __dn_index_of(u, "X"),
        d_str = __dn_substr(s, 1, is_undef(x_idx) ? len(s) : x_idx),
        l_str = is_undef(x_idx) ? undef : __dn_substr(s, x_idx + 1, len(s)))
    assert(is_metric, str("[DEEZ-NUTS] descriptor \"", s, "\": only metric descriptors (\"M...\") are supported"))
    assert(__dn_is_number_string(d_str),
        str("[DEEZ-NUTS] descriptor \"", s, "\": the diameter \"", d_str, "\" is not a number (expected e.g. \"M3x20\")"))
    assert(is_undef(l_str) || __dn_is_number_string(l_str),
        str("[DEEZ-NUTS] descriptor \"", s, "\": the length \"", l_str, "\" is not a number (expected e.g. \"M3x20\")"))
    [float(d_str), is_undef(l_str) ? undef : float(l_str), is_metric];

// the length is required (bolts and screws)
function deez_nuts_parse_descriptor_with_length(s, ctx="DEEZ-NUTS") =
    let(p = deez_nuts_parse_descriptor(s))
    assert(!is_undef(p[1]), str("[", ctx, "] descriptor \"", s, "\" has no length, expected e.g. \"M3x20\""))
    assert(p[1] > 0, str("[", ctx, "] descriptor \"", s, "\": the length must be positive"))
    p;

// the nominal diameter of a nut: a number (3), or a descriptor ("M3", or the bolt "M3x10")
function deez_nuts_nut_diameter(d, ctx="DEEZ-NUTS") =
    assert(is_num(d) || is_string(d),
        str("[", ctx, "] the nut size must be a number (3) or a descriptor (\"M3\", \"M3x10\"), got ", d))
    is_num(d) ? d : deez_nuts_parse_descriptor(d)[0];


// ---------------------------------------------------------------------------- tolerances

// the value of a dimension: a number (a single value), undef (not given by the standard), or a
// range [min, nominal, max] from which
// $dn_tolerance (DN_TOLERANCE_MIN, DN_TOLERANCE_NOMINAL (default) or DN_TOLERANCE_MAX) selects
function deez_nuts_dimension(v, tolerance=undef) =
    let(t = !is_undef(tolerance) ? tolerance : is_undef($dn_tolerance) ? DN_TOLERANCE_NOMINAL : $dn_tolerance)
    assert(t == DN_TOLERANCE_MIN || t == DN_TOLERANCE_NOMINAL || t == DN_TOLERANCE_MAX,
        str("[DEEZ-NUTS] $dn_tolerance must be \"min\", \"nominal\" or \"max\", got ", t))
    is_num(v) || is_undef(v) ? v :
    assert(is_list(v) && len(v) == 3, str("[DEEZ-NUTS] a dimension is a number or [min, nominal, max], got ", v))
    t == DN_TOLERANCE_MIN ? v[0] : t == DN_TOLERANCE_MAX ? v[2] : v[1];


// the tolerance of the holes: $dn_tolerance when it is set, otherwise DN_TOLERANCE_MAX (a hole made
// for the largest part of the standard; the clearance only compensates the printing)
function deez_nuts_hole_tolerance() =
    is_undef($dn_tolerance) ? DN_TOLERANCE_MAX : $dn_tolerance;


// ---------------------------------------------------------------------------- teardrops

// __private__ the direction of a face letter (lower case: the negative side, as solidpp)
function __dn_letter_vector(c) =
    c == "x" ? [-1, 0, 0] : c == "X" ? [1, 0, 0] :
    c == "y" ? [0, -1, 0] : c == "Y" ? [0, 1, 0] :
    c == "z" ? [0, 0, -1] : c == "Z" ? [0, 0, 1] : undef;

// __private__ the face letter of an axis direction
function __dn_vector_letter(v) =
    v[0] < -0.5 ? "x" : v[0] > 0.5 ? "X" :
    v[1] < -0.5 ? "y" : v[1] > 0.5 ? "Y" :
    v[2] < -0.5 ? "z" : "Z";

// the 'up' letter of a teardrop in the frame of the part before its zet rotation (the hole
// is built along z), from the argument 'teardrop' given in the frame of the call
// '-> teardrop: false / undef (none), true (up is +Z, the hole must be horizontal), or the face
//     letter the tip points to ("X", "y", ...), perpendicular to the axis of the hole
// '-> returns undef (no teardrop) or the local letter ("x", "X", "y", "Y")
function deez_nuts_teardrop_up(teardrop, zet, ctx="DEEZ-NUTS") =
    is_undef(teardrop) || teardrop == false ?
        undef :
        let(
            _zet = is_undef(zet) ? "z" : zet,
            up = teardrop == true ? "Z" : teardrop,
            v = __dn_letter_vector(up))
        assert(!is_undef(v),
            str("[", ctx, "] teardrop must be true, false or a face letter (\"x\", \"X\", \"y\", \"Y\", \"z\", \"Z\"), got ", teardrop))
        let(
            // the inverse of the zet rotation (transposed rotation matrices)
            l = _zet == "x" || _zet == "X" ? [-v[2], v[1], v[0]] :
                _zet == "y" || _zet == "Y" ? [v[0], -v[2], v[1]] :
                v)
        assert(abs(l[2]) < 0.5,
            str("[", ctx, "] the teardrop must point across the hole: up=\"", up, "\" is along zet=\"", _zet, "\"",
                teardrop == true ? "; for a vertical hole, give the up letter, e.g. teardrop=\"Y\"" : ""))
        __dn_vector_letter(l);


// ---------------------------------------------------------------------------- dictionaries

// find a variable in the dictionary
// '-> return data if 'key' is present in dictionary, 'undef' if key is not present in 'dic'
function deez_nuts_find_in_dic(key, dic, cnt=0, data=undef) =
    cnt == len(dic) ?
        data :
        let (data = (key == dic[cnt][0]) ?
                dic[cnt][1] :
                data)
            deez_nuts_find_in_dic(key=key, dic=dic, cnt=cnt+1, data=data);

// the keys of a dictionary (e.g. the sizes of a standard)
function deez_nuts_dic_keys(dic) = [for (e = dic) e[0]];

// __protected__ the entry of a size table, with an error naming the standard and the sizes
function __dn_table_entry(d, dic, ctx, descriptor=undef) =
    let(data = deez_nuts_find_in_dic(key=d, dic=dic))
    assert(!is_undef(data),
        str("[DEEZ-NUTS:", ctx, "] undefined entry for d=", d,
            is_undef(descriptor) ? "" : str(" from descriptor \"", descriptor, "\""),
            ", available: ", deez_nuts_dic_keys(dic)))
    data;


// ---------------------------------------------------------------------------- polygons

// coverts regular polygon width (parallel side distance) aka its inscibed diameter
// to the CIRCUMSCRIBED DIAMETER:
//
//      ________ ________
//     /        \       ^
//    /          \      |
//   /            \     | function
//  |\            /|    |   input
//  | \          / |    |
//  |  \________/__|____v
//  |              |
//  |   function   |
//  |<-- output -->|
//
//
// This eneable to convert measured width of polygons such as hexagonal nut/bolt-heads,
// in to the "diameter" for the openscad cylinder + $fn combination:
//
//      // M10 nut measured height
//      h = 7;
//      // M10 nut measured width -- easily measured
//      w = 17;
//      // M10 nut "corner distance" -- tricky to measured
//      d = deez_nutz_polygon_width_to_circumscribed_diameter(w, fn=6);
//      // the nut model without the any clearances
//      cylinder(d=d, h=7, $fn=6);
//
// NOTE: with solidpp, cylinderpp(d=w, fn=6, polygon="flats") builds it from the width directly
function deez_nutz_polygon_width_to_circumscribed_diameter(w, fn=6) = w/(cos(180/fn));


// coverts regular polygon width (parallel side distance) to
// the INSCRIBED DIAMETER in openscad this is IDENTITY in OpenSCAD:
//
//      ________ ________
//     /        \       ^
//    /          \      |
//   /            \     | function
//  |\            /|    |  output
//  | \          / |    |
//  |  \________/__|____v
//  |              |
//  |   function   |
//  |<--  input -->|
//
//
function deez_nutz_polygon_width_to_inscribed_diameter(r, fn=6) = r;

// DEPRECATED: misspelled name, use deez_nutz_polygon_width_to_inscribed_diameter
function deez_nutz_poluygon_width_to_inscribed_diameter(r, fn=6) =
    echo("[DEEZ-NUTS] DEPRECATED: deez_nutz_poluygon_width_to_inscribed_diameter -> use deez_nutz_polygon_width_to_inscribed_diameter")
    r;
