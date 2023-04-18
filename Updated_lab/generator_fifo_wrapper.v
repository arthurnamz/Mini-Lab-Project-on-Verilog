module generator_fifo_wrapper #
(
    parameter DATA_SIZE = 32,
    parameter ADDR_WIDTH = 12,
    parameter C_AXIS_TDATA_WIDTH = 32
)
(
    input aclk,
    input aresetn,
    input enable,

    output [DATA_SIZE-1:0] data_out,
    output  valid,

    input ready,

    input  wire                 s00_axis_aclk,
    input  wire                 s00_axis_aresetn,
    input wire [C_AXIS_TDATA_WIDTH-1:0]  s00_axis_tdata,
    input wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
    input  wire                   s00_axis_tvalid,
    output wire              s00_axis_tready,
    input  wire                s00_axis_tlast,

    input wire                  m00_axis_aclk,
    input  wire                 m00_axis_aresetn,
    output wire [C_AXIS_TDATA_WIDTH-1:0] m00_axis_tdata,
    output wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
    output wire              m00_axis_tvalid,
    input  wire                 m00_axis_tready,
    output wire              m00_axis_tlast
);

wire [DATA_SIZE-1:0] gen_data_out;
wire gen_valid;

// generator instantiation 
generator #(
    .DATA_SIZE(DATA_SIZE)
) gen (
    .aclk(aclk),
    .aresetn(aresetn),
    .enable(enable),
    .data_out(data_out),
    .valid(valid),
    .ready(ready)
);

axis_fifo #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .C_AXIS_TDATA_WIDTH(C_AXIS_TDATA_WIDTH)
) fifo (
    .s00_axis_aclk(s00_axis_aclk),
    .s00_axis_aresetn(s00_axis_aresetn),
    .s00_axis_tdata(s00_axis_tdata),
    .s00_axis_tstrb(s00_axis_tstrb),
    .s00_axis_tvalid(s00_axis_tvalid),
    .s00_axis_tready(s00_axis_tready),
    .s00_axis_tlast(s00_axis_tlast),
    .m00_axis_aclk(m00_axis_aclk),
    .m00_axis_aresetn(m00_axis_aresetn),
    .m00_axis_tdata(m00_axis_tdata),
    .m00_axis_tstrb(m00_axis_tstrb),
    .m00_axis_tvalid(m00_axis_tvalid),
    .m00_axis_tready(m00_axis_tready),
    .m00_axis_tlast(m00_axis_tlast)
);
assign data_out = gen_data_out;
assign s00_axis_tdata = data_out;
assign m00_axis_tvalid = gen_valid;
assign s00_axis_tvalid = m00_axis_tvalid;
assign valid = s00_axis_tvalid;



endmodule

