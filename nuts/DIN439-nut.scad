// DIN 439: hexagon thin nut
// NOTE: included by deez-nuts.scad
// NOTE: ISO 4035 differs in M10 and M12 (16 and 18 across the flats): see ISO4035-nut.scad
// NOTE: the source gives the width across the flats as nominal = max only
//
// sources:
// - DIN 439-2:1987 (withdrawn, replaced by ISO 4035): https://fasten.it/norms/norm/din_439-2
DN_DIN439 = dn_standard(
    name = "DIN439", kind = "nut", shape = "hex",
    aliases = ["DIN439B", "DIN439-2"],
    sizes = [
    //   d       s (across the flats)  m (height)
        [ 2.0, [  4.0,                [ 0.95,  1.20,  1.20]]],
        [ 2.5, [  5.0,                [ 1.35,  1.60,  1.60]]],
        [ 3.0, [  5.5,                [ 1.55,  1.80,  1.80]]],
        [ 4.0, [  7.0,                [ 1.95,  2.20,  2.20]]],
        [ 5.0, [  8.0,                [ 2.45,  2.70,  2.70]]],
        [ 6.0, [ 10.0,                [ 2.90,  3.20,  3.20]]],
        [ 8.0, [ 13.0,                [ 3.70,  4.00,  4.00]]],
        [10.0, [ 17.0,                [ 4.70,  5.00,  5.00]]],
        [12.0, [ 19.0,                [ 5.70,  6.00,  6.00]]]
    ],
    source = ["https://fasten.it/norms/norm/din_439-2"]);
