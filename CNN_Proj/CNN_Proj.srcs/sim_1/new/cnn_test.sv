
class cnn_test extends uvm_test;
  `uvm_component_utils(cnn_test)

  cnn_env env;
  cnn_sequence seq;
  //reset_sequence rst_seq;
  cnn_sequence1 seq1;
  virtual cnn_interface vif;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "cnn_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = cnn_env::type_id::create("env", this);
    
    if(!(uvm_config_db #(virtual cnn_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase


  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)

    phase.raise_objection(this);

    //reset_seq
    //rst_seq = reset_sequence::type_id::create("reset_seq");
    //rst_seq.start(env.agnt.seqr);
    //#10;

    repeat(1) begin
      //test_seq
      seq1 = cnn_sequence1::type_id::create("test_seq");
      seq1.start(env.agnt.seqr);
      //fork begin
        //forever begin
            @(posedge vif.done);
            @(posedge vif.clk);
            for(int i = 0; i < ((vif.I - vif.K + 1) * (vif.I - vif.K + 1)); i++) begin
                #1 $display("Time = %0t, y[%.1d] = %.1d", $time, i, vif.data_out); 
                @(posedge vif.clk);
            end            
            //phase.drop_objection(this);
            //disable fork;
        //end
      //join_any
    end
    phase.drop_objection(this);
  endtask: run_phase


endclass: cnn_test