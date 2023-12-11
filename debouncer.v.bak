module debouncer (
    input button , clk ,
    output out 
);

    or or0 (clk_w , button , clk , max);
    not not0 (notButton , button);

    t_flipflop t_flipflop_1 (
        .t     (1) ,
        .clk   (clk_w) ,
        .reset (notButton) ,

        .out   (tffOut1)

    );

    t_flipflop t_flipflop_2 (
        .t     (1) ,
        .clk   (tffOut1) ,
        .reset (notButton) ,

        .out   (tffOut2)

    );
    t_flipflop t_flipflop_3 (
        .t     (1) ,
        .clk   (tffOut2) ,
        .reset (notButton) ,

        .out   (tffOut3)

    );

    t_flipflop t_flipflop_4 (
        .t     (1) ,
        .clk   (tffOut3) ,
        .reset (notButton) ,

        .out   (tffOut4)

    );
    t_flipflop t_flipflop_5 (
        .t     (1) ,
        .clk   (tffOut4) ,
        .reset (notButton) ,

        .out   (tffOut5)

    );

    and and0 (max , tffOut1 , tffOut2 , tffOut3 , tffOut4 , tffOut5);

    not not1 (out , max);

endmodule