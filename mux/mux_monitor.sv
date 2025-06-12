class mux_monitor extends uvm_monitor;
  `uvm_component_utils(mux_monitor)

  // Sequence item class
  mux_sequence_item txn;

  // Virtual interface handle declaration
  virtual interface intf vif;  // Virtual interface to be configured via uvm_config_db

  // Analysis port
  uvm_analysis_port#(mux_sequence_item) ap_mon;

  // Constructor
  function new(string name="mux_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get the virtual interface from uvm_config_db
    if (!(uvm_config_db#(virtual interface intf)::get(this, "", "vif", vif))) begin
      `uvm_fatal("monitor", "unable to get interface")
    end

    // Initialize the analysis port and sequence item
    ap_mon = new("ap_mon", this);
    txn = mux_sequence_item::type_id::create("txn", this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    forever begin

      @(vif.in or vif.sel or vif.out); 
      txn.in  = vif.in;
      txn.sel = vif.sel;
      txn.out = vif.out;
      ap_mon.write(txn);
      void'(txn.convert2string()); // Suppress the warning (optional)
    end
  endtask
endclass
