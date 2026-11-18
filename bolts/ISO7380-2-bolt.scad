// ISO 7380-2: hexagon socket button head screw with flange; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: DIN EN ISO 7380-2 (11/2011) superseded DIN 7380 (05/2004); "DIN7380-2" is accepted too
// NOTE: dc (the flange) is the first column: it is the diameter of the head for the holes
//
// sources:
// - DIN EN ISO 7380-2:2011 (M3 to M16): https://fasten.it/Norms/Norm/DIN_EN_ISO_7380-2
// - the flange height c (min, max): https://westfieldfasteners.co.uk/Standards/ScrewBolt-TXBtnFlg-M.pdf
DN_ISO7380_2 = dn_standard(
    name = "ISO7380-2", kind = "bolt", shape = "button-flange", length = "shaft",
    aliases = ["DIN7380-2", "DIN EN ISO 7380-2"],
    sizes = [
    //   d       dc (flange diameter)      k (head height)        s     t (min)  dk (button diameter)    c (flange height)
        [ 3.0, [[ 6.32,  6.90,  6.90],   [ 1.40,  1.65,  1.65],    2.0,  1.04,   [ 4.90,  5.20,  5.20],  [0.55, 0.70, 0.70]]],
        [ 4.0, [[ 8.82,  9.40,  9.40],   [ 1.95,  2.20,  2.20],    2.5,  1.30,   [ 6.80,  7.20,  7.20],  [0.65, 0.80, 0.80]]],
        [ 5.0, [[11.10, 11.80, 11.80],   [ 2.50,  2.75,  2.75],    3.0,  1.56,   [ 8.40,  8.80,  8.80],  [0.80, 1.00, 1.00]]],
        [ 6.0, [[12.90, 13.60, 13.60],   [ 3.00,  3.30,  3.30],    4.0,  2.08,   [ 9.60, 10.00, 10.00],  [1.00, 1.20, 1.20]]],
        [ 8.0, [[17.10, 17.80, 17.80],   [ 4.10,  4.40,  4.40],    5.0,  2.60,   [12.80, 13.20, 13.20],  [1.25, 1.50, 1.50]]],
        [10.0, [[21.06, 21.90, 21.90],   [ 5.20,  5.50,  5.50],    6.0,  3.10,   [16.10, 16.50, 16.50],  [1.70, 2.00, 2.00]]],
        [12.0, [[25.16, 26.00, 26.00],   [ 6.24,  6.60,  6.60],    8.0,  4.16,   [18.90, 19.40, 19.40],  [2.10, 2.40, 2.40]]]
    ],
    source = ["https://fasten.it/Norms/Norm/DIN_EN_ISO_7380-2",
              "https://westfieldfasteners.co.uk/Standards/ScrewBolt-TXBtnFlg-M.pdf"]);
