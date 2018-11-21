`include "alu.v"
`include "register.v"
`include "ram.v"
`include "rom.v"
`include "decoder.v"
`include "counter.v"

`default_nettype none

`define bus {bus_top, bus_bottom}

`define control_bits_out alu_nand_out, alu_inc_out, alu_add_out, tmp_out, ram_out, pc_out, reg_sp_out, reg_c_out, reg_b_out, reg_a_out
`define control_bits_in nxt, brg_in, brg_out_tmp_in, tmp_in, ram_in, ir_in, zf_pc_in, cf_pc_in, pc_in, reg_sp_in, reg_c_in, reg_b_in, reg_a_in

module e800;
    parameter data_width = 8;
    parameter address_width = 16;
    parameter uinstruction_counter_width = 4;
    
    reg clock = 0;
    reg reset = 0;
    tri1 [data_width-1 : 0] bus_top, bus_bottom;
    wire `control_bits_out, `control_bits_in;

    ram #(address_width, data_width) ram (clock, ram_in, ram_out, tmp_content, bus_bottom, bus_bottom);

//  NORMAL BUS REGISTERS
    bus_register #(data_width) reg_a (clock, reset, reg_a_in, reg_a_out, bus_bottom);
    bus_register #(data_width) reg_b (clock, reset, reg_b_in, reg_b_out, bus_bottom);
    bus_register #(data_width) reg_c (clock, reset, reg_c_in, reg_c_out, bus_bottom);
    bus_register #(data_width) reg_sp (clock, reset, reg_sp_in, reg_sp_out, bus_bottom);
    bus_register #(data_width * 2) reg_pc (clock, reset, pc_in || (cf_pc_in && carry_flag) || (zf_pc_in && zero_flag), pc_out, `bus);

//  TEMPORARY & BRIDGE REGISTER
    tristate_register #(data_width * 2) reg_tmp (clock, reset, (tmp_in | brg_out_tmp_in), tmp_out, `bus, `bus, tmp_content); 
    tristate_register #(data_width) reg_brg (clock, reset, brg_in, brg_out_tmp_in, bus_bottom, bus_top, );
    
//  TEMPORARY REGISTER CONTENT
    wire [data_width*2-1 : 0] tmp_content;
    wire [data_width-1 : 0] tmp_top, tmp_bottom;
    assign {tmp_top, tmp_bottom} = tmp_content;

//  ALU
    wire add_carry_out;
    alu_add #(data_width) alu_add (alu_add_out, tmp_bottom, tmp_top, bus_bottom, add_carry_out);
    alu_inc #(data_width*2) alu_inc (alu_inc_out, tmp_content, `bus, );
    alu_nand #(data_width) alu_nand (alu_nand_out, tmp_bottom, tmp_top, bus_bottom);

//  FLAGS
    //flags input whenever alu_add_out is used
    wire carry_flag, zero_flag;
    register #(1) carry_flag_reg (clock, reset, alu_add_out, add_carry_out, carry_flag);
    register #(1) zero_flag_reg (clock, reset, alu_add_out, ~|bus_bottom, zero_flag);
    
//  CONTROL LOGIC
    wire [data_width-1 : 0] instruction_code;
    register #(data_width) reg_ir (clock, reset, ir_in, bus_bottom, instruction_code);
    wire [uinstruction_counter_width-1 : 0] uinstruction_count;
    counter #(uinstruction_counter_width) uinstruction_counter (!clock, (nxt | reset), uinstruction_count);
    
    wire [7 : 0] encoded_control_word;
    rom #(data_width + uinstruction_counter_width, 8) ucode_rom ({instruction_code, uinstruction_count}, , , encoded_control_word);
    decoder #(4) control_word_out_decoder (encoded_control_word[7 : 4], {`control_bits_out});
    decoder #(4) control_word_in_decoder (encoded_control_word[3 : 0], {`control_bits_in});
    
    initial begin
        $readmemh("data/urom.hex", ucode_rom.rom_content);
        $readmemh("data/ram.hex", ram.ram_content);
        
        reset = 0;
        #5  reset = 1;
        #5  reset = 0;
        repeat(500)
            #10;
        $display("ram [ABCD]: %d", ram.ram_content[16'hABCD]);
        $finish;
    end
    
    initial begin
        $monitor("#%b CF: %b, ZF: %b, CW: %h, uinstr:%h%h, bus: %h%h", clock, carry_flag, zero_flag, encoded_control_word, instruction_code, uinstruction_count, bus_top, bus_bottom);
    end
    
    always
        #5 clock = !clock;
endmodule
