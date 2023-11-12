include <utils.scad>
include <basic-bolt.scad>


// dictionary to convert the shaft diameter to the head params
LUXPZ_DIC = [   [3.0,   [ 5.8,  2.2]],
                [3.5,   [ 6.9,  2.2]],
                [4.0,   [ 7.8,  2.8]],
                [4.5,   [ 8.8,  3.2]],
                [6.0,   [11.8,  4.2]]];
//                        '     '-> head height 
//                        '-> head diameter

module LUXPZ_screw(bolt_descriptor, align)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_bolt_descriptor(bolt_descriptor);
    sd = _parsed_data[0];
    th = _parsed_data[1];

    echo(sd);

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=LUXPZ_DIC);
    hd = _dic_data[0];
    hh = _dic_data[1];
    
    // construct model
    basic_bolt(hh=hh, hd=hd, sd=sd, th=th, align=align, is_sloped=true);
}

