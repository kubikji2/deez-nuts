// DIN 934: hexagon nut
// NOTE: included by deez-nuts.scad
// NOTE: ISO 4032 differs from M5 (heights) and in M10 and M12 (widths): see ISO4032-nut.scad
//
// sources:
// - DIN 934 (withdrawn, replaced by ISO 4032): https://westfieldfasteners.co.uk/Standards/Nut-Hex-M.pdf
DN_DIN934 = dn_standard(
    name = "DIN934", kind = "nut", shape = "hex",
    sizes = [
    //   d       s (across the flats)      m (height)
        [ 2.0, [[ 3.82,  4.00,  4.00],   [ 1.35,  1.60,  1.60]]],
        [ 2.5, [[ 4.82,  5.00,  5.00],   [ 1.75,  2.00,  2.00]]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 2.15,  2.40,  2.40]]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 2.90,  3.20,  3.20]]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 3.70,  4.00,  4.00]]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 4.70,  5.00,  5.00]]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 6.14,  6.50,  6.50]]],
        [10.0, [[16.73, 17.00, 17.00],   [ 7.64,  8.00,  8.00]]],
        [12.0, [[18.67, 19.00, 19.00],   [ 9.64, 10.00, 10.00]]]
    ],
    source = ["https://westfieldfasteners.co.uk/Standards/Nut-Hex-M.pdf"]);
