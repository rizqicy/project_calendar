module mod4 (
    input logic [7:0] num_in,
    output logic [7:0] mod4_out
);

    assign mod4_out = num_in & 8'b00000011;
    
endmodule