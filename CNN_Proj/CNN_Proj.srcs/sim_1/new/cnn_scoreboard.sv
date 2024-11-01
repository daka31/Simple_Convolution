

class cnn_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cnn_scoreboard)
  
  uvm_analysis_imp #(cnn_sequence_item, cnn_scoreboard) scoreboard_port;
  
  virtual cnn_interface vif;
  
  cnn_sequence_item transactions[$];
  logic [15:0] actual_trans[$];
  int k_cnt = 0;
  int i_cnt = 0;
  int o_cnt = 0;
  logic [7:0] memk[$];
  logic [7:0] memi[$];
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "cnn_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
    
   
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(cnn_sequence_item item);
    transactions.push_back(item);
    if (actual_trans.size() <= cnn_sequence::out*cnn_sequence::out) begin
        if (item.done) begin
            actual_trans.push_back(item.data_out);
        end
    end
    if (!item.reset) begin
        if (k_cnt <= cnn_sequence::ke * cnn_sequence::ke) begin
            if (item.load_h) begin
                k_cnt = k_cnt + 1;
            end
            else begin
                memk.push_back(item.data_in);
                k_cnt = k_cnt + 1;
            end
        end
        else begin
            if (i_cnt <= (cnn_sequence::ni * cnn_sequence::ni) + 1) begin
                if (item.load_x) begin
                    i_cnt = i_cnt + 1;
                end
                else begin
                    memi.push_back(item.data_in);
                    i_cnt = i_cnt + 1;
                end
            end
        end
    end
    if (memi.size() > cnn_sequence::ni * cnn_sequence::ni)
        memi.pop_front();
    if (actual_trans.size() > cnn_sequence::out * cnn_sequence::out)
        actual_trans.pop_front();
  endfunction: write 
  
//  function void write_out(cnn_sequence_item item);
//    actual_trans.push_back(item);
//  endfunction
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)

    $display("CCCCC %0d, %0d", memi.size(), actual_trans.size());
    forever begin
      /*
      // get the packet
      // generate expected vcnne
      // compare it with actual vcnne
      // score the transactions accordingly
      */
      cnn_sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      if (curr_trans.reset == 0)
        compare(curr_trans);
    end
    
  endtask: run_phase
  

  //--------------------------------------------------------
  //Compare : Generate Expected Result and Compare with Actual
  //--------------------------------------------------------
  task compare(cnn_sequence_item curr_trans);   
      int i, j, m, n;
      int sum;
      logic [15:0] expected_trans[$];
        // Initialize output matrix to zero
        for (i = 0; i < cnn_sequence::out * cnn_sequence::out; i++) begin
            expected_trans[i] = 0;
        end
        // Perform convolution
        for (i = 0; i < curr_trans.I - curr_trans.K + 1; i++) begin
            for (j = 0; j < curr_trans.I - curr_trans.K + 1; j++) begin
                sum = 0;
                // Apply kernel
                for (m = 0; m < curr_trans.K; m++) begin
                    for (n = 0; n < curr_trans.K; n++) begin
                        sum += ($signed(memi[(i + m) * curr_trans.I + (j + n)]) * $signed(memk[m * curr_trans.K + n]));
                    end
                end

                // Store the result in the output matrix
                expected_trans[i * (curr_trans.I - curr_trans.K + 1) + j] = sum;
            end
        end
    foreach (memk[i])
        $display("memk[%0d] = %0d", i, $signed(memk[i]));
    foreach (memi[i])
        $display("memi[%0d] = %0d", i, $signed(memi[i]));
    foreach (actual_trans[i])
        $display("actual_trans[%0d] = %0d", i, $signed(actual_trans[i]));
    for (int i = 0; i < cnn_sequence::out * cnn_sequence::out; i++) begin
        $display("expected[%0d] = %0d", i, $signed(expected_trans[i]));
    end
    if (actual_trans.size() == expected_trans.size()) begin
        $display("SIZE COMPARE, PASS! ACT_SIZE = %d, EXP = %d", actual_trans.size(), expected_trans.size());
        for (int i = 0; i < cnn_sequence::out*cnn_sequence::out; i++) begin
            if (actual_trans[i] == expected_trans[i])
                $display("COMPARE, PASS! ACT[%0d] = %0d, EXP[%0d] = %0d", i, $signed(actual_trans[i]), i, $signed(expected_trans[i]));
            else
                $display("COMPARE, FAILED! ACT[%0d] = %0d, EXP[%0d] = %0d", i, $signed(actual_trans[i]), i, $signed(expected_trans[i]));
        end
    end
  endtask
  
  
endclass: cnn_scoreboard