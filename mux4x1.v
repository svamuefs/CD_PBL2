module mux4x1 (

    input in_a , in_b , in_c , in_d ,
    input [1:0] select ,
    input enable ,

    output out
);

  mux2x1 mux0 (
	.in_a (in_a) ,
	.in_b (in_b) ,
	.select (select[0]),
	.enable (enable) ,
	.out (mux0_w)
);

	mux2x1 mux1 (
	.in_a (in_c) ,
	.in_b (in_d) ,
	.select (select[0]),
	.enable (enable) ,
	.out (mux1_w)
);

mux2x1 mux2 (
	.in_a (mux0_w) ,
	.in_b (mux1_w) ,
	.select (select[1]),
	.enable (enable) ,
	.out (out)
);

endmodule