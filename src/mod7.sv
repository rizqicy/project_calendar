module mod7 (
    input  logic [7:0] num_in,   // 8-bit input
    output logic [7:0] mod_out   // 3-bit output
);

    logic [4:0] sum_stage1;
    logic [3:0] sum_stage2;

    always_comb begin
        // Stage 1:
        // Weight 1: num_in[0], num_in[3], num_in[6] (max = 3)
        // Weight 2: num_in[1], num_in[4], num_in[7] (max = 3 * 2 = 6)
        // Weight 4: num_in[2], num_in[5]             (max = 2 * 4 = 8)
        // Max sum_stage1 = 3 + 6 + 8 = 17 (fits in 5 bits: 0 to 17)
        sum_stage1 = (num_in[0] + num_in[3] + num_in[6]) + 
                     ((num_in[1] + num_in[4] + num_in[7]) << 1) + 
                     ((num_in[2] + num_in[5]) << 2);

        // Stage 2:
        // For values up to 17 (5 bits: sum_stage1[4:0]):
        // Max sum_stage2: for 15 (01111_2) -> 2 + 4 + 4 = 10
        //                 for 17 (10001_2) -> 2 + 2 + 0 = 4
        // Worst-case max sum_stage2 remains <= 10.
        sum_stage2 = (sum_stage1[0] + sum_stage1[3]) +
                     ((sum_stage1[1] + sum_stage1[4]) << 1) +
                     (sum_stage1[2] << 2);

        // Final Correction: Range is 0 to 10
        if (sum_stage2 >= 4'd7) begin
            mod_out = sum_stage2 - 4'd7;
        end else begin
            mod_out = sum_stage2[2:0];
        end
    end

endmodule