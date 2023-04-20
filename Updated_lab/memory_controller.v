module memory_controller #(
    // Parameter declarations
    parameter MEM_SIZE = 4096, 
    parameter ADDR_WIDTH = 12, 
    parameter DATA_WIDTH = 32
)
(
    // slave input ports
    input s01_axis_aclk,
    input s01_axis_aresetn,
    input [DATA_WIDTH-1:0] s01_axis_tdata,
    input [(DATA_WIDTH/8)-1:0] s01_axis_tstrb,
    input s01_axis_tvalid,
    input s01_axis_tlast,
    output reg s01_axis_tready,
    // master output port
    input m01_axis_aclk,
    input m01_axis_aresetn,
    input m01_axis_tready,
    output reg [DATA_WIDTH-1:0] m01_axis_tdata,
    output reg [(DATA_WIDTH/8)-1:0] m01_axis_tstrb,
    output reg m01_axis_tvalid,
    output reg m01_axis_tlast
);

    // Internal signal declarations
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
    reg [ADDR_WIDTH-1:0] wr_addr_counter;
    reg [ADDR_WIDTH-1:0] rd_addr_counter;

    // Write operation
    always @(posedge s01_axis_aclk) begin
        if (~s01_axis_aresetn) begin
            wr_addr_counter <= 0;
            s01_axis_tready <= 0;
        end else if (s01_axis_tvalid && s01_axis_tlast && s01_axis_tstrb) begin
            mem[wr_addr_counter] <= s01_axis_tdata;
            wr_addr_counter <= wr_addr_counter + 1;
            s01_axis_tready <= 1;
        end else begin
            s01_axis_tready <= 0;
        end
    end

    // Read operation
    always @(posedge m01_axis_aclk) begin
        if (~m01_axis_aresetn) begin
            rd_addr_counter <= 0;
            m01_axis_tdata <= 0;
            m01_axis_tstrb <= 0;
            m01_axis_tvalid <= 0;
            m01_axis_tlast <= 0;
        end else if (m01_axis_tready) begin
            m01_axis_tdata <= mem[rd_addr_counter];
            m01_axis_tstrb <= {(DATA_WIDTH/8){1'b1}};
            m01_axis_tvalid <= 1'b1;
            m01_axis_tlast <= (rd_addr_counter == (MEM_SIZE-1));
            rd_addr_counter <= rd_addr_counter + 1;
        end
    end

endmodule




// module memory_controller #(
//   // Parameter declarations
//   parameter MEM_SIZE = 4096,
//   parameter ADDR_WIDTH = 12,
//   parameter DATA_WIDTH = 32
// ) (
//   // Slave input ports
//   input s01_axis_aclk,
//   input s01_axis_aresetn,
//   input [DATA_WIDTH-1:0] s01_axis_tdata,
//   input [(DATA_WIDTH/8)-1:0] s01_axis_tstrb,
//   input s01_axis_tvalid,
//   input s01_axis_tlast,
//   output reg s01_axis_tready,

//   // Master output ports
//   input m01_axis_aclk,
//   input m01_axis_aresetn,
//   input m01_axis_tready,
//   output reg [DATA_WIDTH-1:0] m01_axis_tdata,
//   output reg [(DATA_WIDTH/8)-1:0] m01_axis_tstrb,
//   output reg m01_axis_tvalid,
//   output reg m01_axis_tlast
// );

//   // Internal registers 
//   reg [ADDR_WIDTH-1:0] wr_address_counter = 0;
//   reg [ADDR_WIDTH-1:0] rd_address_counter = 0;
//   reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
//   reg [1:0] state;

//   // State machine states
//   localparam IDLE = 2'b00;
//   localparam WRITE = 2'b01;
//   localparam READ = 2'b10;

//   // State machine logic
//   always @(posedge s01_axis_aclk or posedge m01_axis_aclk) begin
//     if (~s01_axis_aresetn) begin
//       wr_address_counter <= 0;
//       s01_axis_tready <= 0;
//       state <= IDLE;
//     end else if (~m01_axis_aresetn) begin
//       rd_address_counter <= 0;
//       state <= IDLE;
//     end else begin
//       case (state)
//         IDLE: begin
//           if (s01_axis_tvalid && s01_axis_tstrb && s01_axis_tlast) begin
//             state <= WRITE;
//           end else if (m01_axis_tready) begin
//             state <= READ;
//           end
//         end
//         WRITE: begin
//           mem[wr_address_counter] <= s01_axis_tdata;
//           wr_address_counter <= wr_address_counter + 1;
//           s01_axis_tready <= 1;
//           state <= IDLE;
//         end
//         READ: begin
//           m01_axis_tdata <= mem[rd_address_counter];
//           rd_address_counter <= rd_address_counter + 1;
//           m01_axis_tstrb <= 1;
//           m01_axis_tvalid <= 1;
//           m01_axis_tlast <= 1;
//           state <= IDLE;
//         end
//         default: begin
//           state <= IDLE;
//         end
//       endcase
//     end
//   end
// endmodule

