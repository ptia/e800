module counter(i_clock, i_reset, o_count);
    parameter count_width = 8;
    input wire i_clock, i_reset;
    output reg [count_width-1 : 0] o_count = 0;

    always @ (posedge i_clock) begin
        o_count <= o_count + 1;
    end
    
    always @ (posedge i_reset)
        o_count <= 0;
endmodule
