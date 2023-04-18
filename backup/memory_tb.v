`timescale 1ns / 1ps

module memory_tb;

// Parameter declarations
parameter MEM_SIZE = 256; // 256 bytes of memory
parameter ADDR_WIDTH = 8; // 8-bit address bus
parameter DATA_WIDTH = 8; // 8-bit data bus

// Signal declarations
reg clk;
reg wr_en;
reg [7:0] wr_data;
reg [7:0] wr_addr;
reg rd_en;
reg [7:0] rd_addr;
wire [7:0] rd_data;

// Instance of memory module
memory dut (
    .clk(clk),
    .wr_en(wr_en),
    .wr_data(wr_data),
    .wr_addr(wr_addr),
    .rd_en(rd_en),
    .rd_addr(rd_addr),
    .rd_data(rd_data)
);

// Clock generator
always #5 clk = ~clk;

// Write and read sequence
initial begin
    clk = 0;
    wr_en = 1;
    wr_addr = 0;
    wr_data = 8'h55;
    #10;
    wr_addr = 1;
    wr_data = 8'hAA;
    #10;
    wr_en = 0;
    rd_en = 1;
    rd_addr = 0;
    #10;
    rd_addr = 1;
    #10;
end

// Output simulation results
always @(posedge clk) begin
    $monitor($time," .rd_data =%0d", rd_data);
#300 $finish;
end

endmodule
