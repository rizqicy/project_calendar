// Juanito is our middleman handling the UART data.
// He is very happy to wrok with Funky and UART.

module juanito(
    input logic rst_n, clk,
    input logic data_valid, funky_read,
    input logic [7:0] di,
    output logic data_ready, read_enable,
    output logic [31:0] data
);

typedef enum logic [1:0] { IDLE, READ, WAIT, DONE } state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) p_state <= IDLE;
    else p_state <= n_state;
end

logic [31:0] juanito_buffer;
logic [1:0] cnt;

always_comb begin
    case (p_state)

        IDLE: begin
            read_enable = 1'b0;
            data_ready = 1'b0;
            data = 0';
            juanito_buffer = 0';
            n_state = data_valid ? READ : IDLE;
        end

        READ: begin
            read_enable = 1'b1;
            cnt = cnt + 1'b1;

            case (cnt):
                2'd0: juanito_buffer [7:0] = di;
                2'd1: juanito_buffer [15:8] = di;
                2'd2: juanito_buffer [23:16] = di;
                2'd3: juanito_buffer [31:24] = di;
                default: juanito_buffer = 0';
            endcase

            n_state = &cnt ? DONE : WAIT;
        end

        WAIT: begin
            read_enable = 1'b0;
            n_state = data_valid ? READ : WAIT;
        end

        DONE: begin
            read_enable = 1'b0;
            data_ready = 1'b1;
            cnt = 2'b00;
            data = juanito_buffer;
            n_state = funky_read ? IDLE : DONE;
        end

        default:
    endcase
end

endmodule