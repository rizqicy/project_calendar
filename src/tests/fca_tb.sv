//`include "../src/fca.sv"

module fca_tb ();


logic [7:0] day;
logic [7:0] month;
logic [7:0] year_12, year_34;
logic [7:0] weekday, weekday_ref;

//Year: first_digit, second_digit
integer one_two, one_three, one_four, one_six;
integer two_one;

integer fail, pass;
fail = 0;
pass = 0;


//TODO: Add dut

task automatic reference_model (
    input logic [7:0] day,
    input logic [7:0] month,
    input logic [7:0] year_12, 
    input logic [7:0] year_34,
    output logic [7:0] weekday_ref
);

    

    //0: Sunday
    //1: Monday
    //2: Tuesday
    //3: Wednesday
    //4: Thursday
    //5: Friday
    //6: Saturday
    logic [7:0] result;

    //Step 1.2
    one_two = year_34 >> 2;

    //Step 1.3
    one_three = one_two + year_34;

    //Step 1.4
    one_four = one_three % 7;

    //Step 1.6
    one_six = year_12 % 4;

    //Step 1.8
    case (one_six)
        2'b00: one_four = one_four;
        2'b01: one_four = one_four + 5;
        2'b10: one_four = one_four + 3;
        2'b11: one_four = one_four + 1;
    endcase

    //Step 2.1
    case (month)
        4'b0001: two_one = 6;
        4'b0010: two_one = 2;
        4'b0011: two_one = 2;
        4'b0100: two_one = 5;
        4'b0101: two_one = 0;
        4'b0110: two_one = 3;
        4'b0111: two_one = 5;
        4'b1000: two_one = 1;
        4'b1001: two_one = 4;
        4'b1010: two_one = 6;
        4'b1011: two_one = 2;
        4'b1100: two_one = 4;
        default: two_one = 0;
    endcase

    //Step 2.2
    if (((year_34 % 4 == 0 &&  year_34 != 0) || (year_34 == 2'd00 && year_12 % 4 == 0)) && (month == 8'd1 || month == 8'd2 ) begin
        two_one--;
    end

    //Step 3
    result = (day + two_one + one_four) % 7;

    //Write to output
    weekday_ref = result;
endtask

//Compare result
initial begin
    for (int d = 0; d < 27; d++) begin
        for (int m = 1; m < 13; m++) begin
            for (int y12 = 16; y12 < 22 ; y12++) begin
                for (int y34 = 0; y34 < 100; y34++) begin
                    day = d;
                    month = m;
                    year_12 = y12;
                    year_34 = y34;

                    reference_model(
                        day,
                        month,
                        year_12,
                        year_34,
                        weekday_ref
                    );

                    if (weekday_ref == weekday) begin
                        pass++;
                    end else begin
                        fail++;
                        
                        $display("Failed at : %0d,%0d,%2d%2d", d,m,y12,y34);
                    end

                    $display ( " Pass : %0 d " , pass );
                    $display ( " Fail : %0 d " , fail );
                end
            end
        end
    end
    


end


endmodule