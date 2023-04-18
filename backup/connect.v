module power_of_3_fifo (
    input logic clk,
    input logic rst,
    output logic [31:0] out_tdata,
    output logic [3:0] out_tstrb,
    output logic out_tvalid,
    input logic out_tready
);

logic [31:0] power_of_3;
logic [31:0] power_of_3_next;
logic [31:0] power_of_3_reg;

// Power of 3 generator
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        power_of_3_reg <= 1;
    end else begin
        power_of_3_reg <= power_of_3_next;
    end
end

assign power_of_3 = power_of_3_reg;
assign power_of_3_next = power_of_3 * 3;

// AXI-Stream FIFO
axis_fifo #(
    .ADDR_WIDTH(8),
    .C_AXIS_TDATA_WIDTH(32)
) fifo (
    .s00_axis_aclk(clk),
    .s00_axis_aresetn(!rst),
    .s00_axis_tdata(power_of_3),
    .s00_axis_tstrb(4'b1111),
    .s00_axis_tvalid(out_tvalid),
    .s00_axis_tready(out_tready),
    .s00_axis_tlast(1'b1),
    .m00_axis_aclk(clk),
    .m00_axis_aresetn(!rst),
    .m00_axis_tdata(out_tdata),
    .m00_axis_tstrb(out_tstrb),
    .m00_axis_tvalid(out_tvalid),
    .m00_axis_tready(out_tready),
    .m00_axis_tlast(1'b1)
);

endmodule
