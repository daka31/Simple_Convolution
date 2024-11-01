
class cnn_sequence_item extends uvm_sequence_item;

  //------------ i/p || o/p field declaration-----------------
    rand logic reset, start, load_h, load_x;
    rand logic [9:0] I;
    rand logic [2:0] K;
    logic done;
    rand logic signed [7:0] data_in;
    logic signed [15:0] data_out;
    string trans_name;
    
    constraint a {I inside {[4:10]};};
    constraint b {K >= 2; K <= I;};
    constraint c {data_in inside {[-10:10]};};
  
  //---------------- register cnn_sequence_item class with factory --------
  `uvm_object_utils_begin(cnn_sequence_item) 
     `uvm_field_int( I ,UVM_ALL_ON)
     `uvm_field_int( K ,UVM_ALL_ON)
     `uvm_field_int( data_in ,UVM_ALL_ON)
  	 `uvm_field_int( data_out ,UVM_ALL_ON)
  `uvm_object_utils_end
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="CNN_SEQUENCE_ITEM");
    super.new(name);
    trans_name = name;
  endfunction
  //----------------------------------------------------------------------------
  function void set_custom_name(string name);
    trans_name = name;
  endfunction
  
  function string get_custom_name();
    return trans_name;
  endfunction
  
  function void printf();
    `uvm_info("CNN_SEQUENCE_ITEM",$sformatf("Time = %t X = %0d H = %0d reset = %0b start = %0b load_x = %0b load_h = %0b data_in = %0d data_out = %d, done = %b",
    $time, I, K, reset, start, load_x, load_h, data_in, data_out, done),UVM_MEDIUM)
  endfunction

  
endclass:cnn_sequence_item