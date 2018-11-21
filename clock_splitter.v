`default_nettype none

module clock_splitter (i_base_clock, o_clock_A, o_clock_B);
    input wire i_base_clock;
    output reg o_clock_A = 0, o_clock_B = 0;
    
    always @ (posedge i_base_clock)
        o_clock_A = !o_clock_A;
    
    always @ (negedge i_base_clock)
        o_clock_B = !o_clock_B;
endmodule

module testbench;
    reg base_clock = 0;
    wire clock_A, clock_B;
    
    clock_splitter splitter (base_clock, clock_A, clock_B);
    
    initial begin
        $monitor("#%b A%b B%b", base_clock, clock_A, clock_B);
        #100 $finish;
    end
    
    always
        #5 base_clock = !base_clock;
endmodule
