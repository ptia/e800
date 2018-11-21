`include "register.v"
`include "ram.v"
`include "rom.v"
`include "counter.v"

`default_nettype none

module eRISC;
    parameter bit_width = 8;
    
    reg clock = 0;
    reg reset = 0;
    tri [bit_width-1 : 0] bus;
    
    wire reg_in, pc_in;
    wire reg_out, rom_out, pc_out;
    
    wire [bit_width] reg_content;
    wire [bit_width] pc_content;
    tristate_register register #(bit_width) (clock, reset, reg_in, reg_out, bus, bus, reg_content);
    tristate_register pc #(bit_width) (clock, reset, pc_in, pc_out, bus, bus, pc_content);
    
    rom prg_rom #(bit_width+1, bit_width) ({pc_content, clock}, rom_out, bus);

endmodule
