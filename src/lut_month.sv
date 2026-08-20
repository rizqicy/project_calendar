module lut_month (
    input logic [7:0] month,
    output logic [7:0] month_lut
);

always_comb begin
    case (month)
        8'd1  : month_lut = 8'd6;
        8'd2  : month_lut = 8'd2;
        8'd3  : month_lut = 8'd2;
        8'd4  : month_lut = 8'd5;
        8'd5  : month_lut = 8'd0;
        8'd6  : month_lut = 8'd3;
        8'd7  : month_lut = 8'd5;
        8'd8  : month_lut = 8'd1;
        8'd9  : month_lut = 8'd4;
        8'd10 : month_lut = 8'd6;
        8'd11 : month_lut = 8'd2;
        8'd12 : month_lut = 8'd4;
        default: month_lut = 8'd0;
    endcase
end
    
endmodule