module mux2x1 (
    input in_a , in_b , select , enable ,

    output out
);

    not not0 (notSelect , select);

    and and0 (and0_w , in_a , notSelect , enable);
    and and1 (and1_w , in_b , select , enable);

    or or0 (out , and0_w , and1_w);
    
endmodule