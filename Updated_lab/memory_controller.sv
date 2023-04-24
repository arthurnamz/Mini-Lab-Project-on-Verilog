module memory_controller #(
  // Parameter declarations
  parameter DATA_WIDTH = 32
) (
  // Slave input ports
  input s01_axis_aclk,
  input s01_axis_aresetn,
  input [DATA_WIDTH-1:0] s01_axis_tdata,
  input [(DATA_WIDTH/8)-1:0] s01_axis_tstrb,
  input s01_axis_tvalid,
  input s01_axis_tlast,
  output reg s01_axis_tready,

  // Master output ports
  input m01_axis_aclk,
  input m01_axis_aresetn,
  input m01_axis_tready,
  output reg [DATA_WIDTH-1:0] m01_axis_tdata,
  output reg [(DATA_WIDTH/8)-1:0] m01_axis_tstrb,
  output reg m01_axis_tvalid,
  output reg m01_axis_tlast
);

  // Internal registers 
  reg [DATA_WIDTH-1:0] tmp;
  reg flag1 = 0;
  reg flag2 = 0;
  // reg flag3 = 0;

  // State machine states
  typedef enum {IDLE_SLAVE,CACHE,WAIT_FOR_MASTER } slave_states;
  typedef enum {IDLE_MASTER, WAIT_FOR_MEMORY, WRITE_TO_MEMORY, NOTIFY_SLAVE_PORT, SYNC_MEMORY } master_states;
  slave_states slave_state;
  master_states master_state;

//   always @(posedge s01_axis_aclk) begin
//     if(s01_axis_tlast)begin
//       tmp <= s01_axis_tdata;
//       flag3 <= 1;
//     end
// end

 // Slave interface
  always @(posedge s01_axis_aclk) begin
    if (~s01_axis_aresetn) begin
      s01_axis_tready <= 0;
      slave_state <= IDLE_SLAVE;
    end else begin
      case (slave_state)
        IDLE_SLAVE: begin
          flag1 <= 0;
            if(s01_axis_tvalid && s01_axis_tstrb && s01_axis_tlast) begin
                slave_state <= CACHE;
                s01_axis_tready <= 1;
            end
        end
        CACHE: begin
          tmp <= s01_axis_tdata;
          s01_axis_tready <= 0;
          flag1 <= 1;
          slave_state <= WAIT_FOR_MASTER;
        end
        WAIT_FOR_MASTER: begin
          flag1 <= 0;
            if(flag2) begin
                slave_state <= IDLE_SLAVE;
                s01_axis_tready <= 1;
            end
        end
      endcase
    end
  end

// Master interface
  always @(posedge m01_axis_aclk) begin
    if (~m01_axis_aresetn) begin
        m01_axis_tdata <= 'bz;
        master_state <= IDLE_MASTER;
    end else begin
      case (master_state)
        IDLE_MASTER: begin
            flag2 <= 0;
            if(flag1 == 1'b1) begin
                master_state <= WAIT_FOR_MEMORY;
                m01_axis_tvalid <= 0;
                m01_axis_tdata <= 'bz;
                m01_axis_tstrb <= 0;
                m01_axis_tlast <= 0;
            end
        end
        WAIT_FOR_MEMORY: begin
            if(m01_axis_tready) begin
                master_state <= WRITE_TO_MEMORY;
                m01_axis_tvalid <= 0;
                m01_axis_tdata <= 'bz;
                m01_axis_tstrb <= 0;
                m01_axis_tlast <= 0;
            end
        end
        WRITE_TO_MEMORY: begin
            m01_axis_tvalid <= 1;            
            m01_axis_tstrb <= 'b1;
            m01_axis_tlast <= 1; 
            m01_axis_tdata <= tmp;
            master_state <= NOTIFY_SLAVE_PORT;                       
        end
        NOTIFY_SLAVE_PORT: begin
          master_state <= IDLE_MASTER;
          flag2 <= 1;
        end
      endcase
    end
  end
endmodule

