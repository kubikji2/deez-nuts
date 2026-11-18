// ISO 10511: prevailing torque hexagon thin nut with a non-metallic insert
// NOTE: included by deez-nuts.scad
// NOTE: DIN 985 has taller nuts from M8 and differs in M10 and M12 (widths): see DIN985-nut.scad
//
// sources:
// - DIN EN ISO 10511:2013 (M3 to M36): https://fasten.it/en/norms/norm/din_en_iso_10511
DN_ISO10511 = dn_standard(
    name = "ISO10511", kind = "nut", shape = "hex-insert",
    sizes = [
    //   d       s (across the flats)      h (total height)       m (metal part, min)
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 3.42,  3.90,  3.90],    1.55]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 4.52,  5.00,  5.00],    1.95]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 4.52,  5.00,  5.00],    2.45]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 5.52,  6.00,  6.00],    2.90]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 6.18,  6.76,  6.76],    3.70]],
        [10.0, [[15.73, 16.00, 16.00],   [ 7.98,  8.56,  8.56],    4.70]],
        [12.0, [[17.73, 18.00, 18.00],   [ 9.53, 10.23, 10.23],    5.70]]
    ],
    source = ["https://fasten.it/en/norms/norm/din_en_iso_10511"]);
