include <../constants.scad>
include <../utils.scad>
include <../basic-bolt.scad>

// dictionary to convert the shaft diameter to the head params
DIN912_DIC = [  [2.0,   [ 3.8,  1.93]],
                [2.5,   [ 4.5,  2.43]],
                [3.0,   [ 5.5,  2.93]]];
//                        '     '-> head height 
//                        '-> head diameter

// DIN912 groove
module DIN912_groove($fn = 6)
{
	_s = 2.5;
	sf = 1/cos(180/$fn);
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
module DIN912_bolt(descriptor, align, visual=false)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN912_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN912-bolt] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
	difference()
    {
		
        basic_bolt(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false);

    	if (visual){
			//TODO transform as bolt
			t = 1.3;
			_tf = deez_nuts_align_to_transform(sh=sh, hh=hh, align=align);
			translate(_tf)
			translate([0, 0, hh+sh-t])
			{
				DIN912_groove();
			}

        }
    }
}



// DIN912 bolt hole
module DIN912_bolt_hole(descriptor, align,
                        sh_off=0, hh_off=0,
                        clearance=0.1, eps=DN_EPS)
{
    // parse bolt descriptor
    _parsed_data = deez_nuts_parse_descriptor(descriptor);
    sd = _parsed_data[0];
    sh = _parsed_data[1];

    // parserd dic data
    _dic_data = deez_nuts_find_in_dic(key=sd, dic=DIN912_DIC);
    assert (!is_undef(_dic_data),
            str("[DEEZ-NUTS:DIN912-bolt-hole] undefined entry for d=",sd, " from descriptor ", descriptor, "!"));
    hd = _dic_data[0];
    hh = _dic_data[1];

    // construct model
    basic_bolt_hole(hh=hh, hd=hd, sd=sd, sh=sh, align=align, is_sloped=false,
                    sh_off=sh_off, hh_off=hh_off, clearance=clearance, eps=eps);

}



// DIN912 get head diameter
function DIN912_get_head_diameter(descriptor, is_inradius) =
    basic_bolt_get_head_diameter(descriptor=descriptor, dic=DIN912_DIC, is_inradius=is_inradius);

// DIN912 get head height
function DIN912_get_head_height(descriptor) =
    basic_bolt_get_head_height(descriptor=descriptor, dic=DIN912_DIC);