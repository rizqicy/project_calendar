`include "../src/chklpyr.sv"
`include "../src/lut_month.sv"
`include "../src/lut_year.sv"
`include "../src/mod4.sv"
`include "../src/mod7.sv"

module fca2005 (
    input logic [7:0] day,
    input logic [7:0] month,
    input logic [7:0] year_12, //the first part of a year, so 2005 becomes 20
    input logic [7:0] year_34, //05

    output logic [7:0] weekday //0 is sunday
);


    //// DO THE MONTH number
    logic [7:0] lut_month_wire, month_number;
    logic is_leap_year_wire;

    lut_month lut_month (
    .month  (month),
    .month_lut (lut_month_wire)
    );

    chklpyr chklpyr (
    .year_12  (year_12),
    .year_34  (year_34),
    .is_leap_year (is_leap_year_wire)
    );

    always_comb begin 
        if(is_leap_year_wire == 1'b1 && (month == 8'd1 || month == 8'd2)) begin
            month_number = lut_month_wire - 8'd1;
        end else begin
            month_number = lut_month_wire;
        end
    end    

    //DO THE YEAR number
    logic [7:0] year_34_div4, year_34_sum, year_34_sum_mod7, year_12_mod4, year_12_lut, year_number;

    mod7 mod7_year (
        .num_in(year_34_sum),
        .mod_out(year_34_sum_mod7)
    );

    mod4 mod4_year (
        .num_in(year_12),
        .mod4_out(year_12_mod4)
    );

    lut_year lut_yearr (
        .year_12(year_12_mod4),
        .year_12_lut(year_12_lut)
    );

    always_comb begin
        year_34_div4 = year_34 >> 8'd2;
        year_34_sum = year_34_div4 + year_34;
        
        year_number = year_34_sum_mod7 + year_12_lut;
    end

    //// DO THE LAST NUMBER DAY!!!

    logic [7:0] total_sum, result;

    mod7 mod7_total (
        .num_in(total_sum),
        .mod_out(result)
    );

    assign weekday = result;

    always_comb begin 
        total_sum = day + month_number + year_number;
    end



endmodule