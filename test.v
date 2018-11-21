module concat_assign;
    reg [4:0]foo;
    
    assign a = foo[1,5,7];
    foo foo (a, b);
    
    
    initial begin
        mreg = 1;
        $display("%b %b", a, b);
    end
    
endmodule
