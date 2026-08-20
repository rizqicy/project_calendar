module uart_tb();

logic clk, rst_n, buf_valid, read_from_funky, data_ready, read_enable_uart;
logic [7:0] di;
logic [31:0] data_to_funky;

juanito middleman(
    .clk(clk),
    .rst_n(rst_n),
    .data_valid(buf_valid),
    .funky_read(read_from_funky),
    .di(di),
    .data_ready(data_ready),
    .read_enable(read_enable_uart),
    .data(data_to_funky)
);

initial begin
    clk = ~clk;
    #10;
end

initial begin

    rst_n = 1'b0;
    #25;

    rst_n = 1'b1;

    di = 8'd11;
    buf_valid = 1'b1;
    #50;

    di = 8'd10;
    buf_valid = 1'b1;
    #50;

    di = 8'd9;
    buf_valid = 1'b1;
    #50;

    di = 8'd8;
    buf_valid = 1'b1;
    #50;

    funky_read = 1'b1;
    #20;

    $finish
end

endmodule