// ISO 4017: hexagon head screw, fully threaded; the length is the length of the shaft
// NOTE: included by deez-nuts.scad
// NOTE: DIN 933 differs in M10 and M12 (17 and 19 across the flats): see DIN933-bolt.scad
//
// sources:
// - ISO 4017:1999 and ISO 4017:2011, Table 1, product grade A:
//   https://cdn.standards.iteh.ai/samples/26378/473a9e8dfdd149f6a786518275db3f6b/ISO-4017-1999.pdf
//   https://cdn.standards.iteh.ai/samples/56449/d65a66b5cac740459e5aa7f30b7aed34/ISO-4017-2011.pdf
DN_ISO4017 = dn_standard(
    name = "ISO4017", kind = "bolt", shape = "hex", length = "shaft",
    sizes = [
    //   d       s (across the flats)      k (head height)
        [ 2.0, [[ 3.82,  4.00,  4.00],   [ 1.275, 1.40,  1.525]]],
        [ 2.5, [[ 4.82,  5.00,  5.00],   [ 1.575, 1.70,  1.825]]],
        [ 3.0, [[ 5.32,  5.50,  5.50],   [ 1.875, 2.00,  2.125]]],
        [ 4.0, [[ 6.78,  7.00,  7.00],   [ 2.675, 2.80,  2.925]]],
        [ 5.0, [[ 7.78,  8.00,  8.00],   [ 3.35,  3.50,  3.65 ]]],
        [ 6.0, [[ 9.78, 10.00, 10.00],   [ 3.85,  4.00,  4.15 ]]],
        [ 8.0, [[12.73, 13.00, 13.00],   [ 5.15,  5.30,  5.45 ]]],
        [10.0, [[15.73, 16.00, 16.00],   [ 6.22,  6.40,  6.58 ]]],
        [12.0, [[17.73, 18.00, 18.00],   [ 7.32,  7.50,  7.68 ]]]
    ],
    source = ["https://cdn.standards.iteh.ai/samples/26378/473a9e8dfdd149f6a786518275db3f6b/ISO-4017-1999.pdf",
              "https://cdn.standards.iteh.ai/samples/56449/d65a66b5cac740459e5aa7f30b7aed34/ISO-4017-2011.pdf"]);
