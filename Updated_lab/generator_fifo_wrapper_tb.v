
timescale 1ns / 1ps

module generator_fifo_wrapper_tb;

    // Parameters
    localparam ADDR_WIDTH = 12;
    localparam DATA_SIZE = 32;

    // Inputs
    reg m00_axis_aclk = 0;
    reg m00_axis_aresetn;
    reg m00_axis_enable;
    wire m00_axis_tready;

    // Outputs
    wire [DATA_SIZE-1:0] m00_axis_tdata;
    wire [(DATA_SIZE/8)-1:0] m00_axis_tstrb;
    wire m00_axis_tvalid;
    wire m00_axis_tlast;

    // Instantiate the DUT
    generator_fifo_wrapper #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_SIZE(DATA_SIZE)
    ) dut (
        .m00_axis_aclk(m00_axis_aclk),
        .m00_axis_aresetn(m00_axis_aresetn),
        .m00_axis_enable(m00_axis_enable),
        .m00_axis_tready(m00_axis_tready),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tlast(m00_axis_tlast)
    );

    // Stimulus
    initial begin
        // Reset
        m00_axis_aresetn = 0;
        #10;
        m00_axis_aresetn = 1;

        // Enable
        m00_axis_enable = 1;

        // Send some data
        repeat (10) begin
            // Wait for tready
            repeat (10) begin
                #10;
                if (m00_axis_tready) begin
                    #10;
                end
            end

            // Wait for tlast
            repeat (10) begin
                #10;
                if (m00_axis_tlast) begin
                    #10;
                end
            end
        end

        // Disable
        m00_axis_enable = 0;

        // Wait for FIFO to drain
        integer i;
        for (i = 0; i < 10; i = i + 1) begin
            #10;
            if (m00_axis_tvalid && m00_axis_tready && m00_axis_tlast) begin
                $display("FIFO drained.");
                #10;
            end
        end

        // Stop the simulation
        #1500;
        $finish;
    end

    // Clock generation
    always #5 m00_axis_aclk = ~m00_axis_aclk;

endmodule

// `timescale 1ns / 1ps

// module generator_fifo_wrapper_tb;

//     // Parameters
//     localparam ADDR_WIDTH = 12;
//     localparam DATA_SIZE = 32;

//     // Inputs
//     reg m00_axis_aclk = 0;
//     reg m00_axis_aresetn;
//     reg m00_axis_enable;
//     wire m00_axis_tready;

//     // Outputs
//     wire [DATA_SIZE-1:0] m00_axis_tdata;
//     wire [(DATA_SIZE/8)-1:0] m00_axis_tstrb;
//     wire m00_axis_tvalid;
//     wire m00_axis_tlast;

//     // Instantiate the DUT
//     generator_fifo_wrapper #(
//         .ADDR_WIDTH(ADDR_WIDTH),
//         .DATA_SIZE(DATA_SIZE)
//     ) dut (
//         .m00_axis_aclk(m00_axis_aclk),
//         .m00_axis_aresetn(m00_axis_aresetn),
//         .m00_axis_enable(m00_axis_enable),
//         .m00_axis_tready(m00_axis_tready),
//         .m00_axis_tdata(m00_axis_tdata),
//         .m00_axis_tstrb(m00_axis_tstrb),
//         .m00_axis_tvalid(m00_axis_tvalid),
//         .m00_axis_tlast(m00_axis_tlast)
//     );

//     // Stimulus
//     initial begin
//         // Reset
//         m00_axis_aresetn = 0;
//         #10;
//         m00_axis_aresetn = 1;

//         // Enable
//         m00_axis_enable = 1;

//         // Send some data
//         repeat (10) begin
//             // Wait for tready
//             repeat (10) begin
//                 #10;
//                 if (m00_axis_tready) begin
//                     #10;
//                 end
//             end

//             // Wait for tlast
//             repeat (10) begin
//                 #10;
//                 if (m00_axis_tlast) begin
//                     #10;
//                 end
//             end
//         end

//         // Disable
//         m00_axis_enable = 0;

//         // Wait for FIFO to drain
//         repeat (10) begin
//             #10;
//             if (m00_axis_tvalid && m00_axis_tready && m00_axis_tlast) begin
//                 $display("FIFO drained.");
//                 #10;
//             end
//         end

//         // Stop the simulation
//         #1500;
//         $finish;
//     end

//     // Clock generation
//     always #5 m00_axis_aclk = ~m00_axis_aclk;

// endmodule


// `timescale 1ns/1ns

// module generator_fifo_wrapper_tb;

//     // Parameters
//     parameter DATA_SIZE = 32;

//     // Input ports
//     reg m00_axis_aclk = 0;
//     reg m00_axis_aresetn;
//     reg m00_axis_enable;
//     reg m00_axis_tready;

//     // Output ports
//     wire [DATA_SIZE-1:0]  m00_axis_tdata;
//     wire [(DATA_SIZE/8)-1 : 0] m00_axis_tstrb;
//     wire m00_axis_tvalid;
//     wire m00_axis_tlast;

//     // Instantiate the DUT
//     generator_fifo_wrapper #(
//         .DATA_SIZE(DATA_SIZE)
//     ) dut (
//         .m00_axis_aclk(m00_axis_aclk),
//         .m00_axis_aresetn(m00_axis_aresetn),
//         .m00_axis_enable(m00_axis_enable),
//         .m00_axis_tdata(m00_axis_tdata),
//         .m00_axis_tstrb(m00_axis_tstrb),
//         .m00_axis_tvalid(m00_axis_tvalid),
//         .m00_axis_tlast(m00_axis_tlast),
//         .m00_axis_tready(m00_axis_tready)
//     );

//     // Clock generation
//     always #15 m00_axis_aclk = ~m00_axis_aclk;

//     // Reset generation
//     initial begin
//         #2;
//         m00_axis_aresetn = 0;
//         #100;
//         m00_axis_aresetn = 1;
//     end

//     // Test stimulus
//     initial begin
//         #10
//         m00_axis_enable = 1;
//         m00_axis_tready = 1;

//         #100
//         m00_axis_enable = 0;
//         m00_axis_tready = 0;
//         #100
//         m00_axis_enable = 1;
//         m00_axis_tready = 1;
//         #100;
//         m00_axis_enable = 0;
//         m00_axis_tready = 0;
//         #200
//         $finish;
//     end

// endmodule

