`timescale 1ns/1ns

module generator_fifo_wrapper_tb;

    // Parameters
    parameter DATA_SIZE = 32;
    parameter ADDR_WIDTH = 12;
    parameter C_AXIS_TDATA_WIDTH = 32;

    // Inputs
    reg aclk = 0;
    reg aresetn;
    reg enable;
    reg s00_axis_aclk = 0;
    reg s00_axis_aresetn;
    wire [C_AXIS_TDATA_WIDTH-1:0]  s00_axis_tdata;
    wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb;
    wire s00_axis_tready;
    reg s00_axis_tlast;
    reg m00_axis_aclk = 0;
    reg m00_axis_aresetn;
    reg m00_axis_tready;

    // Outputs
    wire [DATA_SIZE-1:0] data_out;
    wire valid;
    reg ready;
    wire [C_AXIS_TDATA_WIDTH-1:0] m00_axis_tdata;
    wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb;
    wire m00_axis_tvalid;
    wire m00_axis_tlast;

    // Instantiate the DUT
    generator_fifo_wrapper #(
        .DATA_SIZE(DATA_SIZE),
        .ADDR_WIDTH(ADDR_WIDTH),
        .C_AXIS_TDATA_WIDTH(C_AXIS_TDATA_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .enable(enable),
        .data_out(data_out),
        .valid(valid),
        .ready(ready),
        .s00_axis_aclk(s00_axis_aclk),
        .s00_axis_aresetn(s00_axis_aresetn),
        .s00_axis_tready(s00_axis_tready),
        .s00_axis_tdata(s00_axis_tdata),
        .s00_axis_tstrb(s00_axis_tstrb),
        .s00_axis_tlast(s00_axis_tlast),
        .m00_axis_aclk(m00_axis_aclk),
        .m00_axis_aresetn(m00_axis_aresetn),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready)
    );

    // Clock generation
    always #5 aclk = ~aclk;
    always #10 s00_axis_aclk = ~s00_axis_aclk;
    always #15 m00_axis_aclk = ~m00_axis_aclk;

    // Reset generation
    initial begin
        aresetn = 0;
        s00_axis_aresetn = 0;
        m00_axis_aresetn = 0;
        #100;
        aresetn = 1;
        s00_axis_aresetn = 1;
        m00_axis_aresetn = 1;
    end

    // Test stimulus
    initial begin
        #20
        enable = 1;
        ready = 1;
        s00_axis_tvalid = 1;
        #2 m00_axis_tready = 0;
        #50;
        s00_axis_tlast = 1;
        enable = 0;
        ready = 0;
        s00_axis_tvalid = 0;
        #70;
        m00_axis_tready = 1;
        #1000;
        #2 m00_axis_tready = 0;
        enable = 1;
        ready = 1;
        s00_axis_tvalid = 1;
        #50;
         s00_axis_tlast = 1;
        enable = 0;
        ready = 0;
        s00_axis_tvalid = 0;
        #70;
        m00_axis_tready = 1;
        
        #500;
        $finish;
    end

endmodule

