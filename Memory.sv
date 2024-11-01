module Memory(clk, data_in, data_out, addr, wr_en);
	parameter WIDTH = 16, SIZE  = 64, LOGSIZE = 6;
	input logic signed [WIDTH-1:0] data_in;
	output logic signed [WIDTH-1:0] data_out;
	input [LOGSIZE-1:0] addr;
	input clk, wr_en;
	logic signed [SIZE-1:0][WIDTH-1:0] mem;
	
	initial begin
	  for(int i = 0; i < 100; i++) begin
	    mem[i] = 0;
	  end
	    
	end
	  
		always_ff @(posedge clk) begin
			data_out <= mem[addr];
			if (wr_en) begin
			   mem[addr] <= data_in;
			   //$display("mem[%.1d] = %.1d", addr, mem[addr]);
			end
		end
endmodule

