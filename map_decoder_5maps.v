module map_decoder_5maps (
    input [2:0] map_code ,

    output [34:0] map
);

    wire [2:0] map_code_w , notMapCode;

    not notEnable (enable , map_code[2]);
    and andEnable [1:0] (map_code_w[1:0] , map_code[1:0] , enable);

    and mapCode2 (map_code_w[2] , map_code[2]);
    
    not not_map_code [2:0] (notMapCode , map_code_w);

//pixel e6

//b'c

wire [4:0] map_w;

and and00 (map_w[0] , notMapCode[1] , map_code_w[0]);

and andOut01 (map[33] , map_w[0]);

//pixel b1 , c1 , b2 , a5 , d5 

//c'+b

or or10 (map_w[1] , notMapCode[0] , map_code_w[1]);

and andOut10 (map[4]  , map_w[1]);
and andOut11 (map[7]  , map_w[1]);
and andOut12 (map[8]  , map_w[1]);
and andOut13 (map[14] , map_w[1]);
and andOut14 (map[25] , map_w[1]);

//pixel c3 , e3 , c6

//b'+c

or or20 (map_w[2] , notMapCode[1] , map_code_w[0]);

and andOut20 (map[16]  , map_w[2]);
and andOut21 (map[19]  , map_w[2]);
and andOut23 (map[30]  , map_w[2]);

//pixel a1 , e1 , a2 , a3 , d7

// c + b + a

or or30 (map_w[3] , map_code_w[2] , map_code_w[1] , map_code_w[0]);

and andOut30 (map[0]  , map_w[3]);
and andOut31 (map[1]  , map_w[3]);
and andOut32 (map[2]  , map_w[3]);
and andOut33 (map[27] , map_w[3]);
and andOut34 (map[28] , map_w[3]);

//pixel d2 , b4

//c'

and andOut40 (map[10] , notMapCode[0]);
and andOut41 (map[22] , notMapCode[0]);

//pixel c4 , e4 , e5

//a'

and andOut50 (map[17] , notMapCode[2]);
and andOut51 (map[31] , notMapCode[2]);
and andOut52 (map[32] , notMapCode[2]);

//pixel c2 

//b' 

and andOut60 (map[15] , notMapCode[1]);

//pixel e2

//b + a

or or70 (map[29] , map_code_w[2] , map_code_w[1]);

//pixel b3

//c + a 

or or80 (map[9] , map_code_w[2] , map_code_w[0]);

//pixel d3

//nor(ab)

nor nor90 (map[23] , map_code_w[2] , map_code_w[1]);

//pixel a4

//xor(abc)

xor xor100 (map[3] , map_code_w[2] , map_code_w[1] , map_code_w[0]);

//pixel d4 , b5 , d6

//d4 , d6: nor(ab) + nor(ac)

//b5: nor(ac)

nor nor110 (nor110Out , map_code_w[2] , map_code_w[1]);
nor nor111 (nor111Out , map_code_w[2] , map_code_w[0]);


and andOut110 (map[11] , nor111Out);

or or110 (map_w[4] , nor110Out , nor111Out);

and andOut111 (map[24] , map_w[4]);
and andOut112 (map[26] , map_w[4]);


//pixel c5 

//nor(bc) + bc

nor nor120 (nor120Out , map_code_w[1] , map_code_w[0]);

and and120 (and120Out , map_code_w[1] , map_code_w[0]);

or or120 (map[18] , nor120Out , and120Out);

//pixel b6 

//nor(ab + c)

nor nor130 (nor130Out , map_code_w[2] , map_code_w[1]);

or or130 (map[12] , nor130Out , map_code_w[0]);

//pixel e7

// c

and andOut140 (map[34] , map_code_w[0]);

//pixel a6 , a7 , b7 , c7

// Logic 1

and andOut150 (map[5] , 1'b1);
and andOut151 (map[6] , 1'b1);
and andOut152 (map[13] , 1'b1);
and andOut153 (map[20] , 1'b1);

//pixel d1

//b' + c'

or or160 (map[21] , notMapCode[1] , notMapCode[0]);

endmodule