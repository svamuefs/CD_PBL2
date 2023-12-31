module map_decoder #(

    parameter DATA_WIDTH = 35 ,
    COLUNE_SIZE = 7 , 
    TOTAL_COLUNES = 5

) (
    input [2:0] map_code ,

    output [DATA_WIDTH-1:0] map

);

    wire [DATA_WIDTH-1:0] pixel_w , T1 , T2 , T3 , T4;
    wire [2:0] not_map_code;

    not notMapCode [2:0] (not_map_code , map_code);

//   a - b - c - d - e
//1 -
//2 -
// .... 

//c = map_code[2]
//b = map_code[1]
//a = map_code[0]

//pixel a1 , e1 , a2 , d7

// c + b + a

or or00 (pixel_w[0] , map_code[2] , map_code[1] , map_code[0]);
and andout00 (map[0] , pixel_w[0]);
and andout01 (map[28] , pixel_w[0]);
and andout02 (map[1] , pixel_w[0]);
and andout03 (map[27] , pixel_w[0]);

//pixel b1 , c1

//c' + b + a

or or10 (pixel_w[1] , not_map_code[2] , map_code[1] , map_code[0]);
and andout10 (map[7] , pixel_w[1]);
and andout11 (map[14] , pixel_w[1]);

//pixel d1

//a' + c' + b

or or20 (map[21] , not_map_code[2] , map_code[1] , not_map_code[0]);

//pixel c2

//a' + c'

or or30 (map[15] , not_map_code[2] , not_map_code[0]);

//pixel e2

//b+a

or or40 (map[29] , map_code[1] , map_code[0]);

//pixel d3 

//a'

and andout50 (map[23] , not_map_code[0]);

//pixel e3 , c3

//b' + c'

or or60 (pixel_w[3] , not_map_code[2] , not_map_code[1]);
and andout60 (map[16] , pixel_w[3]);
and andout61 (map[30] , pixel_w[3]);

//pixel b4

//c' + b

or or70 (map[10] , not_map_code[2] , map_code[1]);

//pixel c4

//a' + b' + c

or or80 (map[17] , map_code[2] , not_map_code[1] , not_map_code[0]);

//pixel d5

//c' + b + a

or or90 (map[25] , not_map_code[2] , map_code[1] , map_code[0]);

//pixel c7

//b' + c' + a

or or100 (map[20] , not_map_code[2] , not_map_code[1] , map_code[0]);

//pixel b2 e a5

//~a~c + ac + b~c

//~a~c
    and and110 (T1[0] , not_map_code[0] , not_map_code[2] ); 
//ac
    and and111 (T2[0] , map_code[0] , map_code[2] );         
//b~c
    and and112 (T3[0] , map_code[1] , not_map_code[2] );     

    or or110 (pixel_w[2] , T1[0] , T2[0] , T3[0]);

    and andout110 (map[8] , pixel_w[2]);
    and andout111 (map[4] , pixel_w[2]);

//pixel d2

//~a~c + ab

//~a~c
    and and120 (T1[1] , not_map_code[0] , not_map_code[2] );
//ab
    and and121 (T2[1] , map_code[0] , map_code[1] );

    or or120 (map[22] , T1[1] , T2[1]);

// pixel a3 

// ~bc + b~c + a

//~bc
    and and130 (T1[2] , not_map_code[1] , map_code[2] );
//b~c
    and and131 (T2[2] , map_code[1] , not_map_code[2] );

    or or130 (map[2] , T1[2] , T2[2] , map_code[0]);

//pixel b3

//~bc + b~c + ~ac

//~bc
    and and140 (T1[3] , not_map_code[1] , map_code[2] );
//b~c
    and and141 (T2[3] , map_code[1] , not_map_code[2] );
//~ac
    and and142 (T3[3] , not_map_code[0] , map_code[2] );
    or or140 (map[9] , T1[3] , T2[3] , T3[3]);

//pixel a4

//~a~bc + b~c + a~c + ab

//~a~bc
    and and150 (T1[4] , not_map_code[0] , not_map_code[1] , map_code[2] );
//b~c
    and and151 (T2[4] , map_code[1] , not_map_code[2] );
//a~c
    and and152 (T3[4] , map_code[0] , not_map_code[2] );
//ab
    and and153 (T4[4] , map_code[0] , map_code[1] );
    or or150 (map[3] , T1[4] , T2[4] , T3[4] , T4[4]);

//pixel d4

//~a + ~b~c + bc

//~b~c
    and and161 (T2[5] , not_map_code[1] , not_map_code[2] );
//bc
    and and162 (T3[5] , map_code[1] , map_code[2] );
    or or160 (map[24] , T2[5] , T3[5] , not_map_code[0]);

//pixel e4 

// ~b + ~a~c + ac

//~a~c
    and and171 (T2[6] , not_map_code[0] , not_map_code[2] );
//ac
    and and172 (T3[6] , map_code[0] , map_code[2] );
    or or170 (map[31] , T2[6] , T3[6] , not_map_code[1]);

//pixel b5

//~b~c + bc + ~a~c

//~b~c
    and and180 (T1[7] , not_map_code[1] , not_map_code[2] );
//bc
    and and181 (T2[7] , map_code[1] , map_code[2] );
//~a~c
    and and182 (T3[7] , not_map_code[0] , not_map_code[2] );
    or or180 (map[11] , T1[7] , T2[7] , T3[7]);

//pixel c5

//~c + ~ab + a~b

//~ab
    and and190 (T2[8] , not_map_code[0] , map_code[1] );
//a~b
    and and191 (T3[8] , map_code[0] , not_map_code[1] );
    or or190 (map[18] , T2[8] , T3[8] , not_map_code[2]);

//pixel e5

//~a~c + ac + ~a~b

//~a~c
    and and200 (T1[9] , not_map_code[0] , not_map_code[2] );
//ac
    and and201 (T2[9] , map_code[0] , map_code[2] );
//~a~b
    and and202 (T3[9] , not_map_code[0] , not_map_code[1] );
    or or200 (map[32] , T1[9] , T2[9] , T3[9]);

//pixel b6

//~a~c + ~bc

//~a~c
    and and210 (T1[10] , not_map_code[0] , not_map_code[2] );
//~bc
    and and211 (T2[10] , not_map_code[1] , map_code[2] );
    or or210 (map[12] , T1[10] , T2[10]);

//pixel c6

//~a + ~bc + b~c

//~bc
    and and221 (T2[11] , not_map_code[1] , map_code[2] );
//b~c
    and and222 (T3[11] , map_code[1] , not_map_code[2] );
    or or220 (map[19] , T2[11] , T3[11] , not_map_code[0]);

//pixel d6

//~a~b + abc

//~a~b
    and and230 (T1[12] , not_map_code[0] , not_map_code[1] );
//abc
    and and231 (T2[12] , map_code[0] , map_code[1] , map_code[2] );
    or or230 (map[26] , T1[12] , T2[12]);

//pixel e6

// ~ac + ~ab + a~b~c

//~ac
    and and240 (T1[13] , not_map_code[0] , map_code[2] );
//~ab
    and and241 (T2[13] , not_map_code[0] , map_code[1] );
//a~b~c
    and and242 (T3[13] , map_code[0] , not_map_code[1] , not_map_code[2] );
    or or240 (map[33] , T1[13] , T2[13] , T3[13]);

//pixel e7

//~ab + a~b + ~ac

//~ab
    and and250 (T1[14] , not_map_code[0] , map_code[1] );
//a~b
    and and251 (T2[14] , map_code[0] , not_map_code[1] );
//~ac
    and and252 (T3[14] , not_map_code[0] , map_code[2] );
    or or250 (map[34] , T1[14] , T2[14] , T3[14]);

//pixel a6 , a7 , b7

and andout260 (map[5] , 1'b1);
and andout261 (map[6] , 1'b1);
and andout262 (map[13] , 1'b1);

endmodule