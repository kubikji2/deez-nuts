// ISO 10642: hexagon socket countersunk head screw (90 deg); the length is the total length
// NOTE: included by deez-nuts.scad
// NOTE: dk nominal (= max) is the theoretical diameter of the sharp-edged cone, dk min the actual head
//
// sources:
// - DIN EN ISO 10642:2020 (M2 to M20): https://fasten.it/en/Norms/Norm/DIN EN ISO 10642
DN_ISO10642 = dn_standard(
    name = "ISO10642", kind = "bolt", shape = "countersunk", length = "total",
    sizes = [
    //   d       dk (head diameter)        k (head height, max)   s (socket)  t (socket depth, min)
        [ 2.0, [[ 3.70,  4.70,  4.70],     1.35,                   1.3,        0.75]],
        [ 2.5, [[ 4.80,  5.88,  5.88],     1.69,                   1.5,        1.00]],
        [ 3.0, [[ 5.54,  6.72,  6.72],     1.86,                   2.0,        1.10]],
        [ 4.0, [[ 7.53,  8.96,  8.96],     2.48,                   2.5,        1.40]],
        [ 5.0, [[ 9.43, 11.20, 11.20],     3.10,                   3.0,        1.75]],
        [ 6.0, [[11.34, 13.44, 13.44],     3.72,                   4.0,        2.20]],
        [ 8.0, [[15.24, 17.92, 17.92],     4.96,                   5.0,        2.90]],
        [10.0, [[19.22, 22.40, 22.40],     6.20,                   6.0,        3.50]],
        [12.0, [[23.12, 26.88, 26.88],     7.44,                   8.0,        4.30]]
    ],
    source = ["https://fasten.it/en/Norms/Norm/DIN EN ISO 10642"]);
