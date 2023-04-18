module memory(
    input clk,
    input wr_en,
    input [7:0] wr_data,
    input [7:0] wr_addr,
    input rd_en,
    input [7:0] rd_addr,
    output reg [7:0] rd_data
);

// Parameter declarations
parameter MEM_SIZE = 256; // 256 bytes of memory
parameter ADDR_WIDTH = 8; // 8-bit address bus
parameter DATA_WIDTH = 8; // 8-bit data bus

// Internal signal declarations
reg [DATA_WIDTH-1:0] mem[0:MEM_SIZE-1];

// Write operation
always @(posedge clk) begin
    if (wr_en) begin
        mem[wr_addr] <= wr_data;
    end
end

// Read operation
always @(posedge clk) begin
    if (rd_en) begin
        rd_data <= mem[rd_addr];
    end
end

endmodule
