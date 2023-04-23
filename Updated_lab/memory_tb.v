`timescale 1ns/1ps

module memory_tb;
    parameter PERIOD = 2; 
    parameter MEM_SIZE = 4096; 
    parameter ADDR_WIDTH = 12;
    parameter DATA_WIDTH = 32; 

    // slave input ports
    reg s02_axis_aclk = 0;
    reg s02_axis_aresetn;
    reg [DATA_WIDTH-1:0] s02_axis_wr_tdata;
    reg [(DATA_WIDTH/8)-1 : 0] s02_axis_tstrb;
    reg s02_axis_tvalid;
    reg s02_axis_tlast;
    wire s02_axis_tready;

    // master output port
    reg m02_axis_aclk = 0;
    reg m02_axis_aresetn;
    reg m02_axis_tready;
    wire [DATA_WIDTH-1:0] m02_axis_rd_tdata;
    wire [(DATA_WIDTH/8)-1 : 0] m02_axis_tstrb;
    wire m02_axis_tvalid;
    wire m02_axis_tlast;

    memory #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(
        .s02_axis_aclk(s02_axis_aclk),
        .s02_axis_aresetn(s02_axis_aresetn),
        .s02_axis_wr_tdata(s02_axis_wr_tdata),
        .s02_axis_tstrb(s02_axis_tstrb),
        .s02_axis_tvalid(s02_axis_tvalid),
        .s02_axis_tlast(s02_axis_tlast),
        .s02_axis_tready(s02_axis_tready),

        .m02_axis_aclk(m02_axis_aclk),
        .m02_axis_aresetn(m02_axis_aresetn),
        .m02_axis_tready(m02_axis_tready),
        .m02_axis_rd_tdata(m02_axis_rd_tdata),
        .m02_axis_tstrb(m02_axis_tstrb),
        .m02_axis_tvalid(m02_axis_tvalid),
        .m02_axis_tlast(m02_axis_tlast)        
    );

    // Clock generation 
    always #(PERIOD/2) s02_axis_aclk = ~s02_axis_aclk;
    always #(PERIOD/2) m02_axis_aclk = ~m02_axis_aclk;

    initial begin
        s02_axis_aresetn = 1'b0;
        m02_axis_aresetn = 1'b0;
        #2;
        s02_axis_aresetn = 1'b1;
        m02_axis_aresetn = 1'b1;
        m02_axis_tready = 1'b0;

        // test 1
        #10;
        // write data in the memory
        s02_axis_wr_tdata = 32'h0055;
        s02_axis_tstrb = 'b1;
        s02_axis_tvalid = 1'b1;
        s02_axis_tlast = 1'b1;

        // test 2
        #10;
        // write data in the memory
        s02_axis_wr_tdata = 32'h0022;
        s02_axis_tstrb = 'b1;
        s02_axis_tvalid = 1'b1;
        s02_axis_tlast = 1'b1;

        // test 3
        #10;
        // write data in the memory
        s02_axis_wr_tdata = 32'h0024;
        s02_axis_tstrb = 'b1;
        s02_axis_tvalid = 1'b1;
        s02_axis_tlast = 1'b1;

        // // test 1 data out
        #20;
         // Read data from the memory
        m02_axis_tready = 1'b1;

        // // test 2 data out
        #20;
         // Read data from the memory
        m02_axis_tready = 1'b1;

        // // test 3 data out
        #20;
         // Read data from the memory
        m02_axis_tready = 1'b1;

        #100;

        $finish;
    end


endmodule