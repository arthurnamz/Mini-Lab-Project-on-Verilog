module main_wrapper #(
  // Parameter declarations
  parameter MEM_SIZE = 64,
  parameter ADDR_WIDTH = 12,
  parameter DATA_WIDTH = 32
) (
  // slave ports
    input  s03_axis_aclk,
    input  s03_axis_aresetn,
    input  s03_axis_enable,
    output s03_axis_tready,
   

    // master ports
    input  m03_axis_aclk,
    input  m03_axis_aresetn,
    input  m03_axis_tready,
    output  wire [DATA_WIDTH-1:0]  m03_axis_tdata,
    output  wire [(DATA_WIDTH/8)-1 : 0] m03_axis_tstrb,
    output  wire m03_axis_tvalid,
    output  wire m03_axis_tlast
);

// wires
wire [DATA_WIDTH-1:0]  connect_s03_axis_tdata;
wire [(DATA_WIDTH/8)-1 : 0] connect_s03_axis_tstrb;
wire connect_s03_axis_tvalid;
wire connect_s03_axis_tlast;
wire connect_m00_axis_tready;

// Instantiate the DUT
    generator_fifo_wrapper #(
        .ADDR_WIDTH(ADDR_WIDTH), .DATA_SIZE(DATA_WIDTH)
    ) gen_fifo_wrapper (
        .m00_axis_aclk(s03_axis_aclk),
        .m00_axis_aresetn(s03_axis_aresetn),
        .m00_axis_enable(s03_axis_enable),
        .m00_axis_tdata(connect_s03_axis_tdata),
        .m00_axis_tstrb(connect_s03_axis_tstrb),
        .m00_axis_tvalid(connect_s03_axis_tvalid),
        .m00_axis_tlast(connect_s03_axis_tlast),
        .m00_axis_tready(connect_m00_axis_tready)
    );

    memory_wrapper #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) mem_wrapper(
        .s01_axis_aclk(s03_axis_aclk),
        .s01_axis_aresetn(s03_axis_aresetn),
        .s01_axis_tdata(connect_s03_axis_tdata),
        .s01_axis_tstrb(connect_s03_axis_tstrb),
        .s01_axis_tvalid(connect_s03_axis_tvalid),
        .s01_axis_tlast(connect_s03_axis_tlast),
        .s01_axis_tready(connect_m00_axis_tready),

        .m01_axis_aclk(m03_axis_aclk),
        .m01_axis_aresetn(m03_axis_aresetn),
        .m01_axis_tready(m03_axis_tready),
        .m01_axis_tdata(m03_axis_tdata),
        .m01_axis_tstrb(m03_axis_tstrb),
        .m01_axis_tvalid(m03_axis_tvalid),
        .m01_axis_tlast(m03_axis_tlast)        
    );
    endmodule

