// DIN 985: prevailing torque hexagon nut with a non-metallic (nylon) insert, low type
// NOTE: included by deez-nuts.scad
// NOTE: ISO 10511 has lower nuts from M8 and differs in M10 and M12 (widths): see ISO10511-nut.scad
//
// sources:
// - DIN 985 (withdrawn, M3 to M48): https://westfieldfasteners.co.uk/Standards/Nut-HexNy-M.pdf
// - M2 and M2.5 are not in DIN 985; the values of a manufacturer (maxima only):
//   https://extranet.mandieselturbo.com/electronics/datasheets/Bossard/BN161/BN_161.pdf (Bossard BN 161)
DN_DIN985 = dn_standard(
    name = "DIN985", kind = "nut", shape = "hex-insert",
    sizes = [
    //   d       s (across the flats)      h (total height)       m (metal part, min)
        [ 2.0, [  4.00,                    2.80,                   1.0]],
        [ 2.5, [  5.00,                    3.70,                   2.0]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 3.70,  4.00,  4.00],    2.4]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 4.70,  5.00,  5.00],    2.9]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 4.70,  5.00,  5.00],    3.2]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 5.70,  6.00,  6.00],    4.0]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 7.64,  8.00,  8.00],    5.5]],
        [10.0, [[16.73, 17.00, 17.00],   [ 9.64, 10.00, 10.00],    6.5]],
        [12.0, [[18.67, 19.00, 19.00],   [11.57, 12.00, 12.00],    8.0]]
    ],
    source = ["https://westfieldfasteners.co.uk/Standards/Nut-HexNy-M.pdf",
              "https://extranet.mandieselturbo.com/electronics/datasheets/Bossard/BN161/BN_161.pdf"]);
