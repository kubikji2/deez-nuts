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



// __private__ recursive implementaion of __solidpp__count_undef_in_list
function __dn__count_undef_in_list(l, idx, res) = 
    len(l) == idx ?
        res :
        __dn__count_undef_in_list(l, idx+1, res + (is_undef(l[idx]) ? 1 : 0));

// __protected__ function to compute number of undef elements in the array
function __deez_nuts__count_undef_in_list(l) =
    is_list(l) ?
        __dn__count_undef_in_list(l, 0, 0) :
        undef;