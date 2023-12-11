module sync_freq_divider (
    input clk , enable ,
    output final_clk
);

    t_flipflop tff0 (
        .t(1'b1) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff0Out)
    );


    t_flipflop tff1 (
        .t(tff0Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff1Out)
    );

    and and2 (and2Out , tff0Out , tff1Out);

    t_flipflop tff2 (
        .t(and2Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff2Out)
    );

    and and3 (and3Out , tff2Out , and2Out);

    t_flipflop tff3 (
        .t(and3Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff3Out)
    );

    and and4 (and4Out , tff3Out , and3Out);

    t_flipflop tff4 (
        .t(and4Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff4Out)
    );

    and and5 (and5Out , tff4Out , and4Out);

    t_flipflop tff5 (
        .t(and5Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff5Out)
    );

    and and6 (and6Out , tff5Out , and5Out);

    t_flipflop tff6 (
        .t(and6Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff6Out)
    );

    and and7 (and7Out , tff6Out , and6Out);

    t_flipflop tff7 (
        .t(and7Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff7Out)
    );

    and and8 (and8Out , tff7Out , and7Out);

    t_flipflop tff8 (
        .t(and8Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff8Out)
    );

    and and9 (and9Out , tff8Out , and8Out);

    t_flipflop tff9 (
        .t(and9Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff9Out)
    );

    and and10 (and10Out , tff9Out , and9Out);

    t_flipflop tff10 (
        .t(and10Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff10Out)
    );

    and and11 (and11Out , tff10Out , and10Out);

    t_flipflop tff11 (
        .t(and11Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (tff11Out)
    );

    and and12 (and12Out , tff11Out , and11Out);

    t_flipflop tff12 (
        .t(and12Out) ,
        .clk (clk) ,
        .reset (enable) ,

        .out (final_clk)
    );

    
    
endmodule