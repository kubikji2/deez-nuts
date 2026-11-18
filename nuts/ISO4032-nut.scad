// ISO 4032: hexagon regular nut (style 1)
// NOTE: included by deez-nuts.scad
// NOTE: DIN 934 differs from M5 (heights) and in M10 and M12 (widths): see DIN934-nut.scad
//
// sources:
// - ISO 4032:1999, Table 1, product grade A:
//   https://cdn.standards.iteh.ai/samples/26382/0f8d850e82f741f5b13e5ed78b236426/ISO-4032-1999.pdf
DN_ISO4032 = dn_standard(
    name = "ISO4032", kind = "nut", shape = "hex",
    sizes = [
    //   d       s (across the flats)      m (height)
        [ 2.0, [[ 3.82,  4.00,  4.00],   [ 1.35,  1.60,  1.60]]],
        [ 2.5, [[ 4.82,  5.00,  5.00],   [ 1.75,  2.00,  2.00]]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 2.15,  2.40,  2.40]]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 2.90,  3.20,  3.20]]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 4.40,  4.70,  4.70]]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 4.90,  5.20,  5.20]]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 6.44,  6.80,  6.80]]],
        [10.0, [[15.73, 16.00, 16.00],   [ 8.04,  8.40,  8.40]]],
        [12.0, [[17.73, 18.00, 18.00],   [10.37, 10.80, 10.80]]]
    ],
    source = ["https://cdn.standards.iteh.ai/samples/26382/0f8d850e82f741f5b13e5ed78b236426/ISO-4032-1999.pdf"]);
