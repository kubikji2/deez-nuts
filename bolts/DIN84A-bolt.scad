// DIN 84 A: slotted cheese head screw; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: ISO 1207 has taller heads for M2 and M2.5: see ISO1207-bolt.scad
//
// sources:
// - DIN 84:1990 (withdrawn, M1 to M10): https://www.fasten.it/search/suppliers/3
//   https://www.din-fasteners.ferrobend.com/din-standard-screws/din-84/ (slot width n)
DN_DIN84A = dn_standard(
    name = "DIN84A", kind = "bolt", shape = "cheese", length = "shaft",
    aliases = ["DIN84"],
    sizes = [
    //   d       dk (head diameter)        k (head height)        n (slot)    t (slot depth, min)
        [ 2.0, [[ 3.62,  3.80,  3.80],   [ 1.16,  1.30,  1.30],    0.5,        0.60]],
        [ 2.5, [[ 4.32,  4.50,  4.50],   [ 1.46,  1.60,  1.60],    0.6,        0.70]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 1.86,  2.00,  2.00],    0.8,        0.85]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 2.46,  2.60,  2.60],    1.0,        1.10]],
        [ 5.0, [[ 8.28,  8.50,  8.50],   [ 3.12,  3.30,  3.30],    1.2,        1.30]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 3.60,  3.90,  3.90],    1.6,        1.60]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 4.70,  5.00,  5.00],    2.0,        2.00]],
        [10.0, [[15.73, 16.00, 16.00],   [ 5.70,  6.00,  6.00],    2.5,        2.40]]
    ],
    source = ["https://www.fasten.it/search/suppliers/3",
              "https://www.din-fasteners.ferrobend.com/din-standard-screws/din-84/"]);
