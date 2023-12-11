module debouncer (
    input button , clk ,
    output out 
);

    or or0 (clk_w , button , clk , max);
    not not0 (notButton , button);

   t_flipflop tff0 (
        .t(1'b1) ,
        .clk (clk_w) ,
        .reset (notButton) ,

        .out (tff0Out)
    );


    t_flipflop tff1 (
        .t(tff0Out) ,
        .clk (clk_w) ,
        .reset (notButton) ,

        .out (tff1Out)
    );

    and and2 (and2Out , tff0Out , tff1Out);

    t_flipflop tff2 (
        .t(and2Out) ,
        .clk (clk_w) ,
        .reset (notButton) ,

        .out (tff2Out)
    );

    and and3 (and3Out , tff2Out , and2Out);

    nand nand0 (max , tff0Out , tff1Out , tff2Out);

    not not1 (out , max);

endmodule