module ram_controller (
    input clk,
    input rst_n,
    input read_en,
    input write_en,
    input [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    // Constants for state encoding
    localparam IDLE = 2'b00;
    localparam INIT = 2'b01;
    localparam WRITE = 2'b10;
    localparam READ = 2'b11;

    // Internal signals
    reg [1:0] state;
    reg [7:0] memory [0:1023];

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= INIT;
        end else begin
            case (state)
                IDLE: begin
                    if (write_en) begin
                        state <= WRITE;
                    end else if (read_en) begin
                        state <= READ;
                    end
                end
                WRITE: begin
                    memory[address] <= data_in;
                    state <= IDLE;
                end
                READ: begin
                    data_out <= memory[address];
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule

