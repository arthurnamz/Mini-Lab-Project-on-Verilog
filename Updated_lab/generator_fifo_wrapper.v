module generator_fifo_wrapper #
(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 32
)
(
    // Input ports
    input wire m00_axis_aclk,
    input wire m00_axis_aresetn,
    input wire enable,
    input wire m00_axis_tready,

    // Output ports
    output  wire [DATA_WIDTH-1:0]  m00_axis_tdata,
    output  wire [(DATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
    output  wire m00_axis_tvalid,
    output  wire m00_axis_tlast
);

wire [DATA_WIDTH-1:0]  connect_s00_axis_tdata;
wire [(DATA_WIDTH/8)-1 : 0] connect_s00_axis_tstrb;
wire connect_s00_axis_tvalid;
wire connect_s00_axis_tlast;
wire connect_m00_axis_tready;

// generator instantiation 
generator #(
    .DATA_WIDTH(DATA_WIDTH)
) gen (
    .m00_axis_aclk(m00_axis_aclk),
    .m00_axis_aresetn(m00_axis_aresetn),
    .enable(enable),
    .m00_axis_tready(connect_m00_axis_tready),
    .m00_axis_tdata(connect_s00_axis_tdata),
    .m00_axis_tstrb(connect_s00_axis_tstrb),
    .m00_axis_tvalid(connect_s00_axis_tvalid),
    .m00_axis_tlast(connect_s00_axis_tlast)
);

axis_fifo #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .C_AXIS_TDATA_WIDTH(DATA_WIDTH)
) fifo (
    .s00_axis_aclk(m00_axis_aclk),
    .s00_axis_aresetn(m00_axis_aresetn),
    .s00_axis_tdata(connect_s00_axis_tdata),
    .s00_axis_tstrb(connect_s00_axis_tstrb),
    .s00_axis_tvalid(connect_s00_axis_tvalid),
    .s00_axis_tready(connect_m00_axis_tready),
    .s00_axis_tlast(connect_s00_axis_tlast),

    // output port
    .m00_axis_aclk(m00_axis_aclk),
    .m00_axis_aresetn(m00_axis_aresetn),
    .m00_axis_tdata(m00_axis_tdata),
    .m00_axis_tstrb(m00_axis_tstrb),
    .m00_axis_tvalid(m00_axis_tvalid),
    .m00_axis_tready(m00_axis_tready),
    .m00_axis_tlast(m00_axis_tlast)
);

endmodule

