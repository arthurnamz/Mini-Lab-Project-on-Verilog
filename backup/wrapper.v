module memory_fifo_wrapper (
  input clk,           // clock signal
  input rst,           // reset signal
  input [15:0] addr,   // memory address
  input [7:0] data_in, // data input to memory
  output [7:0] data_out, // data output from memory
  input write_en,      // write enable signal
  input read_en        // read enable signal
  
  // AXI Stream FIFO signals
  input wire s00_axis_aclk,
  input wire s00_axis_aresetn,
  input wire [C_AXIS_TDATA_WIDTH-1:0] s00_axis_tdata,
  input wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
  input wire s00_axis_tvalid,
  output wire s00_axis_tready,
  input wire s00_axis_tlast,
  output wire [C_AXIS_TDATA_WIDTH-1:0] m00_axis_tdata,
  output wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
  output wire m00_axis_tvalid,
  input wire m00_axis_tready,
  input wire m00_axis_tlast
);

  // instantiate a memory module and a memory controller
  memory_module memory_module_inst(
    .clk(clk),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out),
    .write_en(write_en),
    .read_en(read_en)
  );
  
  memory_controller memory_controller_inst(
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out),
    .write_en(write_en),
    .read_en(read_en)
  );

  // instantiate an AXI Stream FIFO
  axis_fifo #(
    .ADDR_WIDTH(12),
    .C_AXIS_TDATA_WIDTH(32)
  ) fifo_inst (
    .s00_axis_aclk(s00_axis_aclk),
    .s00_axis_aresetn(s00_axis_aresetn),
    .s00_axis_tdata(s00_axis_tdata),
    .s00_axis_tstrb(s00_axis_tstrb),
    .s00_axis_tvalid(s00_axis_tvalid),
    .s00_axis_tready(s00_axis_tready),
    .s00_axis_tlast(s00_axis_tlast),
    .m00_axis_aclk(clk),
    .m00_axis_aresetn(rst),
    .m00_axis_tdata(m00_axis_tdata),
    .m00_axis_tstrb(m00_axis_tstrb),
    .m00_axis_tvalid(m00_axis_tvalid),
    .m00_axis_tready(m00_axis_tready),
    .m00_axis_tlast(m00_axis_tlast)
  );

endmodule
