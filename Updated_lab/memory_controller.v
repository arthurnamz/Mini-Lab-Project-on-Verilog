module memory_controller (
  // Parameter declarations
  parameter MEM_SIZE = 4096,
  parameter ADDR_WIDTH = 12,
  parameter DATA_WIDTH = 32,

  // Slave input ports
  input s02_axis_aclk,
  input s02_axis_aresetn,
  input [DATA_WIDTH-1:0] s02_axis_wr_tdata,
  input [(DATA_WIDTH/8)-1:0] s02_axis_tstrb,
  input s02_axis_tvalid,
  input s02_axis_tlast,
  output reg s02_axis_tready,

  // Master output ports
  input m02_axis_aclk,
  input m02_axis_aresetn,
  input m02_axis_tready,
  output reg [DATA_WIDTH-1:0] m02_axis_rd_tdata,
  output reg [(DATA_WIDTH/8)-1:0] m02_axis_tstrb,
  output reg m02_axis_tvalid,
  output reg m02_axis_tlast
);

  // Internal registers and wires
  reg [ADDR_WIDTH-1:0] address_reg;
  reg [DATA_WIDTH-1:0] mem[MEM_SIZE-1:0];
  reg [1:0] state;
  wire [(DATA_WIDTH/8)-1:0] byte_enable;
  
  // State machine states
  localparam IDLE = 2'b00;
  localparam WRITE = 2'b01;
  localparam READ = 2'b10;

  // Assign byte enable signal
  assign byte_enable = s02_axis_tstrb;

  // Reset logic
  always @(posedge s02_axis_aclk) begin
    if (!s02_axis_aresetn) begin
      address_reg <= 0;
      state <= IDLE;
      s02_axis_tready <= 1'b0;
      m02_axis_rd_tdata <= 0;
      m02_axis_tstrb <= 0;
      m02_axis_tvalid <= 1'b0;
      m02_axis_tlast <= 1'b0;
    end
  end

  // State machine logic
  always @(posedge s02_axis_aclk) begin
    case (state)
      IDLE: begin
        if (s02_axis_tvalid && s02_axis_tlast && s02_axis_tready) begin
          if (byte_enable != ({(DATA_WIDTH/8){1'b1}})) begin
            // Byte enables are not all set, report an error
            m02_axis_tvalid <= 1'b1;
            m02_axis_rd_tdata <= {DATA_WIDTH{1'bx}};
            m02_axis_tlast <= 1'b1;
          end else begin
            // All byte enables are set, proceed to write
            address_reg <= s02_axis_wr_tdata[ADDR_WIDTH-1:2];
            mem[address_reg] <= s02_axis_wr_tdata;
            s02_axis_tready <= 1'b1;
            state <= IDLE;
          end
        end else begin
          s02_axis_tready <= 1'b1;
        end
      end
      WRITE: begin
        // Wait for the last write transaction to complete
        if (s02_axis_tvalid && s02_axis_tlast && s02_axis_tready) begin
          s02_axis_tready <= 1'b0;
          state <= IDLE;
        end else begin
          s02_axis_tready <= 1'b1;
          state <= WRITE;
        end
      end
      READ: begin
        // Wait for the read transaction to complete
            if (m02_axis_tready && m02_axis_tvalid && m02_axis_tlast) begin
                s02_axis_tready <= 1'b0;
                m02_axis_tvalid <= 1'b0;
                m02_axis_tlast <= 1'b0;
                state <= IDLE;
            end else begin
                s02_axis_tready <= 1'b0;
                m02_axis_tvalid <= 1'b1;
                m02_axis_rd_tdata <= mem[address_reg];
                m02_axis_tstrb <= {(DATA_WIDTH/8){1'b1}};
                m02_axis_tlast <= (address_reg == (MEM_SIZE-1)) ? 1'b1 : 1'b0;
                state <= READ;
            end
     end
 endcase
end

endmodule