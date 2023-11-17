include <constants.scad>


// retun tranform for particular align
function deez_nuts_align_to_transform(sh, hh, align) = 
    align == DN_ALIGN_BOTTOM ? 
        [0, 0, 0] :
        align == DN_ALIGN_MIDDLE ?
            [0, 0, -sh] :
            align == DN_ALIGN_TOP ?
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


// recursive function to convert the string to the float
// TODO add check
function float(s, num=0, cnt=0, d_cnt=0) = 
    cnt == len(s) ?
        num :
        let(c=s[len(s)-cnt-1])
            // TODO add assert here
            let(num = ord(c) != ord(".") ?
                        num+(10^(cnt-d_cnt))*(ord(c)-ord("0")) :
                        num/(10^cnt),
                d_cnt = ord(c) != ord(".") ?
                        d_cnt :
                        cnt+1)
            float(s, num=num, cnt=cnt+1, d_cnt=d_cnt);


// parser for bolt descriptor
function deez_nuts_parse_descriptor(s) = 
    let(
        x_idx = search("x",s)[0],
        size = float(chr([for (i=[1:x_idx-1]) ord(s[i])])),
        length = float(chr([for (i=[x_idx+1:len(s)-1]) ord(s[i])]))
        )
    [size, length, s[0] == "M"];



// find a variable in the dictionary
// '-> return data if 'key' is present in dictionary, 'undef' if key is not present in 'dic'
function deez_nuts_find_in_dic(key, dic, cnt=0, data=undef) =
    cnt == len(dic) ?
        data :
        let (data = (key == dic[cnt][0]) ?
                dic[cnt][1] :
                data)
            deez_nuts_find_in_dic(key=key, dic=dic, cnt=cnt+1, data=data);
