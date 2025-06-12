`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_mon)
class mux_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(mux_scoreboard)

  uvm_analysis_imp_drv #(mux_sequence_item, mux_scoreboard) aport_drv;
  uvm_analysis_imp_mon #(mux_sequence_item, mux_scoreboard) aport_mon;

  // Temporary variables for comparison
  bit [7:0] t_in;
  bit [2:0] t_sel;
  bit       t_expected_out;

  int VECT_CNT, PASS_CNT, ERROR_CNT;

  function new(string name="mux_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aport_drv = new("aport_drv", this);
    aport_mon = new("aport_mon", this);
  endfunction

  // Receive input transaction from the driver
  function void write_drv(mux_sequence_item txn);
    `uvm_info("write_drv STIM", txn.input2string(), UVM_MEDIUM)
    // Predict the expected output
    t_in = txn.in;
    t_sel = txn.sel;
    t_expected_out = t_in[t_sel]; // Expected behavior
  endfunction

  // Compare actual and expected outputs
  function void write_mon(mux_sequence_item txn);
    `uvm_info("write_mon OUT", txn.convert2string(), UVM_MEDIUM)
    if (txn.out === t_expected_out) begin
      PASS();
      `uvm_info("PASS", txn.convert2string(), UVM_MEDIUM)
    end else begin
      ERROR();
      `uvm_info("ERROR [ACTUAL_OP]", txn.convert2string(), UVM_MEDIUM)
      `uvm_info("ERROR [EXPECTED_OP]",
        $sformatf("EXPECTED out: %0b, SEL: %0d", t_expected_out, t_sel),
        UVM_MEDIUM)
    end
  endfunction

  function void PASS();
    VECT_CNT++;
    PASS_CNT++;
  endfunction

  function void ERROR();
    VECT_CNT++;
    ERROR_CNT++;
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (VECT_CNT && !ERROR_CNT)
      `uvm_info("PASSED",
        $sformatf("*** TEST PASSED - %0d vectors ran, %0d vectors passed ***",
        VECT_CNT, PASS_CNT), UVM_LOW)
    else
      `uvm_info("FAILED",
        $sformatf("*** TEST FAILED - %0d vectors ran, %0d vectors passed, %0d vectors failed ***",
        VECT_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
  endfunction

endclass
