`timescale 1ns/1ps

module memory_tb;
    parameter PERIOD = 2; 
    parameter ADDR_WIDTH = 12; 
    parameter DATA_WIDTH = 32; 

 // input ports
    reg s02_axis_aclk = 0;
    reg m02_axis_aclk = 0;
    reg s02_axis_aresetn;
    reg m02_axis_aresetn;
    reg s02_axis_wr_en;
    reg m02_axis_rd_en;
    reg [ADDR_WIDTH-1:0] s02_axis_wr_addr;
    reg [ADDR_WIDTH-1:0] m02_axis_rd_addr;
    reg [DATA_WIDTH-1:0] s02_axis_wr_tdata;
    reg [(DATA_WIDTH/8)-1 : 0] s02_axis_tstrb;
    reg s02_axis_tvalid;
    reg s02_axis_tlast;
    reg m02_axis_tready;

    // ouput port
    wire [DATA_WIDTH-1:0] m02_axis_rd_tdata;
    wire [(DATA_WIDTH/8)-1 : 0] m02_axis_tstrb;
    wire m02_axis_tvalid;
    wire m02_axis_tlast;
    wire s02_axis_tready;

    memory #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(
        .s02_axis_aclk(s02_axis_aclk),
        .m02_axis_aclk(m02_axis_aclk),
        .s02_axis_aresetn(s02_axis_aresetn),
        .m02_axis_aresetn(m02_axis_aresetn),
        .s02_axis_wr_en(s02_axis_wr_en),
        .m02_axis_rd_en(m02_axis_rd_en),
        .s02_axis_wr_addr(s02_axis_wr_addr),
        .m02_axis_rd_addr(m02_axis_rd_addr),
        .s02_axis_wr_tdata(s02_axis_wr_tdata),
        .s02_axis_tstrb(s02_axis_tstrb),
        .s02_axis_tvalid(s02_axis_tvalid),
        .s02_axis_tlast(s02_axis_tlast),
        .m02_axis_tready(m02_axis_tready),
        .m02_axis_rd_tdata(m02_axis_rd_tdata),
        .m02_axis_tstrb(m02_axis_tstrb),
        .m02_axis_tvalid(m02_axis_tvalid),
        .m02_axis_tlast(m02_axis_tlast),
        .s02_axis_tready(s02_axis_tready)
    );

    // Clock generation 
    always #(PERIOD/2) s02_axis_aclk = ~s02_axis_aclk;
    always #(PERIOD/2) m02_axis_aclk = ~m02_axis_aclk;

    initial begin
        s02_axis_aresetn = 0;
        m02_axis_aresetn = 0;
        #2;
        s02_axis_aresetn = 1;
        m02_axis_aresetn = 1;

        #4;
        s02_axis_wr_en = 0;
        m02_axis_rd_en = 0;
        s02_axis_wr_addr = `12b00;
        #10;
        // write data in the memory
        s02_axis_wr_en = 1;
        m02_axis_rd_en = 0;
        s02_axis_wr_addr = `12b01;
        s02_axis_wr_tdata = `32b0022;
        s02_axis_tstrb = 1;
        s02_axis_tvalid = 1;
        m02_axis_tlast = 1;

        #40;
         // Read data from the memory
        m02_axis_rd_en = 1;
        m02_axis_tready = 1;
        m02_axis_rd_addr = `12b01;

        #100;

        $finish;
    end


endmodule