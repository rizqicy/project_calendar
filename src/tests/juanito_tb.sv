module juanito_tb();

logic clk, rst_n, buf_valid, read_from_funky, data_ready, read_enable_uart;
logic [7:0] di;
logic [31:0] data_to_funky;

juanito middleman(
    .clk(clk),
    .rst_n(rst_n),
    .uart_data_valid(buf_valid),
    .funky_read(read_from_funky),
    .din(di),
    .funky_data_ready(data_ready),
    .read_enable(read_enable_uart),
    .data(data_to_funky)
);

always
    #10 clk = ~clk;


initial begin
    clk = 0;
    rst_n = 1'b0;
    buf_valid = 0;
    #25;

    rst_n = 1'b1;

    di = 8'd11;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    di = 8'd10;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    di = 8'd9;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    di = 8'd8;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    read_from_funky = 1'b1;
    #20;

    $finish;
end

endmodule
