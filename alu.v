`default_nettype none

module alu_add (i_enable_out, i_arg1, i_arg2, o_result, o_carry);
    parameter c_arg_width = 8;
    input wire i_enable_out;
    input wire [c_arg_width-1 : 0] i_arg1, i_arg2;
    output tri [c_arg_width-1 : 0] o_result;
    output wire o_carry;

    wire [c_arg_width-1 : 0] add_result;
    
    assign {o_carry, add_result} = i_arg1 + i_arg2;
    assign o_result = i_enable_out ? add_result : 'bz;
endmodule

module alu_inc (i_enable_out, i_arg, o_result, o_carry);
    parameter c_arg_width = 8;
    input wire i_enable_out;
    input wire [c_arg_width-1 : 0] i_arg;
    output tri [c_arg_width-1 : 0] o_result;
    output wire o_carry;

    wire [c_arg_width-1 : 0] inc_result;
    
    assign {o_carry, inc_result} = i_arg + 1;
    assign o_result = i_enable_out ? inc_result : 'bz;
endmodule

module alu_nand (i_enable_out, i_arg1, i_arg2, o_result);
    parameter c_arg_width = 8;
    input wire i_enable_out;
    input wire [c_arg_width-1 : 0] i_arg1, i_arg2;
    output tri [c_arg_width-1 : 0] o_result;
    
    assign o_result = i_enable_out ? ~(i_arg1 & i_arg2) : 'bz;
endmodule
/*
module testbench;
    parameter c_arg_width = 8;
    reg add_o, inc_o, nand_o;
    reg [c_arg_width-1 : 0] arg1, arg2;
    tri [c_arg_width-1 : 0] bus;
    wire add_carry, inc_carry;
    alu_add #(c_arg_width) adder (add_o, arg1, arg2, bus, add_carry);
    alu_inc #(c_arg_width) incrementer (inc_o, arg1, bus, inc_carry);
    alu_nand #(c_arg_width) nander (nand_o, arg1, arg2, bus);
    
    initial begin
        $monitor("arg1: %d, arg2: %d, add_o: %b, inc_o: %b, nand_o: %b, bus: %d add_carry: %b, inc_carry: %b",
                    arg1, arg2, add_o, inc_o, nand_o, bus, add_carry, inc_carry);
        add_o = 0;
        inc_o = 0;
        nand_o = 0;
        arg1 = 254;
        arg2 = 10;
        #10 add_o = 1;
        #10 add_o = 0;
            inc_o = 1;
        #10 inc_o = 0;
            nand_o = 1;
        #5 $finish;
    end
endmodule
*/
