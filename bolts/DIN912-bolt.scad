include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// DIN 912 (ISO 4762): hexagon socket head cap bolt; the length is the length of the shaft
// TODO verify the values against the standard
// dictionary to convert the shaft diameter to the head params
DIN912_DIC = [  [2.0,   [ 3.8,  1.93]],
                [2.5,   [ 4.5,  2.43]],
                [3.0,   [ 5.5,  2.93]],
                [5.0,   [ 8.5,  5.00]]];
//                        '     '-> head height
//                        '-> head diameter

// DIN912 groove (the hexagon socket, visual only)
// TODO the size of the socket is fixed (M3: 2.5 across the flats, 1.3 deep)
module DIN912_groove(fn = 6)
{
	_s = 2.5;
	sf = 1/cos(180/fn);
	t = 1.3;
	s = _s*sf;
	x = (s/2) / tan(60);

	union()
	{
		cylinder(h = t+0.001, d = s, $fn = 6);
		translate([0, 0, -x])
            cylinder(h = x+0.001, r2 = s/2, r1 = 0, $fn = 6);
	}
}

// DIN912 bolt
// '-> argument 'descriptor' e.g. "M3x20" (the length of the shaft)
// '-> argument 'align' DN_ALIGN_BOTTOM (default), DN_ALIGN_MIDDLE or DN_ALIGN_TOP
// '-> argument 'zet' the axis: "z" (default), "x" or "y" (as solidpp)
module DIN912_bolt(descriptor, align=DN_ALIGN_BOTTOM, visual=false, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN912-bolt");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN912_DIC, "DIN912-bolt", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    rotate(deez_nuts_zet_rotation(zet, "DEEZ-NUTS:DIN912-bolt"))
    difference()
    {
        basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false);

        if (visual)
        {
            t = 1.3;
            _tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
            translate(_tf)
                translate([0, 0, hh+sh-t])
                    DIN912_groove();
        }
    }
}



// DIN912 bolt hole
module DIN912_bolt_hole(descriptor, align=DN_ALIGN_BOTTOM,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS, zet=undef)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor_with_length(descriptor, "DEEZ-NUTS:DIN912-bolt-hole");
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = __dn_table_entry(sd, DIN912_DIC, "DIN912-bolt-hole", descriptor);
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps, zet=zet);

}


// DIN912 get head diameter
// NOTE: argument is_circumscribed is irrelevant for this cylindrical-headed bolt
function DIN912_get_head_diameter(descriptor, is_circumscribed) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN912_DIC);


// DIN912 get head height
function DIN912_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN912_DIC);
