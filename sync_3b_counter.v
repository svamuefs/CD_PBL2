module sync_3b_counter (
    input clk , enable ,

    output loopEnd ,
    output [2:0] out
);

    t_flipflop tff0 (
        .t(1'b1) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff0Out)
    );

    and andOut0 (out[0] , tff0Out);

    t_flipflop tff1 (
        .t(tff0Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff1Out)
    );

    and andOut1 (out[1] , tff1Out);

    and and0 (and0Out , tff0Out , tff1Out);

    t_flipflop tff2 (
        .t(and0Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff2Out)
    );

    and andOut2 (out[2] , tff2Out);

    and andLoopEnd (loopEnd , tff0Out, tff1Out , tff2Out);

endmodule