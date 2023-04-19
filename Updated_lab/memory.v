module memory 
#
(
    // Parameter declarations
//parameter MEM_SIZE = 4096, 
parameter ADDR_WIDTH = 12, 
parameter DATA_WIDTH = 32  
)
(
    // input ports
    input s02_axis_aclk,
    input m02_axis_aclk,
    input s02_axis_aresetn,
    input m02_axis_aresetn,
    input s02_axis_wr_en,
    input m02_axis_rd_en,
    input [ADDR_WIDTH-1:0] s02_axis_wr_addr,
    input [ADDR_WIDTH-1:0] m02_axis_rd_addr,
    input [DATA_WIDTH-1:0] s02_axis_wr_tdata,
    input [(DATA_WIDTH/8)-1 : 0] s02_axis_tstrb,
    input s02_axis_tvalid,
    input s02_axis_tlast,
    input m02_axis_tready,

    // ouput port
    output reg [DATA_WIDTH-1:0] m02_axis_rd_tdata,
    output reg [(DATA_WIDTH/8)-1 : 0] m02_axis_tstrb,
    output reg m02_axis_tvalid,
    output reg m02_axis_tlast,
    output reg s02_axis_tready
    
);



// Internal signal declarations
reg [DATA_WIDTH-1:0] mem[0:4095];

// Write operation
always @(posedge s02_axis_aclk) begin
    if(~s02_axis_aresetn) begin
        mem[s02_axis_wr_addr] <= 'bz;
    end else if (s02_axis_wr_en && s02_axis_tvalid && s02_axis_tstrb && s02_axis_tlast) begin
		mem[s02_axis_wr_addr] <= s02_axis_wr_tdata;
        s02_axis_tready <= 'b1;
    end else begin
        mem[s02_axis_wr_addr] <= 'bz;
    end
end


// Read operation
always @(posedge m02_axis_aclk) begin
        if(~m02_axis_aresetn) begin
            m02_axis_rd_tdata <= 'bz;
        end else if (m02_axis_rd_en && m02_axis_tready ) begin
            m02_axis_rd_tdata <= mem[m02_axis_rd_addr];
            m02_axis_tvalid <= 'b1;
            m02_axis_tstrb <= 'b1;
            m02_axis_tlast <= 'b1;
        end else begin
            m02_axis_rd_tdata <= 'bz;
        end
end

endmodule
