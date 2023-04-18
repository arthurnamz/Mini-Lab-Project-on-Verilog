`timescale 1ns/1ps

module axis_fifo_tb;
    parameter TIME = 2;
    parameter ADDR_WIDTH = 12;
    parameter C_AXIS_TDATA_WIDTH = 32;

    /*
     * AXI slave interface (input to the FIFO)
     */
    reg                   s00_axis_aclk = 0;
    reg                   s00_axis_aresetn;
    reg [C_AXIS_TDATA_WIDTH-1:0]  s00_axis_tdata;
    reg [(C_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb;
    reg                   s00_axis_tvalid;
    wire                   s00_axis_tready;
    reg                   s00_axis_tlast;

    /*
     * AXI master interface (output of the FIFO)
     */
    reg                  m00_axis_aclk = 0;
    reg                   m00_axis_aresetn;
    wire [C_AXIS_TDATA_WIDTH-1:0]  m00_axis_tdata;
    wire [(C_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb;
    wire                 m00_axis_tvalid;
    reg                  m00_axis_tready;
    wire                  m00_axis_tlast;

    axis_fifo #(.ADDR_WIDTH(ADDR_WIDTH),.C_AXIS_TDATA_WIDTH(C_AXIS_TDATA_WIDTH)) DUT(
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

    // Generating clock for input interface
    always #(TIME/2) s00_axis_aclk = ~s00_axis_aclk;

    // Generate clock for output interface
    always #(TIME/2) m00_axis_aclk = ~m00_axis_aclk;

    initial begin
        // Initialize signals
        s00_axis_aresetn = 0;
        m00_axis_aresetn = 0;
        #1 s00_axis_aresetn = 1;
        #1 m00_axis_aresetn = 1;

        // Write data to the FIFO
        #2 s00_axis_tvalid = 1;
        #2 s00_axis_tdata = 5;
        #2 m00_axis_tready = 0;
        
        // Wait for the data to be accepted by the FIFO
        #20;
        
        //tlast is  Asserted to indicate end of packet
        s00_axis_tlast = 1;
        #20;
       // $display($time, "s00_axis_tdata = %0d", s00_axis_tdata);
        
        
        // Read data from the FIFO
        m00_axis_tready = 1;
        #10;
        
        #2 s00_axis_tlast = 0;
        s00_axis_tvalid = 0;
         #10;
        
        #20;
        // Writing another packet of data to the FIFO
        s00_axis_tvalid = 1;
        s00_axis_tdata = 10;
        m00_axis_tready = 0;
        
        // Waiting for the data to be accepted by the FIFO
        #20;
        
        // tlast is  Asserted to indicate end of packet
        s00_axis_tlast = 1;
        #20;
        //$display($time, "s00_axis_tdata = %0d", s00_axis_tdata);
        
        // Read data from the FIFO
        m00_axis_tready = 1;
        #10;
        
        #2 s00_axis_tlast = 0;
        s00_axis_tvalid = 0;
        
        
        
        // Finish the simulation
        #100 $finish;
end
endmodule

	
