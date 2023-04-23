module memory_wrapper #(
  // Parameter declarations
  parameter MEM_SIZE = 4096,
  parameter ADDR_WIDTH = 12,
  parameter DATA_WIDTH = 32
) (
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

wire [DATA_WIDTH-1:0]  connect_s02_axis_tdata;
wire [(DATA_WIDTH/8)-1 : 0] connect_s02_axis_tstrb;
wire connect_s02_axis_tvalid;
wire connect_s02_axis_tlast;
wire connect_m01_axis_tready;

memory_controller #(.DATA_WIDTH(DATA_WIDTH)) mem_controller(
        .s01_axis_aclk(s01_axis_aclk),
        .s01_axis_aresetn(s01_axis_aresetn),
        .s01_axis_tdata(s01_axis_tdata),
        .s01_axis_tstrb(s01_axis_tstrb),
        .s01_axis_tvalid(s01_axis_tvalid),
        .s01_axis_tlast(s01_axis_tlast),
        .s01_axis_tready(s01_axis_tready),

        .m01_axis_aclk(m01_axis_aclk),
        .m01_axis_aresetn(m01_axis_aresetn),
        .m01_axis_tready(m01_axis_tready),
        .m01_axis_tdata(connect_s02_axis_tdata),
        .m01_axis_tstrb(connect_s02_axis_tstrb),
        .m01_axis_tvalid(connect_s02_axis_tvalid),
        .m01_axis_tlast(connect_s02_axis_tlast)        
    );

    memory #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) mem(
        .s02_axis_aclk(s01_axis_aclk),
        .s02_axis_aresetn(s01_axis_aresetn),
        .s02_axis_wr_tdata(connect_s02_axis_tdata),
        .s02_axis_tstrb(connect_s02_axis_tstrb),
        .s02_axis_tvalid(connect_s02_axis_tvalid),
        .s02_axis_tlast(connect_s02_axis_tlast),
        .s02_axis_tready(s02_axis_tready),

        .m02_axis_aclk(m01_axis_aclk),
        .m02_axis_aresetn(m01_axis_aresetn),
        .m02_axis_tready(m01_axis_tready),
        .m02_axis_rd_tdata(m01_axis_tdata),
        .m02_axis_tstrb(m01_axis_tstrb),
        .m02_axis_tvalid(m01_axis_tvalid),
        .m02_axis_tlast(m01_axis_tlast)        
    );


endmodule