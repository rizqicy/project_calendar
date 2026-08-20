`include "../src/fca2005.sv"

module funky_cu(
    input logic clk, rst_n,

    input logic [31:0] din,
    output logic [7:0] dout,

    output logic done_reading,
    input logic juanito_data_available,
    output logic write_result
);

typedef enum logic [2:0] { IDLE, READ, COMPUTE, DONE, SEND } state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) p_state <= IDLE;
    else p_state <= n_state;
end

logic [31:0] data_buf;

fca2005 fca2005(
        .day(data_buf[7:0]),
        .month(data_buf[15:8]),
        .year_12(data_buf[23:16]),
        .year_34(data_buf[31:24]),
        .weekday(dout)
        );

always_comb begin

    case(p_state)

        IDLE: begin
            done_reading = 1'b0;
            write_result = 1'b0;
            n_state = juanito_data_available ? READ : IDLE;
        end

        READ: begin
            data_buf = din;
            n_state = COMPUTE;
        end

        COMPUTE: begin
            //dout = 8'b10011001;
            n_state = SEND;
        end

        SEND: begin
            write_result = 1'b1;
            n_state = DONE;
        end

        DONE: begin
            done_reading = 1'b1;
            n_state = juanito_data_available ? DONE : IDLE;
        end

        default: n_state = IDLE;
    endcase
end

endmodule
