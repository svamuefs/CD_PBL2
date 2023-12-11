module demux1x4(
    input in , 
    input [1:0] select ,
    input enable ,

    output out_a , out_b , out_c , out_d
);

    not not0 (notSelect1 , select[1]);

    and and0 (enable0 , notSelect1 , enable);
    and and1 (enable1 , select[1] , enable);

    demux1x2 demux0 (
        .in     (in) ,
        .select (select[0]) ,
        .enable (enable0) , 

        .out_a  (out_a) ,
        .out_b  (out_b)
    );

    demux1x2 demux1 (
        .in     (in) ,
        .select (select[0]) ,
        .enable (enable1) , 

        .out_a  (out_c) ,
        .out_b  (out_d)
    );
    
endmodule