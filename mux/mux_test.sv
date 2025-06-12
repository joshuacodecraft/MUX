class mux_test extends uvm_test;


    `uvm_component_utils(mux_test)



    function new(string name = "mux_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    mux_env env_h;
    int file_h;

    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Correct use of 'this'
        env_h = mux_env::type_id::create("env_h", this);
    endfunction

    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TOPOLOGY", "Printing UVM topology after elaboration phase", UVM_LOW)
        uvm_top.print_topology(); // Print the UVM topology
    endfunction
    
    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        $display("start_of_simulation_phase");
        file_h = $fopen("LOG_FILE.log", "w");
        // Correct hierarchical report settings
        set_report_default_file_hier(file_h);
        set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        set_report_verbosity_level_hier(UVM_MEDIUM);
    endfunction
    
    task run_phase(uvm_phase phase);
        mux_sequence seq1;
        sel_000 seq2_1, seq2_2;
        sel_111 seq3_1, seq3_2;
        sel_all seq4_1, seq4_2;

        phase.raise_objection(this);

        // Correct sequence creation
        seq1 = mux_sequence::type_id::create("seq1", this);
        seq2_1 = sel_000::type_id::create("seq2_1", this);
        seq3_1 = sel_111::type_id::create("seq3_1", this);
        seq4_1 = sel_all::type_id::create("seq4_1", this);

        // Start the sequences
        seq1.start(env_h.agent_h.sequencer_h);
        seq2_1.start(env_h.agent_h.sequencer_h);
        seq3_1.start(env_h.agent_h.sequencer_h);
        seq4_1.start(env_h.agent_h.sequencer_h);

        phase.drop_objection(this);
    endtask
    

endclass
