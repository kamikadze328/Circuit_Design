`timescale 1ns / 1ps

module mult (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input start,
    output busy,
    output reg [15:0] y
);

 localparam IDLE = 1'b0;
 localparam WORK = 1'b1;
  
 reg [2:0] ctr;
 wire [2:0] end_step;
 wire [7:0] part_sum;
 wire [15:0] shifted_part_sum;
 reg state = IDLE;
  
 assign part_sum = a & {8{b[ctr]}};
 assign shifted_part_sum = part_sum << ctr;
 assign end_step = (ctr == 3'h7);
 assign busy = state;
  
always @(posedge clk)
	if (rst) begin
        ctr <= 0;
        y <= 0;
        state <= IDLE;
    end else begin
        case (state) 
            IDLE: begin
                ctr <= 0;
                if (start) begin
                    state <= WORK;
                    y <= 0;
                end
            end
            WORK: begin
                if (end_step) begin
                    state <= IDLE;
                end 
                y <= y + shifted_part_sum;
                ctr <= ctr + 1;
            end
      endcase
    end
endmodule