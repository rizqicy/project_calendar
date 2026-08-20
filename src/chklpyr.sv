`include "../src/mod4.sv"

module chklpyr (
    input logic [7:0] year_12,
    input logic [7:0] year_34,
    output logic is_leap_year
);

    wire [7:0] mod4_year12, mod4_year34;
    
    mod4 mod4_12 (
    .num_in  (year_12),
    .mod4_out (mod4_year12)
    );

    mod4 mod4_34 (
    .num_in  (year_34),
    .mod4_out (mod4_year34)
    );

    always_comb begin
        //check if it is divisible by 4 and not by 100  check if it is divisible by 400
        if ((mod4_year34 == 8'd0 && year_34 != 8'd0) || (year_34 == 8'd0 && mod4_year12 == 8'd0)) begin
           is_leap_year = 1'b1; 
        end else begin
            is_leap_year = 1'b0;
        end
    end

endmodule