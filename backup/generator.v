module generator
#
(
 parameter data_size = 32
)
 (
    input clk, // clock signal
    input rst, // reset signal
    input enable, // enable signal
    output reg [data_size-1:0] power_of_3 // output signal
);

// generate power-of-3 sequence on positive edge of clock
always @(posedge clk) begin
    if (rst) begin
        // reset output to 1
        power_of_3 <= 1;
    end else if (enable) begin
        // multiply current value by 3 to get next power-of-3 value
        power_of_3 <= power_of_3 * 3;
    end
end

endmodule
