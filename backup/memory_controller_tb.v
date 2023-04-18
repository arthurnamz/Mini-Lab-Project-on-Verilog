`timescale 1ns/1ns

module ram_controller_tb;

reg clk = 0, rst_n, write_en, read_en;
reg [7:0] address, data_in;
wire [7:0] data_out;

ram_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .read_en(read_en),
    .write_en(write_en),
    .address(address),
    .data_in(data_in),
    .data_out(data_out)
);

always #2 clk = ~clk;

initial begin
    rst_n = 0;
    read_en = 0;
    write_en = 0;
    address = 8'h00;
    data_in = 8'h00;

    // Reset sequence
    #10 rst_n = 1;
    #20;

    // Test case 1: Write and read data
    write_en = 1;
    address = 8'h01;
    data_in = 8'hFF;
    #30;
    write_en = 0;

    read_en = 1;
    address = 8'h01;
    #30;
    read_en = 0;


    // Test case 2: Write and read from a different address
    write_en = 1;
    address = 8'h02;
    data_in = 8'hAA;
    #20;
    write_en = 0;

    read_en = 1;
    address = 8'h02;
    #20;
    read_en = 0;


    // Test case 3: Write to multiple addresses and read from one of them
    write_en = 1;
    address = 8'h03;
    data_in = 8'h11;
    #20;
    write_en = 0;

    read_en = 1;
    address = 8'h03;
    #20;
    read_en = 0;
    #300;
    $finish;
    
end

endmodule

