module d_flipflop (
    input d , clk , reset ,
    output reg out
);

    always @(posedge clk or negedge reset) begin
        if (! reset)
            out <= 0;
        else 
            out <= d;

    end

endmodule