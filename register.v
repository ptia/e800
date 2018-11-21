`default_nettype none

module register (i_clock, i_reset, i_enable_in, i_data, o_data);
    parameter c_width = 8;
    input wire i_clock, i_reset, i_enable_in;
    input wire [c_width-1 : 0] i_data;
    output wire [c_width-1 : 0] o_data;
    
    reg [c_width-1 : 0] stored_data;
    assign o_data = stored_data;
    
    always @ (posedge i_clock) begin
        if (i_reset)
            stored_data <= 0;
        else if (i_enable_in)
            stored_data <= i_data;
    end
endmodule

module tristate_register (i_clock, i_reset, i_enable_in, i_enable_out, i_data, tri_o_data, o_data);
    parameter c_width = 8;
    input wire i_clock, i_reset, i_enable_in, i_enable_out;
    input wire [c_width-1 : 0] i_data;
    output tri [c_width-1 : 0] tri_o_data;
    output wire[c_width-1 : 0] o_data; //direct, not tristate output always showing the data stored
    
    register #(c_width) register (i_clock, i_reset, i_enable_in, i_data, o_data);
    assign tri_o_data = i_enable_out ? o_data : 'bz;
    
endmodule

module bus_register (i_clock, i_reset, i_enable_in, i_enable_out, bus);
    parameter c_width = 8;
    input wire i_clock, i_reset, i_enable_in, i_enable_out;
    inout tri [c_width-1 : 0] bus;
    
    //just a tristate_register with bus as data_in and tristate_out and no direct_out
    tristate_register #(c_width) tri_register (i_clock, i_reset, i_enable_in, i_enable_out, bus, bus, );
endmodule

/*
module testbench;
    parameter c_width = 8;
    reg clock, enable_in_A, enable_out_A, enable_in_B, enable_out_B;
    tri1 [c_width-1 : 0] bus;
    bus_register #(c_width) reg_A (clock, enable_in_A, enable_out_A, bus);
    bus_register #(c_width) reg_B (clock, enable_in_B, enable_out_B, bus);
        
    initial begin
        clock = 0;
        enable_in_A = 0; enable_out_A = 0;
        enable_in_B = 0; enable_out_B = 0;
        reg_B.tri_register.register.stored_data = 8'hBD;
        
        #10 enable_out_B = 1;
            enable_in_A = 1;
        #10 enable_out_B = 0;
            enable_in_A = 0;
            enable_out_A = 1;
        #10 enable_out_A = 0;
            enable_in_B = 1;
        #10 enable_in_B = 0;
            enable_out_B = 1;
        #10
        $finish;
    end
    
    initial begin
        $monitor("clk: %b, e_i_A: %b, e_o_A: %b, e_i_B: %b, e_o_B: %b, bus: %h", 
                    clock, enable_in_A, enable_out_A, enable_in_B, enable_out_B, bus);
        $dumpfile("dump.vcd");
        $dumpvars(1, testbench);
    end
    
    always
        #5 clock = !clock;
endmodule
*/
