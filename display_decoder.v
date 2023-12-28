module display_decoder #(
    parameter DATA_WIDTH = 28 ,
    COLUNE_SIZE = 7 ,
    TOTAL_COLUNES = 4

) (
    input [3:0] binary_code ,
    input enable ,

    output [COLUNE_SIZE-1:0] digitOut

);

//a = binary_code[3]
//b = binary_code[2]
//c = binary_code[1]
//d = binary_code[0]


    wire [COLUNE_SIZE-1:0] digitOut_w , T0 , T1 , T2;
    wire [3:0] not_binary_code;

    not notBinaryCode [3:0] (not_binary_code , binary_code);


//enable
not notEnable_1 (notEnable , enable);
or orEnable [6:0] (digitOut , digitOut_w , notEnable);

//segment A

//~a~b~cd + b~c~d

//~a~b~cd
    and and00 (T0[0] , not_binary_code[3] , not_binary_code[2] , not_binary_code[1] , binary_code[0] ); 
//b~c~d
    and and01 (T1[0] , binary_code[2] , not_binary_code[1] , not_binary_code[0] ); 
    or or00 (digitOut_w[0] , T0[0] , T1[0]);

//segment B

//b~cd + bc~d

//b~cd
    and and10 (T0[1] , binary_code[2] , not_binary_code[1] , binary_code[0] );    
//bc~d
    and and11 (T1[1] , binary_code[2] , binary_code[1] , not_binary_code[0] );    
    or or10 (digitOut_w[1] , T0[1] , T1[1]);

//segment C

//~bc~d

    and and20 (digitOut_w[2] , not_binary_code[2] , binary_code[1] , not_binary_code[0] );

//segment D

//~a~b~cd + b~c~d + bcd

//~a~b~cd
    and and30 (T0[3] , not_binary_code[3] , not_binary_code[2] , not_binary_code[1] , binary_code[0] );
//b~c~d
    and and31 (T1[3] , binary_code[2] , not_binary_code[1] , not_binary_code[0] );
//bcd
    and and32 (T2[3] , binary_code[2] , binary_code[1] , binary_code[0] );        
    or or30 (digitOut_w[3] , T0[3] , T1[3] , T2[3]);

//segment E
    
// d + b~c

//b~c
    and and41 (T1[4] , binary_code[2] , not_binary_code[1] );
    or or40 (digitOut_w[4] , binary_code[0] , T1[4]);

//segment F

//~a~bd + ~bc + cd

//~a~bd
    and and50 (T0[5] , not_binary_code[3] , not_binary_code[2] , binary_code[0] );
//~bc
    and and51 (T1[5] , not_binary_code[2] , binary_code[1] );
//cd
    and and52 (T2[5] , binary_code[1] , binary_code[0] );
    or or50 (digitOut_w[5] , T0[5] , T1[5] , T2[5]);

//segment G

//~a~b~c + bcd

//~a~b~c
    and and60 (T0[6] , not_binary_code[3] , not_binary_code[2] , not_binary_code[1] );
//bcd
    and and61 (T1[6] , binary_code[2] , binary_code[1] , binary_code[0] );        
    or or60 (digitOut_w[6] , T0[6] , T1[6]);


endmodule