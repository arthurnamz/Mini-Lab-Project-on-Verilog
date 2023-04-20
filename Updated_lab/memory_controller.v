module memory_controller #(
  // Parameter declarations
  parameter MEM_SIZE = 4096,
  parameter ADDR_WIDTH = 12,
  parameter DATA_WIDTH = 32

)

(
  // Slave input ports
  input s01_axis_aclk,
  input s01_axis_aresetn,
  input [DATA_WIDTH-1:0] s01_axis_tdata,
  input [(DATA_WIDTH/8)-1:0] s01_axis_tstrb,
  input s01_axis_tvalid,
  input s01_axis_tlast,
  output reg s01_axis_tready,

  // Master output ports
  input m01_axis_aclk,
  input m01_axis_aresetn,
  input m01_axis_tready,
  output reg [DATA_WIDTH-1:0] m01_axis_tdata,
  output reg [(DATA_WIDTH/8)-1:0] m01_axis_tstrb,
  output reg m01_axis_tvalid,
  output reg m01_axis_tlast
);

  // Internal registers 
  reg [ADDR_WIDTH-1:0] wr_address_counter;
  reg [ADDR_WIDTH-1:0] rd_address_counter;
  reg [DATA_WIDTH-1:0] mem[MEM_SIZE-1:0];
  reg [1:0] state;
  
  // State machine states
  localparam IDLE = 2'b00;
  localparam WRITE = 2'b01;
  localparam READ = 2'b10;

  // State machine logic
 always @(posedge s01_axis_aclk or posedge m01_axis_aclk) begin
        if (~s01_axis_aresetn) begin
            wr_address_counter <= 12'b0;
            s01_axis_tready <= 1'b0;
            state <= IDLE;
        end else if(~m01_axis_aresetn) begin
          rd_address_counter <= 12'b0;
          state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (s01_axis_tvalid && s01_axis_tstrb && s01_axis_tlast) begin
                      state <= WRITE;
                    end else if (m01_axis_tready) begin
                        state <= READ;
                    end
                end
                WRITE: begin
                    mem[wr_address_counter] <= s01_axis_tdata;
                    wr_address_counter <= wr_address_counter + 1;
                    s01_axis_tready <= 1'b1;
                    state <= IDLE;
                end
                READ: begin
                    m01_axis_tdata <= mem[rd_address_counter];
                    m01_axis_tstrb <= 1'b1;
                    m01_axis_tvalid <= 1'b1;
                    m01_axis_tlast <= 1'b1;
                    rd_address_counter <= rd_address_counter + 1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule