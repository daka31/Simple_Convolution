`timescale 1ns/1ps
`define UVM_NO_DEPRECATED

class cnn_sequence extends uvm_sequence#(cnn_sequence_item);
  //----------------------------------------------------------------------------
  `uvm_object_utils(cnn_sequence)            
  //----------------------------------------------------------------------------
  cnn_sequence_item txn;
  virtual cnn_interface vif;
  static int ni, ke, out;
  //----------------------------------------------------------------------------
  function new(string name="cnn_sequence");  
    super.new(name);
  endfunction
  
  static function int get_num();
    return ni;
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  virtual task body();
    
  endtask:body
  //----------------------------------------------------------------------------
endclass:cnn_sequence

/********************************************************************
class name  : reset_sequence
description : ->reset sequence for resetting cnn
*********************************************************************/
/*class reset_sequence extends cnn_sequence;
  //----------------------------------------------------------------------------   
  `uvm_object_utils(reset_sequence)      
  //----------------------------------------------------------------------------
  cnn_sequence_item txn;
  //----------------------------------------------------------------------------
  function new(string name="RESET_SEQUENCE");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
 
  //----------------------------------------------------------------------------
  virtual task body();
    txn = cnn_sequence_item::type_id::create("txn");
    start_item(txn);
    txn.randomize(K) with {K > 0;};
    ker = txn.K;
    txn.randomize(I) with {I >= ker; I <= 10;};
    in = txn.I;
    txn.start = 0;
    txn.reset = 1;
    txn.data_in = 8'bx;
    finish_item(txn);
    txn.printf();
  endtask:body
  //----------------------------------------------------------------------------
  
endclass:reset_sequence
*/
/********************************************************************

*********************************************************************/
class cnn_sequence1 extends cnn_sequence;
  //----------------------------------------------------------------------------   
  `uvm_object_utils(cnn_sequence1)    

  //----------------------------------------------------------------------------
  virtual cnn_interface vif;
  cnn_sequence_item txn;
  int unsigned num = 10;
  logic [9:0] in;
  logic [2:0] ker;
  //----------------------------------------------------------------------------
  function new(string name="CNN_SEQUENCE1");
      super.new(name);
  endfunction
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  virtual task body();
      txn = cnn_sequence_item::type_id::create("RESET_txn");
      start_item(txn);
      txn.reset = 1;
      txn.start = 0;
      //txn.printf();
      finish_item(txn);
      //wait(10);
      
      txn.set_name("START_K_txn");
      start_item(txn);
      //txn.printf();
      txn.randomize() with {reset == 0; load_h == 1; load_x == 0; start == 0;};
      in = txn.I;
      cnn_sequence::ni = in;
      ker = txn.K;
      cnn_sequence::ke = ker;
      cnn_sequence::out = (txn.I - txn.K + 1);
      finish_item(txn);
      
      txn.set_name("LOAD_K_txn");
      repeat(ker*ker) begin
      start_item(txn);
      //txn.printf();
      txn.randomize() with {I == in; K == ker; reset == 0; load_h == 0; load_x == 0; start == 0;};
      finish_item(txn);
      end
      
      txn.set_name("START_I_txn");
      start_item(txn);
      //txn.printf();
      #10
      txn.randomize() with {I == in; K == ker; reset == 0; load_h == 0; load_x == 1; start == 0;};
      finish_item(txn);
      
      txn.set_name("LOAD_I_txn");
      repeat(in*in) begin
      start_item(txn);
      
      //txn.printf();
      txn.randomize() with {I == in; K == ker; reset == 0; load_h == 0; load_x == 0; start == 0;};
      finish_item(txn);
      end
      
      txn.set_name("START_txn");
      start_item(txn);
      txn.set_custom_name("START_txn");
      //txn.printf();
      #20
      txn.randomize() with {I == in; K == ker; reset == 0; load_h ==0; load_x ==0; start == 1;};
      finish_item(txn);
      
      
      txn.set_name("START_txn");
      start_item(txn);
      txn.set_custom_name("START_txn");
      //txn.printf();
      txn.randomize() with {I == in; K == ker; reset ==0; load_h == 0; load_x == 0; start == 0;};
      //#2000
      finish_item(txn);     
  endtask:body
  //----------------------------------------------------------------------------
endclass: cnn_sequence1