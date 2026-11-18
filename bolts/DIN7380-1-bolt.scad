// DIN EN ISO 7380-1: hexagon socket button head screw; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: DIN EN ISO 7380-1 (11/2011) superseded DIN 7380 (05/2004); with a flange: ISO7380-2-bolt.scad
//
// sources:
// - DIN EN ISO 7380-1:2011 (M3 to M16): https://fasten.it/Norms/Norm/DIN_EN_ISO_7380-1
// - M2.5 is not in ISO 7380-1; the values of a manufacturer (only the maxima, no socket depth):
//   https://westfieldfasteners.co.uk/Standards/ScrewBolt-SHBtn-M.pdf
DN_DIN7380_1 = dn_standard(
    name = "DIN7380-1", kind = "bolt", shape = "button", length = "shaft",
    aliases = ["ISO7380-1", "ISO7380", "DIN7380", "DIN EN ISO 7380-1"],
    sizes = [
    //   d       dk (head diameter)        k (head height)        s (socket)  t (socket depth, min)
        [ 2.5, [  4.50,                    1.50,                   1.5,        undef]],
        [ 3.0, [[ 5.40,  5.70,  5.70],   [ 1.40,  1.65,  1.65],    2.0,        1.04]],
        [ 4.0, [[ 7.24,  7.60,  7.60],   [ 1.95,  2.20,  2.20],    2.5,        1.30]],
        [ 5.0, [[ 9.14,  9.50,  9.50],   [ 2.50,  2.75,  2.75],    3.0,        1.56]],
        [ 6.0, [[10.07, 10.50, 10.50],   [ 3.00,  3.30,  3.30],    4.0,        2.08]],
        [ 8.0, [[13.57, 14.00, 14.00],   [ 4.10,  4.40,  4.40],    5.0,        2.60]],
        [10.0, [[17.07, 17.50, 17.50],   [ 5.20,  5.50,  5.50],    6.0,        3.12]],
        [12.0, [[20.48, 21.00, 21.00],   [ 6.24,  6.60,  6.60],    8.0,        4.16]]
    ],
    source = ["https://fasten.it/Norms/Norm/DIN_EN_ISO_7380-1",
              "https://westfieldfasteners.co.uk/Standards/ScrewBolt-SHBtn-M.pdf"]);
