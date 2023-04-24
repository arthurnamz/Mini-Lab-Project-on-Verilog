`timescale 1ns/1ns

module main_wrapper_tb;

    // Parameters
    parameter MEM_SIZE = 4096;
    parameter ADDR_WIDTH = 12;
    parameter DATA_WIDTH = 32;

    // slave ports
    reg  s03_axis_aclk = 0;
    reg  s03_axis_aresetn;
    reg  s03_axis_enable;
    wire s03_axis_tready;
   
    // master ports
    reg  m03_axis_aclk = 0;
    reg  m03_axis_aresetn;
    reg  m03_axis_tready;
    wire [DATA_WIDTH-1:0]  m03_axis_tdata;
    wire [(DATA_WIDTH/8)-1 : 0] m03_axis_tstrb;
    wire m03_axis_tvalid;
    wire m03_axis_tlast;

    // Instantiate the main wrapper dut
    main_wrapper #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(
          // slave ports
            .s03_axis_aclk(s03_axis_aclk),
            .s03_axis_aresetn(s03_axis_aresetn),
            .s03_axis_enable(s03_axis_enable),
            .s03_axis_tready(s03_axis_tready),
        
            // master ports
            .m03_axis_aclk(m03_axis_aclk),
            .m03_axis_aresetn(m03_axis_aresetn),
            .m03_axis_tready(m03_axis_tready),
            .m03_axis_tdata(m03_axis_tdata),
            .m03_axis_tstrb(m03_axis_tstrb),
            .m03_axis_tvalid(m03_axis_tvalid),
            .m03_axis_tlast(m03_axis_tlast)
    );

    // Clock generation
    always #5 s03_axis_aclk = ~s03_axis_aclk;
    always #5 m03_axis_aclk = ~m03_axis_aclk;

    // Reset generation
    initial begin
        s03_axis_aresetn = 0;
        m03_axis_aresetn = 0;
        #10;
        s03_axis_aresetn = 1;
        m03_axis_aresetn = 1;
    end

    // Test stimulus
    initial begin
        #120;
        s03_axis_enable = 1;
        #20;
        m03_axis_tready = 1;
        #400;

        #200;
        $finish;
    end

endmodule