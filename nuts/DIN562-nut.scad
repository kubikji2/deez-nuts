// DIN 562: square thin nut
// NOTE: included by deez-nuts.scad
// NOTE: M10 has the maxima only (the source of the minima stops at M8)
//
// sources:
// - DIN 562:2013 (M1.6 to M10): https://fasten.it/norms/norm/din_562
// - the minima: https://cdefasteners.com/sites/default/files/product-specs/metdin562.pdf
DN_DIN562 = dn_standard(
    name = "DIN562", kind = "nut", shape = "square",
    sizes = [
    //   d       s (width)                 m (height)
        [ 2.0, [[ 3.70,  4.00,  4.00],   [ 0.80,  1.20,  1.20]]],
        [ 2.5, [[ 4.70,  5.00,  5.00],   [ 1.20,  1.60,  1.60]]],
        [ 3.0, [[ 5.20,  5.50,  5.50],   [ 1.40,  1.80,  1.80]]],
        [ 4.0, [[ 6.64,  7.00,  7.00],   [ 1.80,  2.20,  2.20]]],
        [ 5.0, [[ 7.64,  8.00,  8.00],   [ 2.30,  2.70,  2.70]]],
        [ 6.0, [[ 9.64, 10.00, 10.00],   [ 2.72,  3.20,  3.20]]],
        [ 8.0, [[12.57, 13.00, 13.00],   [ 3.52,  4.00,  4.00]]],
        [10.0, [ 16.00,                    5.00                 ]]
    ],
    source = ["https://fasten.it/norms/norm/din_562",
              "https://cdefasteners.com/sites/default/files/product-specs/metdin562.pdf"]);
