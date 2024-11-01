 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cnn_interface.sv"
`include "cnn_sequence_item.sv"        // transaction class
`include "cnn_sequence.sv"             // sequence class
`include "cnn_sequencer.sv"            // sequencer class
`include "cnn_driver.sv"               // driver class
`include "cnn_monitor.sv"
`include "cnn_agent.sv"                // agent class  
`include "cnn_scoreboard.sv"
`include "cnn_env.sv"                  // environment class
`include "cnn_test.sv"
module cnn_top_tb;
  
  bit clk; // external signal declaration
  int i = 0;

  //----------------------------------------------------------------------------
  cnn_interface i_intf(clk);
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  Convolution DUT(.clk(i_intf.clk),
                  .reset(i_intf.reset),
                  .start(i_intf.start),
                  .load_x(i_intf.load_x),
                  .load_h(i_intf.load_h),
                  .I(i_intf.I),
                  .K(i_intf.K),
                  .data_in(i_intf.data_in),
                  .done(i_intf.done),
                  .data_out(i_intf.data_out)
                  );
  //----------------------------------------------------------------------------               
  
  always #5 clk=~clk;

  initial begin
    clk=0;
  end
  
  //----------------------------------------------------------------------------
//  initial begin
//    $dumpfile("dumpfile.vcd");
//    $dumpvars;
//  end
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  initial begin
    uvm_config_db #(virtual cnn_interface)::set(null, "*", "vif", i_intf);
  end
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  initial begin
    run_test("cnn_test");
    #1000
    $display("sjdkghhdskjhgskjhskgjg");
    $finish;
  end
  
  //----------------------------------------------------------------------------
endmodule
     