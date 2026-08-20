module lut_year (
    input logic [7:0] year_12,
    output logic [7:0] year_12_lut
);

    always_comb begin
        case (year_12)
            8'd0 : year_12_lut = 8'd0;
            8'd1 : year_12_lut = 8'd5;
            8'd2 : year_12_lut = 8'd3;
            8'd3 : year_12_lut = 8'd1; 
            default: year_12_lut = 8'd0;
        endcase
    end
    
endmodule