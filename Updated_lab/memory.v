module memory 
#
(
    // Parameter declarations
parameter MEM_SIZE = 4096, 
parameter ADDR_WIDTH = 12, 
parameter DATA_WIDTH = 32  
)
(
    // input ports
    input s01_axis_aclk,
    input s01_axis_aresetn,
    input s01_axis_wr_en,
    input s01_axis_rd_en,
    input s01_axis_tready,
    input [ADDR_WIDTH-1:0] s01_axis_wr_addr,
    input [ADDR_WIDTH-1:0] s01_axis_rd_addr,
    input [DATA_WIDTH-1:0] s01_axis_wr_tdata,

    // ouput port
    output reg [DATA_WIDTH-1:0] s01_axis_rd_tdata,
    output reg [(DATA_WIDTH/8)-1 : 0] s01_axis_tstrb,
    output reg s01_axis_tvalid,
    output reg s01_axis_tlast
);



// Internal signal declarations
reg [DATA_WIDTH-1:0] mem[0:MEM_SIZE-1];

// Write operation
always @(posedge clk) begin
    if(valid) begin
	    if (wr_en) begin
		mem[wr_addr] <= wr_data;
	    end
	 end
end

// Read operation
always @(posedge clk) begin
if(ready) begin
    if (rd_en) begin
        rd_data <= mem[rd_addr];
    end
    end
end

endmodule
