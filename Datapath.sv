module Datapath(clk, data_in,addr_in,wr_en_in,addr_k,wr_en_k,addr_o,wr_en_o,clear_acc,data_out);
	input clk;
	input logic clear_acc , wr_en_k , wr_en_in, wr_en_o;
	input logic signed [7:0] data_in;
	input logic[5:0] addr_k;
	input logic[9:0] addr_in;
	input logic[9:0] addr_o;
	output logic signed [15:0] data_out;
	logic signed [15:0] f,mul_out,add_r;
	logic signed [7:0] data_out_h , data_out_x;
 
	Memory #(8, 1024, 10) mem_in(clk, data_in, data_out_x, addr_in, wr_en_in); 
	Memory #(8, 64, 6) mem_k(clk, data_in, data_out_h, addr_k, wr_en_k);
	Memory #(16, 1024, 10) mem_o(clk, f, data_out, addr_o, wr_en_o);

	always_ff @ (posedge clk) begin

		if(clear_acc == 1) begin
			f <= 0;
			end
		else begin
			f <= add_r;
			end
	end
	always_comb begin
		mul_out = data_out_h * data_out_x;
		add_r = f + mul_out;
		//$display("Time = %1t, x = %.1d, h = %.1d, mul = %.1d", $time, data_out_x, data_out_h, mul_out);
        //$display("Time = %1t, f = %.1d, add_r = %.1d", $time, f, add_r);
	end

endmodule


