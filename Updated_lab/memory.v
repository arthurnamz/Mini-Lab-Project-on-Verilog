module memory 
#
(
    // Parameter declarations
parameter MEM_SIZE = 4096, 
parameter ADDR_WIDTH = 12, 
parameter DATA_WIDTH = 32  
)
(
    // slave input ports
    input s02_axis_aclk,
    input s02_axis_aresetn,
    input [DATA_WIDTH-1:0] s02_axis_wr_tdata,
    input [(DATA_WIDTH/8)-1 : 0] s02_axis_tstrb,
    input s02_axis_tvalid,
    input s02_axis_tlast,
    output reg s02_axis_tready,

    // master output port
    input m02_axis_aclk,
    input m02_axis_aresetn,
    input m02_axis_tready,
    output reg [DATA_WIDTH-1:0] m02_axis_rd_tdata,
    output reg [(DATA_WIDTH/8)-1 : 0] m02_axis_tstrb,
    output reg m02_axis_tvalid,
    output reg m02_axis_tlast
);



// Internal signal declarations
reg [DATA_WIDTH-1:0] mem[0:MEM_SIZE-1];
reg [ADDR_WIDTH-1:0] wr_addr_counter;
reg [ADDR_WIDTH-1:0] rd_addr_counter;
reg notify;

// Write operation
always @(posedge s02_axis_aclk) begin
    if(~s02_axis_aresetn) begin
        wr_addr_counter <= 0;
        s02_axis_tready <= 0;
        notify <= 0;
    end else if (s02_axis_tvalid && s02_axis_tlast && s02_axis_tstrb == 'b1) begin
		mem[wr_addr_counter] <= s02_axis_wr_tdata;
        wr_addr_counter <= wr_addr_counter + 1;
        s02_axis_tready <= 1;
        notify <= 1;
    end else begin
        s02_axis_tready <= 1;
    end
end

// Read operation
always @(posedge m02_axis_aclk) begin
        if(~m02_axis_aresetn) begin
            rd_addr_counter <= 0;
            m02_axis_rd_tdata <= 'bz;
            notify <= 0;
        end else if ( m02_axis_tready && notify == 1 ) begin
            m02_axis_rd_tdata <= mem[rd_addr_counter];
            rd_addr_counter <= rd_addr_counter + 1;
            m02_axis_tvalid <= 1;
            m02_axis_tstrb <= 'b1; 
            m02_axis_tlast <= 1;
        end else begin
            m02_axis_rd_tdata <= 'bz;
            notify <= 0;
        end
end

endmodule
