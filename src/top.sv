`include "../src/simpleuart.v"
`include "../src/juanito.sv"
`include "../src/funky_cu.sv"

module top(
        input logic clk,
        input logic  rst_n,

        input logic rx,
        output logic tx
        );

logic [31:0] dat_do;
logic uart_recv_valid;
logic read_enable_uart;

logic read_from_funky, data_ready;
logic [7:0] data_out;
logic [31:0] data_to_funky;


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

    // from-to UART
    .uart_data_valid(uart_recv_valid),
    .read_enable(read_enable_uart),
    .din(dat_do[7:0]),

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

endmodule
