module generator
#
(
    parameter DATA_SIZE = 32
)
(
    // Input ports
    input m00_axis_aclk,
    input m00_axis_aresetn,
    input m00_axis_enable,
    input   m00_axis_tready,

    // Output ports
    output reg [DATA_SIZE-1:0]  m00_axis_tdata,
    output reg [(DATA_SIZE/8)-1 : 0] m00_axis_tstrb,
    output  reg m00_axis_tvalid,
    output  reg m00_axis_tlast
);


// generate power-of-3 sequence on positive edge of clock
always @(posedge m00_axis_aclk) begin
    if (~m00_axis_aresetn) begin
        // reset output to 1
        m00_axis_tdata <= 1;
        m00_axis_tvalid <= 0;
    end else if (m00_axis_enable && m00_axis_tready) begin
        m00_axis_tdata <= m00_axis_tdata * 3;
        m00_axis_tvalid <= 'b1;
        m00_axis_tstrb <= 'b1;
        m00_axis_tlast <= 'b1;
    end else begin
        m00_axis_tvalid <= 'b0;
        m00_axis_tlast <= 'b0;
    end
end

endmodule
