`timescale 1ns/1ps

module memory_tb;
    parameter MEM_SIZE = 4096; 
    parameter ADDR_WIDTH = 12; 
    parameter DATA_WIDTH = 32; 

 // input ports
    reg s02_axis_aclk;
    reg m02_axis_aclk;
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


endmodule