
`timescale 1ns/1ps

module memory_controller_tb;

    // Parameters
    parameter MEM_SIZE = 4096; 
    parameter ADDR_WIDTH = 12; 
    parameter DATA_WIDTH = 32;

    // Signals
    reg s01_axis_aclk;
    reg s01_axis_aresetn;
    reg [DATA_WIDTH-1:0] s01_axis_tdata;
    reg [(DATA_WIDTH/8)-1:0] s01_axis_tstrb;
    reg s01_axis_tvalid;
    reg s01_axis_tlast;
    wire s01_axis_tready;
    
    reg m01_axis_aclk;
    reg m01_axis_aresetn;
    reg m01_axis_tready;
    wire [DATA_WIDTH-1:0] m01_axis_tdata;
    wire [(DATA_WIDTH/8)-1:0] m01_axis_tstrb;
    wire m01_axis_tvalid;
    wire m01_axis_tlast;

    // Instantiate the DUT
    memory_controller dut (
        .MEM_SIZE(MEM_SIZE),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .s01_axis_aclk(s01_axis_aclk),
        .s01_axis_aresetn(s01_axis_aresetn),
        .s01_axis_tdata(s01_axis_tdata),
        .s01_axis_tstrb(s01_axis_tstrb),
        .s01_axis_tvalid(s01_axis_tvalid),
        .s01_axis_tlast(s01_axis_tlast),
        .s01_axis_tready(s01_axis_tready),
        .m01_axis_aclk(m01_axis_aclk),
        .m01_axis_aresetn(m01_axis_aresetn),
        .m01_axis_tdata(m01_axis_tdata),
        .m01_axis_tstrb(m01_axis_tstrb),
        .m01_axis_tvalid(m01_axis_tvalid),
        .m01_axis_tlast(m01_axis_tlast),
        .m01_axis_tready(m01_axis_tready)
    );

    // Clock generator
    always #5 s01_axis_aclk = ~s01_axis_aclk;
    always #10 m01_axis_aclk = ~m01_axis_aclk;

    // Reset
    initial begin
        s01_axis_aclk = 0;
        m01_axis_aclk = 0;
        s01_axis_aresetn = 0;
        m01_axis_aresetn = 0;
        #100;
        s01_axis_aresetn = 1;
        m01_axis_aresetn = 1;
    end

    // Write test
    initial begin
        // Wait for reset to complete
        @(posedge s01_axis_aclk);
        s01_axis_tvalid = 1;
        s01_axis_tdata = 'h12345678;
        s01_axis_tstrb = 4'b1111;
        s01_axis_tlast = 1;
        repeat(4) @(posedge s01_axis_aclk);
        assert(s01_axis_tready == 1) else $error("Write operation failed: s01_axis_tready was not asserted.");
        repeat(8) @(posedge s01_axis_aclk);
        s01_axis_tvalid = 0;
        s01_axis_tdata = 0;
        s01_axis_tstrb = 0;
        s01_axis_tlast = 0;
    end

    // Read test
    initial begin
        // Wait for write to complete
        repeat(12) @(posedge s01_axis_aclk);
        // Wait for reset to complete
        // Start read operation
    m01_axis_tready <= 1;
    
    // Wait for read to complete
    repeat(4096) @(posedge m01_axis_aclk);
    
    // Verify the read data
    integer i;
    for (i = 0; i < 4096; i = i + 1) begin
        if (mem[i] !== i) begin
            $display("Read test failed at address %d", i);
            $finish;
        end
    end
    $display("Read test passed");
    $finish;
end
endmodule


// `timescale 1ns/1ps

// module memory_controller_tb;
//     parameter PERIOD = 2; 
//     parameter MEM_SIZE = 4096; 
//     parameter ADDR_WIDTH = 12;
//     parameter DATA_WIDTH = 32; 

//     // slave input ports
//     reg s01_axis_aclk = 0;
//     reg s01_axis_aresetn;
//     reg [DATA_WIDTH-1:0] s01_axis_tdata;
//     reg [(DATA_WIDTH/8)-1 : 0] s01_axis_tstrb;
//     reg s01_axis_tvalid;
//     reg s01_axis_tlast;
//     wire s01_axis_tready;

//     // master output port
//     reg m01_axis_aclk = 0;
//     reg m01_axis_aresetn;
//     reg m01_axis_tready;
//     wire [DATA_WIDTH-1:0] m01_axis_tdata;
//     wire [(DATA_WIDTH/8)-1 : 0] m01_axis_tstrb;
//     wire m01_axis_tvalid;
//     wire m01_axis_tlast;

//     memory_controller #(.MEM_SIZE(MEM_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(
//         .s01_axis_aclk(s01_axis_aclk),
//         .s01_axis_aresetn(s01_axis_aresetn),
//         .s01_axis_tdata(s01_axis_tdata),
//         .s01_axis_tstrb(s01_axis_tstrb),
//         .s01_axis_tvalid(s01_axis_tvalid),
//         .s01_axis_tlast(s01_axis_tlast),
//         .s01_axis_tready(s01_axis_tready),

//         .m01_axis_aclk(m01_axis_aclk),
//         .m01_axis_aresetn(m01_axis_aresetn),
//         .m01_axis_tready(m01_axis_tready),
//         .m01_axis_tdata(m01_axis_tdata),
//         .m01_axis_tstrb(m01_axis_tstrb),
//         .m01_axis_tvalid(m01_axis_tvalid),
//         .m01_axis_tlast(m01_axis_tlast)        
//     );

//     // Clock generation 
//     always #(PERIOD/2) s01_axis_aclk = ~s01_axis_aclk;
//     always #(PERIOD/2) m01_axis_aclk = ~m01_axis_aclk;

//     initial begin
//         s01_axis_aresetn = 1'b0;
//         m01_axis_aresetn = 1'b0;
//         #2;
//         s01_axis_aresetn = 1'b1;
//         m01_axis_aresetn = 1'b1;
       

//         // test 1
//         #10;
//         // write data in the memory
//         s01_axis_tdata = 32'h0055;
//         s01_axis_tstrb = 1'b1;
//         s01_axis_tvalid = 1'b1;
//         s01_axis_tlast = 1'b1;

//         // test 2
//         #10;
//         // write data in the memory
//         s01_axis_tdata = 32'h0022;
//         s01_axis_tstrb = 1'b1;
//         s01_axis_tvalid = 1'b1;
//         s01_axis_tlast = 1'b1;

//         // test 3
//         #10;
//         // write data in the memory
//         s01_axis_tdata = 32'h0024;
//         s01_axis_tstrb = 1'b1;
//         s01_axis_tvalid = 1'b1;
//         s01_axis_tlast = 1'b1;

//         // // test 1 data out
//         #20;
//          // Read data from the memory
//         m01_axis_tready = 1'b1;

//         // // test 2 data out
//         #20;
//          // Read data from the memory
//         m01_axis_tready = 1'b1;

//         // // test 3 data out
//         #20;
//          // Read data from the memory
//         m01_axis_tready = 1'b1;

//         #100;

//         $finish;
//     end


// endmodule