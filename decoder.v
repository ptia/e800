module decoder (i_encoded, o_decoded);
    parameter c_input_width = 1;
    input wire [c_input_width-1 : 0] i_encoded;
    output wire [2**c_input_width-1 : 0] o_decoded;
    
    assign o_decoded = 1 << (i_encoded);
endmodule
