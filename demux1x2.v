module demux1x2 (
    input in , select , enable ,
    output out_a , out_b
);

    not not0 (notSelect , select);

    and and0 (out_a , in , notSelect , enable);
    and and1 (out_b , in , select , enable);
    
endmodule