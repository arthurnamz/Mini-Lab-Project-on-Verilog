module generator_tb;

reg aclk = 0;
reg aresetn;
reg enable;
wire [7:0] data_out;
wire valid;
reg ready;

generator dut(.aclk(aclk), .aresetn(aresetn), .enable(enable), .data_out(data_out), .valid(valid), .ready(ready));


    always #5 aclk = ~aclk;


initial begin
    // reset the dut
    aresetn = 0;
    enable = 0;
    ready = 0;
    #20 aresetn = 1;

    // wait for 5 clock cycles to ensure reset is complete
    #25;

    // start the generator
    enable = 1;
    ready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    enable = 0;
    ready = 0;

    // wait for 5 clock cycles
    #25;

    // start the generator again
    enable = 1;
    ready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    enable = 0;
    ready = 0;

    // wait for 5 clock cycles
    #25;

    // start the generator again
    enable = 1;
    ready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    enable = 0;
    ready = 0;

    // wait for 5 clock cycles
    #25;

    $finish;
end

always @(posedge aclk) begin
    if (valid && ready) begin
        $display("data_out = %d", data_out);
    end
end

endmodule
