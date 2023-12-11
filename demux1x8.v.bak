module demux1x8 #(
    parameter DATA_WIDTH = 1
) (
    input [DATA_WIDTH-1:0] in , 
    input [2:0] select ,
    input enable ,

    output [DATA_WIDTH-1:0] out_a , out_b , out_c , out_d , out_e , out_f , out_g , out_h
);

    not not1 (notSelect2 , select[2]);

    demux1x4 #(.DATA_WIDTH(DATA_WIDTH)) demux1x4_1 (
        .in (in) ,
        .select (select[1:0]) ,
        .enable (notSelect2) ,

        .out_a (out_a) , 
        .out_b (out_b) ,
        .out_c (out_c) ,
        .out_d (out_d) 
    );
    
    demux1x4 #(.DATA_WIDTH(DATA_WIDTH))  demux1x4_1 (
        .in (in) ,
        .select (select[1:0]) ,
        .enable (select[2]) ,

        .out_a (out_e) , 
        .out_b (out_f) ,
        .out_c (out_g) ,
        .out_d (out_h) 
    );

endmodule