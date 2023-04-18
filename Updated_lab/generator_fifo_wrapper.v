module generator_fifo_wrapper #
(
    parameter DATA_SIZE = 32
)
(
    // Input ports
    input m00_axis_aclk,
    input m00_axis_aresetn,
    input m00_axis_enable,
    input m00_axis_tready,

    // Output ports
    output reg [DATA_SIZE-1:0]  m00_axis_tdata,
    output reg [(DATA_SIZE/8)-1 : 0] m00_axis_tstrb,
    output  reg m00_axis_tvalid,
    output  reg m00_axis_tlast
);

wire [DATA_SIZE-1:0]  connect_s00_axis_tdata;
wire [(DATA_SIZE/8)-1 : 0] connect_s00_axis_tstrb
wire connect_s00_axis_tvalid;
wire connect_s00_axis_tlast;
wire connect_m00_axis_tready;

// generator instantiation 
generator #(
    .DATA_SIZE(DATA_SIZE)
) gen (
    .m00_axis_aclk(m00_axis_aclk),
    .m00_axis_aresetn(m00_axis_aresetn),
    .m00_axis_enable(m00_axis_enable),
    .m00_axis_tready(connect_m00_axis_tready),
    .m00_axis_tdata(connect_s00_axis_tdata),
    .m00_axis_tstrb(connect_s00_axis_tstrb),
    .m00_axis_tvalid(connect_s00_axis_tvalid),
    .m00_axis_tlast(connect_s00_axis_tlast)
);

axis_fifo #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .C_AXIS_TDATA_WIDTH(C_AXIS_TDATA_WIDTH)
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

