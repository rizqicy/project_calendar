module chklpyr_tb;

    logic [7:0] year_12;
    logic [7:0] year_34;
    logic       is_leap_year;
    logic       is_leap_ref;

    // Instantiate design under test
    chklpyr dut (
        .year_12      (year_12),
        .year_34      (year_34),
        .is_leap_year (is_leap_year)
    );

    // Golden model: chklpyr implements exactly the leap-year check of the
    // reference_model task in fca_tb.sv, Step 2.2.
    task automatic reference_model (
        input  logic [7:0] year_12,
        input  logic [7:0] year_34,
        output logic       is_leap_ref
    );
        // Leap iff (divisible by 4 and not a century year) or
        // (century year, year_34 == 0, whose century is divisible by 4,
        //  i.e. the full year is divisible by 400).
        is_leap_ref = ((year_34 % 4 == 0 && year_34 != 8'd0) ||
                       (year_34 == 8'd0 && year_12 % 4 == 0));
    endtask

    // Exhaustive stimulus: all 256 x 256 (year_12, year_34) combinations
    initial begin
        integer error_count = 0;
        int y12, y34;

        for (y12 = 0; y12 < 256; y12++) begin
            for (y34 = 0; y34 < 256; y34++) begin
                year_12 = y12;
                year_34 = y34;
                #1;  // let combinational DUT outputs settle

                reference_model(year_12, year_34, is_leap_ref);

                if (is_leap_year !== is_leap_ref) begin
                    $display("ERROR: year %02d%02d -> is_leap_year = %b (Expected %b)",
                             year_12, year_34, is_leap_year, is_leap_ref);
                    error_count = error_count + 1;
                end
            end
        end

        if (error_count == 0)
            $display("Success: All 65536 (year_12, year_34) combinations passed the leap-year check.");
        else
            $display("FAILED: %0d mismatches.", error_count);
        $finish;
    end

endmodule
