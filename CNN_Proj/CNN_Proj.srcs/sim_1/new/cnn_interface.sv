interface cnn_interface(input bit clk);
    logic reset, start, load_h, load_x;
    logic [9:0] I;
    logic [2:0] K;
    logic done;
    logic signed [7:0] data_in;
    logic signed [15:0] data_out;
    
    clocking cb @(posedge clk);
        default input #1ns output #1ns;
        output I;
        output K;
        output reset;
        output load_h;
        output load_x;
        output start;
        output data_in;
        input done;
        input data_out;

    endclocking
    
endinterface