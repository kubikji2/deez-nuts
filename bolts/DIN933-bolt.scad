// DIN 933: hexagon head screw, fully threaded; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: ISO 4017 differs in M10 and M12 (16 and 18 across the flats): see ISO4017-bolt.scad
//
// sources:
// - DIN 933 (withdrawn, replaced by ISO 4017), product grade A:
//   https://westfieldfasteners.co.uk/Standards/ScrewBolt-HexHd-M-THRfull.pdf
//   https://fasten.it/en/Norms/Norm/DIN 933
DN_DIN933 = dn_standard(
    name = "DIN933", kind = "bolt", shape = "hex", length = "shaft",
    sizes = [
    //   d       s (across the flats)      k (head height)
        [ 2.0, [[ 3.82,  4.00,  4.00],   [ 1.28,  1.40,  1.52]]],
        [ 2.5, [[ 4.82,  5.00,  5.00],   [ 1.58,  1.70,  1.82]]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 1.88,  2.00,  2.12]]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 2.68,  2.80,  2.92]]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 3.35,  3.50,  3.65]]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 3.85,  4.00,  4.15]]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 5.15,  5.30,  5.45]]],
        [10.0, [[16.73, 17.00, 17.00],   [ 6.22,  6.40,  6.56]]],
        [12.0, [[18.67, 19.00, 19.00],   [ 7.32,  7.50,  7.68]]]
    ],
    source = ["https://westfieldfasteners.co.uk/Standards/ScrewBolt-HexHd-M-THRfull.pdf",
              "https://fasten.it/en/Norms/Norm/DIN 933"]);
