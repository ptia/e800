`default_nettype none

module ram (i_clock, i_enable_in, i_enable_out, i_address, i_data, o_data);
    parameter c_addr_width = 8;
    parameter c_data_width = 8;
    input wire i_clock, i_enable_in, i_enable_out;
    input wire [c_addr_width-1 : 0] i_address;
    input wire [c_data_width-1 : 0] i_data;
    output wire [c_data_width-1 : 0] o_data;

    reg [c_data_width-1 : 0] ram_content [0 : 2**c_addr_width-1];
    
    assign o_data = i_enable_out ? ram_content[i_address] : 'bz;
    
    always @ (posedge i_clock)
        if (i_enable_in)
            ram_content[i_address] <= i_data;
    
endmodule

/*
module testbench;
    parameter c_addr_width = 1;
    parameter c_data_width = 4;
    reg clock = 0;
    reg write, read;
    reg [c_addr_width-1 : 0] address;
    reg [c_data_width-1 : 0] ram_in;
    tri [c_data_width-1 : 0] ram_out;
    
    ram #(c_addr_width, c_data_width) ram (clock, write, read, address, ram_in, ram_out);
    
    initial begin
        $monitor("#%b, address: %d, ram_out: %h", clock, address, ram_out);
        
        write = 0; read = 1;
        
        #10 ram_in = 4'hE;
            address = 0;
            write = 1;
        #10 ram_in = 4'h4;
            address = 1;
        #10 write = 0;
            $writememh("memory.list", ram.ram_content);
            $finish;
    end

    always
        #5 clock = !clock;
endmodule*/
