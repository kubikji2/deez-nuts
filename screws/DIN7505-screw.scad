// DIN 7505: chipboard (wood) screw with a countersunk head and a cross recess (Pozidriv);
// the length is the total length
// NOTE: included by deez-nuts.scad
// NOTE: DIN 7505 is withdrawn and the screws are made to the manufacturers' own drawings, e.g. the
//       universal Pozidriv screws (formerly "LUXPZ"); the head is modelled as a 90 deg cone with a
//       short cylinder on top (k is a bit higher than the cone)
//
// sources:
// - DIN 7505 countersunk head (approximate, the 1986 tables): https://fasten.it/norms/norm/din_7505
// - Boellhoff B 7505, countersunk head (the minima):
//   https://eshop-cz.boellhoff.com/out/media/pdf/B_7505_Stahl_gv_Senkkopf___en.pdf
DN_DIN7505 = dn_standard(
    name = "DIN7505", kind = "screw", shape = "countersunk-z", length = "total",
    deprecated = ["LUXPZ"],
    sizes = [
    //   d       dk (head diameter)        k (head height)
        [ 3.0, [[ 5.60,  6.00,  6.00],   [ 1.60,  1.90,  1.90]]],
        [ 3.5, [[ 6.60,  7.00,  7.00],   [ 1.80,  2.10,  2.10]]],
        [ 4.0, [[ 7.50,  8.00,  8.00],   [ 2.10,  2.50,  2.50]]],
        [ 4.5, [[ 8.50,  9.00,  9.00],   [ 2.30,  2.70,  2.70]]],
        [ 5.0, [[ 9.50, 10.00, 10.00],   [ 2.60,  3.00,  3.00]]],
        [ 6.0, [[11.50, 12.00, 12.00],   [ 3.10,  3.60,  3.60]]]
    ],
    source = ["https://fasten.it/norms/norm/din_7505",
              "https://eshop-cz.boellhoff.com/out/media/pdf/B_7505_Stahl_gv_Senkkopf___en.pdf"]);
