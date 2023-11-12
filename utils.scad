include <constants.scad>


// retun tranform for particular align
function deez_nuts_align_to_transform(sh, hh, align) = 
    align == DN_BOTTOM ? 
        [0, 0, 0] :
        align == DN_MIDDLE ?
            [0, 0, -sh] :
            align == DN_TOP ?
                [0, 0, -sh-hh] :
                undef;


// adding alias
function dn_align2tf(sh, hh, align) = deez_nuts_align_to_transform(sh, hh, align);


