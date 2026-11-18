// DIN 7991: hexagon socket countersunk head screw (90 deg); the length is the total length
// NOTE: included by deez-nuts.scad
// NOTE: ISO 10642 has larger heads (a sharp-edged cone): see ISO10642-bolt.scad
//
// sources:
// - DIN 7991 (withdrawn, M3 to M24): https://eshop-hu.boellhoff.com/out/media/pdf/DIN_7991_Stahl_8.8___en.pdf
//   https://www.din-fasteners.ferrobend.com/din-standard-screws/din-7991/ (socket depth t min)
DN_DIN7991 = dn_standard(
    name = "DIN7991", kind = "bolt", shape = "countersunk", length = "total",
    sizes = [
    //   d       dk (head diameter)        k (head height, max)   s (socket)  t (socket depth, min)
        [ 3.0, [[ 5.70,  6.00,  6.00],     1.7,                    2.0,        0.95]],
        [ 4.0, [[ 7.64,  8.00,  8.00],     2.3,                    2.5,        1.50]],
        [ 5.0, [[ 9.64, 10.00, 10.00],     2.8,                    3.0,        2.05]],
        [ 6.0, [[11.57, 12.00, 12.00],     3.3,                    4.0,        2.25]],
        [ 8.0, [[15.57, 16.00, 16.00],     4.4,                    5.0,        3.20]],
        [10.0, [[19.48, 20.00, 20.00],     5.5,                    6.0,        4.10]],
        [12.0, [[23.48, 24.00, 24.00],     6.5,                    8.0,        4.30]]
    ],
    source = ["https://eshop-hu.boellhoff.com/out/media/pdf/DIN_7991_Stahl_8.8___en.pdf",
              "https://www.din-fasteners.ferrobend.com/din-standard-screws/din-7991/"]);
