`include "../src/juanito.sv"

module funky_cu_tb();

logic clk, rst_n, buf_valid, read_from_funky, data_ready, read_enable_uart;
logic [7:0] di, data_out;
logic [31:0] data_to_funky;

juanito middleman(
    .clk(clk),
    .rst_n(rst_n),

    // from-to UART
    .uart_data_valid(buf_valid),
    .read_enable(read_enable_uart),
    .din(di),

    // from-to FUNKY
    .funky_read(read_from_funky),
    .juanito_data_available(data_ready),
    .data(data_to_funky)
);

funky_cu funky(
    .clk(clk),
    .rst_n(rst_n),

    .din(data_to_funky),
    .dout(data_out),
    .done_reading(read_from_funky),
    .juanito_data_available(data_ready)
);

always
    #10 clk = ~clk;


initial begin
    clk = 1'b0;
    di = '0;
    rst_n = 1'b0;
    buf_valid = 1'b0;
    #25;

    rst_n = 1'b1;

    di = 8'd25;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 1'b0;
    #50;

    di = 8'd08;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    di = 8'd20;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;
    #50;

    di = 8'd01;
    buf_valid = 1'b1;
    wait(read_enable_uart)
        buf_valid = 0;

    #250;

    $finish;
end

endmodule
