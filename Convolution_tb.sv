`timescale 1ns/100ps
module Convolution_tb();
    logic clk, reset, start, done, qwerty, load_h, load_x;
    integer i;
    logic [9:0] I;
    logic [2:0] K;
    logic signed [7:0] data_in;
    logic signed [15:0] data_out;
    real start_time, end_time;
    Convolution dut(I, K, clk, reset, load_h, load_x, start, done, data_in, data_out);

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Set input values.
    initial begin
        start_time = $time;  
        I = 5;
        K = 3;

        start = 0; 
        reset = 1; 
        data_in = 8'bx;

        @(posedge clk);
      #1;
         reset = 0;
        load_h = 1;

        @(posedge clk);
      #1;
         load_h = 0; 
        //data_in = 1;
        
        //@(posedge clk);
        for(i = 1; i <= K*K; i++) begin
            data_in = $urandom_range(4, 0) - 2;
            $display("data_in = %d", data_in);
            @(posedge clk);
        end

        @(posedge clk);
      #1;
        load_x = 1;

        @(posedge clk);
      #1;
         load_x = 0; 
        //data_in = 1;
        
        //@(posedge clk);
        for(i = 1; i <= I*I; i++) begin
             #1; data_in = i;
          $display("data_in = %d", data_in);
            @(posedge clk);
        end

        @(posedge clk); 
        @(posedge clk);
      #1;
        start = 1;

        @(posedge clk);
      #1;
         start = 0;
    end

    
    initial begin
        @(posedge done);
      		$display("doen = %0t", $time);
        @(posedge clk);

        for(i = 0; i < ((I - K + 1) * (I - K + 1)); i++) begin
            #1 $display("Time = %0t, y[%.1d] = %.1d", $time, i, data_out); 
            @(posedge clk);
        end
        
        #100
        for(i = 0; i < K * K; i++) begin
          $display("Time = %0t, Mem_k[%0d] = %.1d", $time, i, $signed(dut.d.mem_k.mem[i]));
        end
        
        for(i = 0; i < I * I; i++) begin
          $display("Time = %t, Mem_in[%0d] = %.1d", $time, i, $signed(dut.d.mem_in.mem[i]));
        end
        
        for(i = 0; i < ((I - K + 1) * (I - K + 1)); i++) begin
          $display("Time = %4.1t, Mem_o[%0d] = %.1d", $time, i, $signed(dut.d.mem_o.mem[i]));
        end
        $finish;
    end
endmodule


