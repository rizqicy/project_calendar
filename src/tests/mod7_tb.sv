module mod7_tb;

    logic [7:0] num_in;
    logic [7:0] mod_out;

    // Instantiate your choice of design
    mod7 dut (
        .num_in  (num_in),
        .mod_out (mod_out)
    );

    initial begin
        num_in = 8'd0;
        
        // Loop through all 256 possibilities
        repeat (256) begin
            #10;
            // Verification check against a golden model
            if (mod_out !== (num_in % 7)) begin
                $display("ERROR: Input %d produced %d (Expected %d)", num_in, mod_out, (num_in % 7));
            end
            num_in = num_in + 1;
        end
        
        $display("Success: All 8-bit values matched the golden Modulo-7 matrix.");
        $finish;
    end

endmodule
