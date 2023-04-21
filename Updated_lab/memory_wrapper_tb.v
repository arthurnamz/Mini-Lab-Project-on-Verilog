`timescale 1ns/1ps

module memory_wrapper_tb;
    parameter PERIOD = 10; 
    parameter MEM_SIZE = 4096; 
    parameter ADDR_WIDTH = 12;
    parameter DATA_WIDTH = 32; 

    // slave input ports
    reg s01_axis_aclk = 0;
    reg s01_axis_aresetn;
    reg [DATA_WIDTH-1:0] s01_axis_tdata;
    reg [(DATA_WIDTH/8)-1 : 0] s01_axis_tstrb;
    reg s01_axis_tvalid;
    reg s01_axis_tlast;
    wire s01_axis_tready;

    // master output port
    reg m01_axis_aclk = 0;
    reg m01_axis_aresetn;
    reg m01_axis_tready;
    wire [DATA_WIDTH-1:0] m01_axis_tdata;
    wire [(DATA_WIDTH/8)-1 : 0] m01_axis_tstrb;
    wire m01_axis_tvalid;
    wire m01_axis_tlast;

    memory_wrapper #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(
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
        .m01_axis_tdata(m01_axis_tdata),
        .m01_axis_tstrb(m01_axis_tstrb),
        .m01_axis_tvalid(m01_axis_tvalid),
        .m01_axis_tlast(m01_axis_tlast)        
    );

    // Clock generation 
    always #(PERIOD/2) s01_axis_aclk = ~s01_axis_aclk;
    always #(PERIOD/2) m01_axis_aclk = ~m01_axis_aclk;

    initial begin
        s01_axis_aresetn = 0;
        m01_axis_aresetn = 0;
        #2;
        s01_axis_aresetn = 1;
        m01_axis_aresetn = 1;
       

        // test 1
        #100;
        // write data in the memory
        s01_axis_tdata = 32'h0055;
        s01_axis_tstrb = 1;
        s01_axis_tvalid = 1;
        s01_axis_tlast = 1;

        // test 2
        #200;
        // write data in the memory
        s01_axis_tdata = 32'h0022;
        s01_axis_tstrb = 1;
        s01_axis_tvalid = 1;
        s01_axis_tlast = 1;

        // test 3
        #200;
        // write data in the memory
        s01_axis_tdata = 32'h0024;
        s01_axis_tstrb = 1;
        s01_axis_tvalid = 1;
        s01_axis_tlast = 1;

        // // test 1 data out
        #200;
         // Read data from the memory
        m01_axis_tready = 1;

        // // test 2 data out
        #200;
         // Read data from the memory
        m01_axis_tready = 1;

        // // test 3 data out
        #200;
         // Read data from the memory
        m01_axis_tready = 1;

        

        #300;

        $finish;
    end


endmodule