module mux8x1
(
    input in_a , in_b , in_c , in_d , in_e , in_f , in_g , in_h ,
    input [2:0] select , 
    input enable ,

    output out
);

    mux4x1 mux_0 (
        .in_a   (in_a) ,
        .in_b   (in_b) ,
        .in_c   (in_c) ,
        .in_d   (in_d) ,
        .select (select[1:0]) ,
        .enable (enable) ,

        .out    (mux0_w)
    );

    mux4x1 mux_1 (
        .in_a   (in_e) ,
        .in_b   (in_f) ,
        .in_c   (in_g) ,
        .in_d   (in_h) ,
        .select (select[1:0]) ,
        .enable (enable) ,

        .out    (mux1_w)
    );

mux2x1 mux_2 (
        .in_a   (mux0_w) ,
        .in_b   (mux1_w) ,
        .select (select[2]) ,
        .enable (enable) ,

        .out    (out)
    );
endmodule