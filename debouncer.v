module debouncer (
    input button , clk ,
    
    output out
);

    //O botão mantem o contador parado até ser pressionado.
    or or0 (clk_w , button , clk , enable);
    //Quando o botã é solto, a contagem reseta.
    not not0 (notButton , button);

    //Contador de 3 bits síncrono.
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

    //Ao final da contagem: 111; O enable vai mantem o clock do contador em nivel alto, parando o contador e permitindo a passagem do sinal para a saída.
    and and0 (enable , tff0Out , tff1Out , tff2Out);

    not notEnable (out , enable);

endmodule