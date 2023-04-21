
`timescale 1ns/1ps

module memory_controller_tb;

    // Parameters 
    parameter DATA_WIDTH = 32;

  // Define module inputs and outputs
  reg s01_axis_aclk = 0, s01_axis_aresetn;
  reg [31:0] s01_axis_tdata;
  reg [3:0] s01_axis_tstrb;
  reg s01_axis_tvalid, s01_axis_tlast;
  wire s01_axis_tready;

  reg m01_axis_aclk = 0, m01_axis_aresetn, m01_axis_tready;
  wire [31:0] m01_axis_tdata;
  wire [3:0] m01_axis_tstrb;
  wire m01_axis_tvalid, m01_axis_tlast;

  // Instantiate the module
  memory_controller #(
    .DATA_WIDTH(32)
  ) dut (
    .s01_axis_aclk(s01_axis_aclk),
    .s01_axis_aresetn(s01_axis_aresetn),
    .s01_axis_tdata(s01_axis_tdata),
    .s01_axis_tstrb(s01_axis_tstrb),
    .s01_axis_tvalid(s01_axis_tvalid),
    .s01_axis_tlast(s01_axis_tlast),
    .s01_axis_tready(s01_axis_tready),

    .m01_axis_aclk(m01_axis_aclk),
    .m01_axis_aresetn(m01_axis_aresetn),
    .m01_axis_tdata(m01_axis_tdata),
    .m01_axis_tstrb(m01_axis_tstrb),
    .m01_axis_tvalid(m01_axis_tvalid),
    .m01_axis_tlast(m01_axis_tlast),
    .m01_axis_tready(m01_axis_tready)
  );

 
    always #5 s01_axis_aclk = ~s01_axis_aclk;
    always #5 m01_axis_aclk = ~m01_axis_aclk;


  // Reset generation
  initial begin
    s01_axis_aresetn = 0;
    m01_axis_aresetn = 0;
    #50 s01_axis_aresetn = 1;
    #50 m01_axis_aresetn = 1;
  end

  // Testcase 1: Write data to memory and read it back
  initial begin
    // Send data to module
    s01_axis_tdata = 32'h68;
    s01_axis_tstrb = 1;
    s01_axis_tvalid = 1;
    s01_axis_tlast = 1;
    m01_axis_tready = 0;

    // Wait for module to signal readiness
    #200;

    #20;

    // Read data from module
    m01_axis_tready = 1;

    // Wait for module to signal readiness
    #200;
   
m01_axis_tready = 0;
    
    // Wait for read to complete
    #200;
    
    $finish;
end
endmodule
