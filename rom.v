`default_nettype none

module rom (i_address, i_enable_out, tri_o_data, o_data);
    parameter c_addr_width = 8;
    parameter c_data_width = 8;
    input wire [c_addr_width-1 : 0] i_address;
    input wire i_enable_out;
    output tri [c_data_width-1 : 0] tri_o_data;
    output wire [c_data_width-1 : 0] o_data;
    
    reg [c_data_width-1 : 0] rom_content [0 : 2**c_addr_width-1];
    
    assign o_data = rom_content[i_address];
    assign tri_o_data = enanable_out ? o_data : 'bz;
    
endmodule
