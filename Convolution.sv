module Convolution(I, K, clk, reset, load_h, load_x, start, done, data_in, data_out);

	input clk, reset, start, load_h, load_x;
	input [9:0] I;
	input [2:0] K;
	output done;
	input logic signed [7:0] data_in;
	output logic signed [15:0] data_out;	
	logic wr_en_h ,wr_en_x,wr_en_y,clear_acc;
	logic [9:0] addr_x;
	logic [9:0] addr_y;
	logic [5:0] addr_h;
	

	Datapath d(clk, data_in,addr_x,wr_en_x,addr_h,wr_en_h,addr_y,wr_en_y,clear_acc,data_out);
	ControlUnit c(I, K, clk, reset, start, addr_x, wr_en_x, addr_h, wr_en_h, clear_acc, addr_y, wr_en_y,done, load_h, load_x);
	
endmodule


