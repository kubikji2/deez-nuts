include<solidpp/solidpp.scad>

$fn = 60;


// single thread segment
module segment(d, D, bottom_t, top_t, depth, angle, fn)
{

    points = [  [d/2,  top_t/2],
                [d/2, -top_t/2],
                [D/2, -bottom_t/2],
                [D/2,  bottom_t/2]];
    angular_length = 360/fn;

    render(1)
    rotate([angle,0,0])
    difference()
    {
        // basic ring
        rotate([0,0,angular_length/2])
            rotate_extrude($fn=fn)
                polygon(points);
        
        // first cutting cube
        rotate([0,0,-angular_length/2])
            cubepp([D,D,D],align="Y");
        
        // second cutting cubepp
        rotate([0,0,angular_length/2])
            cubepp([D,D,D],align="y");

    }
}


// pitch = top_t + bottom_t + 2*sloped_off

module trapezoid_thread(pitch, top_t, bottom_t, d, D, n)
{
    _fn = $fn == 0 ? 30 : $fn;

    // get the depth
    _depth = (D - d)/2;

    // number of repetition
    _rep = floor(n*_fn);

    // difference in angle per each segment
    _dangle = (360/_fn);
    // difference in pitch per each segment
    _dpitch = _pitch/_fn;
    // length of each segmet
    _seg_l = (PI*d)/(_fn);
    // angle of rotation for each segment
    _seg_angle = asin(_dpitch/_seg_l);
    
    // generate thread
    for(i=[0:_rep-1])
    {
        _cur_a = i*_dangle;
        _cur_h = i*_dpitch;
        rotate([0,0,_cur_a])
            translate([0,0,_cur_h])
                segment(d=d, D=D, bottom_t=bottom_t, top_t=top_t, depth =_depth, angle=_seg_angle, fn=_fn);    
    }
}

clrn = 0.2;

_D = 130 + 2*clrn;
_d = 127 - 2*clrn;
_top_t = 1.7 - 2*clrn;
_bottom_t = 2.4 - 2*clrn;
_pitch = 4.5;
_n = 2.5;

trapezoid_thread(pitch=_pitch, top_t=_top_t, bottom_t=_bottom_t, d=_d, D=_D, n=_n);