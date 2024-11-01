
class cnn_monitor extends uvm_monitor;
  `uvm_component_utils(cnn_monitor)
  
  virtual cnn_interface vif;
  cnn_sequence_item txn;
  uvm_analysis_port #(cnn_sequence_item) monitor_port;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "cnn_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    
    monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual cnn_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)
    
    forever begin
      txn = cnn_sequence_item::type_id::create("txn");
      
      @(posedge vif.clk);
      txn.reset    = vif.reset;
      txn.start    = vif.start;
      txn.load_x   = vif.load_x;
      txn.load_h   = vif.load_h;
      txn.I        = vif.I;
      txn.K        = vif.K;
      txn.data_in  = vif.data_in;
      txn.done     = vif.done;
      txn.data_out = vif.data_out;

//      if (o_cnt <= cnn_sequence::out * cnn_sequence::out) begin
//        if (vif.done) begin
//            o_cnt = o_cnt + 1;
//        end
//        else begin
//            monitor_port.write_out(txn);
//            o_cnt = o_cnt + 1;
//        end
//      end
      // send item to scoreboard
      monitor_port.write(txn);
    end    
  endtask: run_phase
  
  
endclass: cnn_monitor