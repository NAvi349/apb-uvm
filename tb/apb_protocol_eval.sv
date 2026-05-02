class apb_protocol_eval extends uvm_component;

	uvm_analysis_export #(apb_protocol_transaction) expected_export
	uvm_analysis_export #(apb_protocol_read) actual_export;
	
	uvm_tlm_analysis_fifo #(apb_protocol_transaction) expected_fifo;
	uvm_tlm_analysis_fifo #(apb_protocol_read) actual_fifo;
	
	`uvm_component_utils(apb_protocol_eval);	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);		
		actual_fifo = new("actual_fifo", this);
		expected_fifo = new("expected_fifo", this);
		
		actual_export = new("actual_export", this);
		expected_export = new("expected_export", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		expected_export.connect(expected_fifo.analysis_export);
		actual_export.connect(actual_fifo.analysis_export);
	endfunction: connect_phase

	task run_phase(uvm_phase phase);
		apb_protocol_read actual_txn;
		
		// compare function
		forever begin
			//get value from fifo to transaction object
			//exptected_fifo.get(expected_txn);		
		
			actual_fifo.get(actual_txn);

			`uvm_info("Evaluator dummy", $sformatf("%s GOT=", actual_txn.convert2string()), UVM_DEFAULT)
		end

	endtask: run_phase

	function void report_phase(uvm_phase phase);
		`uvm_info("EVAL", "Scoreboard finished", UVM_NONE)
	
	endfunction: report_phase

endclass
