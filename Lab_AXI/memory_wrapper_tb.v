`timescale 1ns/1ps

module memory_wrapper_tb();

    // Declare the signals
    reg clk = 0;
    reg rst_n;
    reg [7:0] address;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;

    // Instantiate the memory_wrapper module
    memory_wrapper dut (
        .clk(clk),
        .rst_n(rst_n),
        .address(address),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Generate clock
    always #2 clk = ~clk;

    // Initialize signals
    initial begin
        rst_n = 0;
        address = 0;
        data_in = 0;
        read_en = 0;
        write_en = 0;
        #100;

        // Reset
        rst_n = 1;
        #50;
        rst_n = 0;
        #50;
        rst_n = 1;
        #50;

        // Write to memory
        write_en = 1;
        data_in = 8'h55;
        address = 8'h01;
        #50;
        write_en = 0;
        data_in = 0;
        address = 0;
	#60;
        // Read from memory
        read_en = 1;
        address = 8'h01;
        #80;
        read_en = 0;
        address = 0;

        // End simulation
        #700;
        $finish;
    end

endmodule
