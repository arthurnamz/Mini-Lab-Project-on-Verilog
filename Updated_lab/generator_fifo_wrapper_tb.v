`timescale 1ns/1ns

module generator_fifo_wrapper_tb;

    // Parameters
    parameter DATA_SIZE = 32;

    // Input ports
    reg m00_axis_aclk = 0;
    reg m00_axis_aresetn;
    reg m00_axis_enable;
    reg m00_axis_tready;

    // Output ports
    wire [DATA_SIZE-1:0]  m00_axis_tdata;
    wire [(DATA_SIZE/8)-1 : 0] m00_axis_tstrb;
    wire m00_axis_tvalid;
    wire m00_axis_tlast;

    // Instantiate the DUT
    generator_fifo_wrapper #(
        .DATA_SIZE(DATA_SIZE)
    ) dut (
        .m00_axis_aclk(m00_axis_aclk),
        .m00_axis_aresetn(m00_axis_aresetn),
        .m00_axis_enable(m00_axis_enable),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready)
    );

    // Clock generation
    always #15 m00_axis_aclk = ~m00_axis_aclk;

    // Reset generation
    initial begin
        #2;
        m00_axis_aresetn = 0;
        #100;
        m00_axis_aresetn = 1;
    end

    // Test stimulus
    initial begin
        #20
        m00_axis_enable = 1;
        m00_axis_tready = 1;

        #50
        m00_axis_enable = 0;
        m00_axis_tready = 0;

        #500;
        $finish;
    end

endmodule

