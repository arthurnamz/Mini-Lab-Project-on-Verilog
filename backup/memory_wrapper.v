module memory_wrapper (
    input clk,
    input rst_n,
    input [7:0] address,
    input [7:0] data_in,
    input read_en,
    input write_en,
    output reg [7:0] data_out
);

    // Instantiate the memory module
    memory mem_inst (
        .clk(clk),
        .wr_en(write_en),
        .wr_data(data_in),
        .wr_addr(address),
        .rd_en(read_en),
        .rd_addr(address),
        .rd_data(data_out)
    );

    // Instantiate the RAM controller module
    ram_controller controller_inst (
        .clk(clk),
        .rst_n(rst_n),
        .read_en(read_en),
        .write_en(write_en),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

endmodule
