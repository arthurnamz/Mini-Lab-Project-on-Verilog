module generator_tb;
    parameter DATA_SIZE = 32;
    reg m00_axis_aclk;
    reg m00_axis_aresetn;
    reg m00_axis_enable;
    wire  [DATA_SIZE-1:0]  m00_axis_tdata;
    wire  [(DATA_SIZE/8)-1 : 0] m00_axis_tstrb;
    wire   m00_axis_tvalid;
    reg   m00_axis_tready;
    wire  m00_axis_tlast;

generator #(.DATA_SIZE(DATA_SIZE)) dut
    (
        .m00_axis_aclk(m00_axis_aclk), 
        .m00_axis_aresetn(m00_axis_aresetn), 
        .m00_axis_enable(m00_axis_enable), 
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb), 
        .m00_axis_tvalid(m00_axis_tvalid), 
        .m00_axis_tready(m00_axis_tready), 
        .m00_axis_tlast(m00_axis_tlast)
        );


always #5 m00_axis_aclk = ~m00_axis_aclk;


initial begin
    // reset the dut
    m00_axis_aresetn = 0;
    m00_axis_enable = 0;
    m00_axis_tready = 0;
    #20 m00_axis_aresetn = 1;

    // wait for 5 clock cycles to ensure reset is complete
    #25;

    // start the generator
    m00_axis_enable = 1;
    m00_axis_tready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    m00_axis_enable = 0;
    m00_axis_tready = 0;

    // wait for 5 clock cycles
    #25;

    // start the generator again
    m00_axis_enable = 1;
    m00_axis_tready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    m00_axis_enable = 0;
    m00_axis_tready = 0;

    // wait for 5 clock cycles
    #25;

    // start the generator again
    m00_axis_enable = 1;
    m00_axis_tready = 1;

    // wait for 10 clock cycles to produce some output
    #50;

    // stop the generator
    m00_axis_enable = 0;
    m00_axis_tready = 0;

    // wait for 5 clock cycles
    #25;

    $finish;
end

always @(posedge m00_axis_aclk) begin
    if (m00_axis_tvalid && m00_axis_tready) begin
        $display("m00_axis_tdata = %d", m00_axis_tdata);
    end
end

endmodule
