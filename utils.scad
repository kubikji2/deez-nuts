include <constants.scad>


// retun tranform for particular alignment
function deez_nuts_alignment_to_transform(sh, hh, alignment) = 
    alignment == DN_BOTTOM ? 
        [0,0,0] :
        alignment == DN_MIDDLE ?
            [0,0,sh] :
            alignment == DN_TOP ?
                [0,0,sh+hh] :
                undef;


// adding alias
function dn_align2tf(sh, hh, align) = deez_nuts_alignment_to_transform(sh, hh, align);


