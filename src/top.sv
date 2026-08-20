`include "../src/simpleuart.v"
`include "../src/juanito.sv"

module top(
        input logic clk,
        input logic  rst_n,

        input logic rx,
        output logic tx
        );

logic [31:0] dat_do;
logic uart_recv_valid;
logic read_enable_uart;


simpleuart uart(
	.clk(clk),
	.resetn(rst_n),

	.ser_tx(tx),
	.ser_rx(rx),

	//input   [3:0] reg_div_we,
//	input  [31:0] reg_div_di,
//	output [31:0] reg_div_do,

	//.reg_dat_we(),
	.reg_dat_re(read_enable_uart),
	//.reg_dat_di(),
        .reg_dat_do(dat_do),
	//.reg_dat_wait(),
        .buf_valid(uart_recv_valid)
);

juanito middleman(
    .clk(clk),
    .rst_n(rst_n),
    .uart_data_valid(uart_recv_valid),
    .funky_read(read_from_funky),
    .din(dat_do[7:0]),
    .juanito_data_available(data_ready),
    .read_enable(read_enable_uart),
    .data(data_to_funky)
);

endmodule
