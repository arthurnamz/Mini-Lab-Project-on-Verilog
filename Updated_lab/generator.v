module generator
#
(
    parameter DATA_WIDTH = 32
)
(
    // Input ports
    input m00_axis_aclk,
    input m00_axis_aresetn,
    input enable,
    input m00_axis_tready,

    // Output ports
    output reg [DATA_WIDTH-1:0]  m00_axis_tdata,
    output reg [(DATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
    output reg m00_axis_tvalid,
    output reg m00_axis_tlast
);
reg [DATA_WIDTH-1:0] counter;


// generate power-of-3 sequence on positive edge of clock
always @(posedge m00_axis_aclk) begin
    if (~m00_axis_aresetn) begin
        // reset output to 1
        counter <= 0;
        m00_axis_tdata <= 'bz;
        m00_axis_tvalid <= 1'b0;
        m00_axis_tstrb <= 'b0;
        m00_axis_tlast <= 1'b0;
    end else if (enable && m00_axis_tready) begin
        m00_axis_tdata <= 3**counter;
        counter <= counter + 1;
        m00_axis_tvalid <= 'b1;
        m00_axis_tstrb <= 'b1;
        m00_axis_tlast <= 'b1;
    end else begin
        m00_axis_tvalid <= 'b0;
        m00_axis_tstrb <= 'b1;
        m00_axis_tlast <= 'b1;
    end
end

endmodule
