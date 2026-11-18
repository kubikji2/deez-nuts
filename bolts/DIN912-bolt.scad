// DIN 912 / ISO 4762: hexagon socket head cap screw; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
//
// sources:
// - DIN EN ISO 4762:2004 (dk max plain = nominal, dk max knurled = max): https://fasten.it/norms/norm/din_en_iso_4762
// - DIN 912:1983 (the same values; withdrawn, replaced by ISO 4762): https://fasten.it/en/Norms/Norm/DIN 912
DN_DIN912 = dn_standard(
    name = "DIN912", kind = "bolt", shape = "socket", length = "shaft",
    aliases = ["ISO4762"],
    sizes = [
    //   d       dk (head diameter)        k (head height)        s (socket)  t (socket depth, min)
        [ 2.0, [[ 3.62,  3.80,  3.98],   [ 1.86,  2.00,  2.00],    1.5,        1.0]],
        [ 2.5, [[ 4.32,  4.50,  4.68],   [ 2.36,  2.50,  2.50],    2.0,        1.1]],
        [ 3.0, [[ 5.32,  5.50,  5.68],   [ 2.86,  3.00,  3.00],    2.5,        1.3]],
        [ 4.0, [[ 6.78,  7.00,  7.22],   [ 3.82,  4.00,  4.00],    3.0,        2.0]],
        [ 5.0, [[ 8.28,  8.50,  8.72],   [ 4.82,  5.00,  5.00],    4.0,        2.5]],
        [ 6.0, [[ 9.78, 10.00, 10.22],   [ 5.70,  6.00,  6.00],    5.0,        3.0]],
        [ 8.0, [[12.73, 13.00, 13.27],   [ 7.64,  8.00,  8.00],    6.0,        4.0]],
        [10.0, [[15.73, 16.00, 16.27],   [ 9.64, 10.00, 10.00],    8.0,        5.0]],
        [12.0, [[17.73, 18.00, 18.27],   [11.57, 12.00, 12.00],   10.0,        6.0]]
    ],
    source = ["https://fasten.it/norms/norm/din_en_iso_4762", "https://fasten.it/en/Norms/Norm/DIN 912"]);
