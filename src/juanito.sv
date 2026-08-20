// Juanito is our middleman handling the UART data.
// He is very happy to wrok with Funky and UART.

module juanito(
    input logic rst_n, clk,

    // from-to UART
    input logic uart_data_valid,
    input logic [7:0] din,
    output logic read_enable,
    // from-to FUNKY
    input logic funky_read,
    output logic juanito_data_available,
    output logic [31:0] data
);

typedef enum logic [2:0] { IDLE, READ, TRANSITION, WAIT, DONE } state;
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
            cnt = 0;
            read_enable = 1'b0;
            juanito_data_available = 1'b0;
            data = '0;
            juanito_buffer = '0;
            n_state = uart_data_valid ? READ : IDLE;
        end

        READ: begin
            read_enable = 1'b1;

            case (cnt)
                2'd0: juanito_buffer [7:0] = din;
                2'd1: juanito_buffer [15:8] = din;
                2'd2: juanito_buffer [23:16] = din;
                2'd3: juanito_buffer [31:24] = din;
                default: juanito_buffer = '0;
            endcase

         //   if(uart_data_valid) begin
         //           n_state = READ;
         //   end
         //   else begin
         //       cnt = cnt + 1'b1;
         //       n_state = |cnt ? WAIT : DONE;  //cnt = 2'b00 (we collected 4 data)
         //   end
            n_state = TRANSITION;
        end
        TRANSITION: begin
            if(uart_data_valid) begin
                    n_state = TRANSITION;
            end
            else begin
                cnt = cnt + 1'b1;
                n_state = |cnt ? WAIT : DONE;  //cnt = 2'b00 (we collected 4 data)
            end
        end
        WAIT: begin
            read_enable = 1'b0;
            n_state = uart_data_valid ? READ : WAIT;
        end

        DONE: begin
            read_enable = 1'b0;
            juanito_data_available = 1'b1;
            cnt = 2'b00;
            data = juanito_buffer;
            n_state = funky_read ? IDLE : DONE;
        end
        default: n_state = IDLE;
    endcase
end

endmodule
