module ControlUnit(I, K, clk, reset, start, addr_in, wr_en_in, addr_k, wr_en_k, clear_acc, addr_o, wr_en_o,done, load_k, load_in);
		input clk, reset, start, load_k, load_in;
		input [9:0] I;
		input [2:0] K;
		output logic [5:0] addr_k;
		output logic [9:0] addr_in;
		logic [5:0] addr_injump;
		output logic [9:0] addr_o;
		output logic wr_en_in,wr_en_k,clear_acc,wr_en_o;
		output logic done;
		logic [3:0] state, next_state;
		logic  load_k_complete, load_in_complete, mac_jump, mac_complete,mac_state_done, write_complete, mac_row_done;
    
    parameter [3:0] IDLE = 0,
                    LOAD_KERNEL = 1,
                    LOAD_INPUT = 2,
                    MAC = 3,
                    PREPARE_WRITE = 4,
                    WRITE = 5,
                    PREPARE_OUT = 6,
                    OUT_RESULT = 7,
                    READY = 9;
    
  		assign wr_en_k = (state == LOAD_KERNEL && reset == 0);
		assign wr_en_in = (state == LOAD_INPUT && reset == 0);
		assign wr_en_o = (state == WRITE && reset == 0);
		
		always @(posedge clk) begin
			if (reset)
				state <= IDLE; 
			else
				state <= next_state;
		end

		always @(posedge clk) begin
			if (state == WRITE && write_complete == 1)
				done <= 1;
		end
		
		always @(posedge clk) begin
			if (!mac_complete)
				addr_k <= addr_k+1;
			else if (mac_state_done == 1 && state != WRITE)
				addr_k <= addr_k;
			else if (!load_k_complete)
				addr_k <= addr_k + 1;
			else if (load_k)
				addr_k <= 0;
			else addr_k <= 0;	
		end

		always @(posedge clk) begin
			if ((((!load_in_complete) && (state == LOAD_INPUT)) || mac_complete == 0) && mac_jump != 1) 
				addr_in <= addr_in + 1;
			else if (mac_jump == 1)
				addr_in <= addr_in + I - K + 1;
			else if (reset)
				addr_in <= 0;
			else 
				addr_in <= addr_injump;
		end
		
		always @(posedge clk) begin
			if (mac_jump && !mac_row_done && addr_k < (K + 1) && !reset)
				addr_injump <= addr_injump + 1;
			else if (mac_jump && mac_row_done && addr_k < (K + 1) && !reset)
				addr_injump <= addr_injump + K;
			else if (reset)
				addr_injump <= 0;
		end

		always @(posedge clk) begin
			if (((state == WRITE) && (!write_complete)) || state == OUT_RESULT || state  ==  PREPARE_OUT)
				addr_o <= addr_o + 1;
			else if (state == IDLE || write_complete == 1)
				addr_o <= 0;
			else
				addr_o <= addr_o;
		end

		always @(posedge clk) begin
			if (state == WRITE || state == LOAD_INPUT || state == READY)
				clear_acc <= 1;
			else
				clear_acc <= 0;
		end

		always_comb begin
		  write_complete = 0; 
		  load_k_complete = 1; 
		  mac_row_done = 0; 
		  load_in_complete = 0; 
		  mac_jump = 0;  
		  mac_complete = 1; 
		  mac_state_done = 0;
		  write_complete = 0;

			if (state == IDLE) begin
				if (start)
					next_state = MAC;
				else if (load_k)
					next_state = LOAD_KERNEL;
				else if (load_in)
					next_state = LOAD_INPUT;
				else begin
					next_state = IDLE;
				end
			end

			else if (state == LOAD_KERNEL) begin
				if (addr_k <= (K * K) - 1) begin
					next_state = LOAD_KERNEL;
					load_k_complete = 0;
				end
				else begin
					next_state = READY;
					load_k_complete = 1;
				end
			end

			else if (state == LOAD_INPUT) begin
				if (addr_in <= (I * I) - 1) begin
					next_state = LOAD_INPUT;
					load_in_complete = 0;
				end
				else begin
					next_state = READY;
					load_in_complete = 1;
				end;
			end

			else if (state == READY) begin
				if (start)
					next_state=MAC;
				else if (load_k)
					next_state = LOAD_KERNEL;
				else if (load_in)
					next_state = LOAD_INPUT;
				else
					next_state = READY;
			end
			else if (state == MAC) begin
				if (addr_k < (K * K) - 1) begin
				  next_state = MAC;
				  mac_complete = 0;
				  load_in_complete  = 0;
					if ((addr_k + 1) % K == 0)
						mac_jump = 1;
					else mac_jump = 0;
					if (((addr_o + 1) % (I - K + 1)) == 0)
						mac_row_done = 1;
					else
					  mac_row_done = 0;
				end				
				else begin
				  next_state = PREPARE_WRITE;
				  	mac_state_done = 1;
				end
			end

			else if (state == PREPARE_WRITE) begin
				next_state = WRITE;
				mac_state_done = 1;
			end
	
			else if (state == WRITE) begin
				mac_state_done = 1;
			  if (addr_o < ((I - K + 1) * (I - K + 1) - 1)) begin
					next_state = MAC;
					write_complete = 0;
				end
				else begin
					next_state = PREPARE_OUT;
					
					write_complete = 1;
				end
			end

			else if(state  == PREPARE_OUT) begin
				next_state = OUT_RESULT; 
			end

			else if (state == OUT_RESULT) begin
				if (addr_o < ((I - K + 1) * (I - K + 1) - 1))
					next_state = OUT_RESULT;
				else
					next_state=IDLE;
				end
				//else next_state=8;
			end

endmodule


