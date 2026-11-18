// ISO 1207: slotted cheese head screw; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: the source gives the maxima only (dk and k nominal = max)
//
// sources:
// - DIN EN ISO 1207:2011 (M1.6 to M10): https://fasten.it/norms/norm/din_en_iso_1207
DN_ISO1207 = dn_standard(
    name = "ISO1207", kind = "bolt", shape = "cheese", length = "shaft",
    sizes = [
    //   d       dk (head diameter)  k (head height)  n (slot)  t (slot depth, min)
        [ 2.0, [  3.8,                1.4,             0.5,      0.60]],
        [ 2.5, [  4.5,                1.8,             0.6,      0.70]],
        [ 3.0, [  5.5,                2.0,             0.8,      0.85]],
        [ 4.0, [  7.0,                2.6,             1.2,      1.10]],
        [ 5.0, [  8.5,                3.3,             1.2,      1.30]],
        [ 6.0, [ 10.0,                3.9,             1.6,      1.60]],
        [ 8.0, [ 13.0,                5.0,             2.0,      2.00]],
        [10.0, [ 16.0,                6.0,             2.5,      2.40]]
    ],
    source = ["https://fasten.it/norms/norm/din_en_iso_1207"]);
