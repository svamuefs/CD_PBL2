module d_flipflop (
    input d , clk , 
    output reg q , q2
);

    always @(negedge clk ) begin

        if (! reset)
            out <=0;
        else 
            out <= d;

    end

endmodule