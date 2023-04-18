`timescale 1ns/1ps

module generator_tb;

// Parameters
parameter CLK_PERIOD = 2;
parameter data_size = 32;

// Inputs
reg clk = 0;
reg rst;
reg enable;

// Outputs
wire [data_size-1:0] power_of_3;

// Instantiate the Design Under Test (DUT)
generator dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .power_of_3(power_of_3)
);

// Clock Generation
always  #(CLK_PERIOD/2) clk = ~clk;

// generate data
initial begin
    // Assert reset
    #2
     rst = 1;
     enable = 0;
    
    
    // Release reset
    #2 
     rst = 0;
    
    
    // Assert enable signal
    #2
      enable = 1;
    
    // End simulation
    #120 $finish;
end

endmodule
