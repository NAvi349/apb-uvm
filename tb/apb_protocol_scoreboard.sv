// `uvm_analysis_imp_decl(_in)
// `uvm_analysis_imp_decl(_out)

class apb_protocol_scoreboard extends uvm_scoreboard;
// for APB use out-of-order scoreboard
	`uvm_component_utils(apb_protocol_scoreboard)

	apb_protocol_read tx_out;
	apb_protocol_transaction tx_in;

	// uvm_analysis_imp_out #(apb_protocol_read, apb_protocol_scoreboard) out_export;
	// uvm_analysis_imp_in #(apb_protocol_transaction, apb_protocol_scoreboard) in_export;

	uvm_analysis_export #(apb_protocol_read) out_export;
	uvm_analysis_export #(apb_protocol_transaction) in_export;

	uvm_tlm_analysis_fifo #(apb_protocol_read) out_fifo;
	uvm_tlm_analysis_fifo #(apb_protocol_transaction) in_fifo;
	
	int item_q[*] ; // internal memory

	bit [7:0] actual_output;	
	bit [7:0] expected_output;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		// actual_output	= new("actual_output");
		// expected_output	= new("expected_output");

	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		out_fifo	= new("out_fifo", this);
		in_fifo		= new("in_fifo", this);
		out_export	= new("out_export", this);
		in_export	= new("in_export", this);

		// `uvm_info("SCOREBOARD", "Scoreboard build phase", UVM_NONE)
	endfunction: build_phase

	function void connect_phase (uvm_phase phase);
		in_export.connect(in_fifo.analysis_export);
		out_export.connect(out_fifo.analysis_export);
	endfunction: connect_phase

	task run_phase(uvm_phase phase);
	tx_in = new();
	tx_out = new();

		forever begin
			fork 
				begin
					in_fifo.get(tx_in);
					// $display("Input debug");					
					process_input();						
				end
								
				begin							
					out_fifo.get(tx_out);
					actual_output = tx_out.apb_read_data_out;	
					
				end			
				
			join
			// `uvm_info("SCOREBOARD", $sformatf("inFIFO=%s", tx_in.apb_read_paddr), UVM_LOW)
				
			if (tx_out.done_read == 1) begin
				`uvm_info("SCOREBOARD", $sformatf("DONE_READ"), UVM_NONE)
				if (tx_in.READ_WRITE == 1) begin
					if (actual_output != expected_output) begin
						`uvm_info("SCOREBOARD", $sformatf("MISMATCH ACT=0x%0h EXP=0x%0h", actual_output, expected_output), UVM_NONE)
					end
				

					else begin
						`uvm_info("SCOREBOARD", $sformatf("DATA READ BACK SUCCESSFULLY ACT=0x%0h EXP=0x%0h", actual_output, expected_output), UVM_NONE)
					end
				end
			end
				
			// join
			// compare_data();
				// $display("COMPARE");
				// in_fifo.get(in_txn);
				// $display("LOL");
				// predictor();
				// out_fifo.get(actual_output);
				// $display("SCORE");
				// if (expected_output.apb_read_data_out != actual_output.apb_read_data_out) begin
				// 	`uvm_error(get_full_name(), $sformatf("EXP= ACTUAL=,"))
				// end
				// else begin
				// 	`uvm_info(get_full_name(), $sformatf("READ BACK SUCCESSFULLY"), UVM_NONE)
				// end
			end
	endtask: run_phase

	// virtual task automatic write_in(apb_protocol_transaction tx_in);
	// 	`uvm_info(get_type_name(), $sformatf("from in_monitor" ), UVM_NONE)
	// 	// in_fifo.put(tx_in);
	// endtask

	// virtual task automatic write_out(apb_protocol_read tx_out);
	// 	`uvm_info(get_type_name(), $sformatf("from out_mon"), UVM_NONE)
	// 	// out_fifo.put(tx_out);
	// endtask

	virtual function automatic void process_input ();
		// predict expected output from input transaction

		// expected_output[tx_in] = expected_out_q
		// expected_out_q.push_back(tx_in);

		// write into an associative array
		if (tx_in.transfer) begin
			if (tx_in.READ_WRITE == 0) begin
				// `uvm_info("SCOREBOARD", "Internal memory model", UVM_NONE)
				item_q[tx_in.apb_write_paddr] = tx_in.apb_write_data[7:0];			
			end

			// read
			else begin	
				// `uvm_info("SCOREBOARD", "READ Internal memory model", UVM_NONE)
				expected_output = item_q[tx_in.apb_read_paddr];			
			end
		end
	endfunction

	// virtual task automatic compare();
	// 	`uvm_info("compare", {"Dummy compare!"}, UVM_NONE)
	// 	`uvm_info("BUILD", "msg", UVM_NONE)
	// 	`uvm_warning("DUT Outputs", "Dummy outputs")
	// 	// `uvm_info("Actual output=", {actual_output.apb_read_data_out}, UVM_NONE);

	//   //if(actual_output.out == expected_output.out) begin
	//  //      `uvm_info("compare", {"Test: OK!"}, UVM_LOW);
	//  // end else begin
	//    //    `uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
	//   //end
	// endtask: compare

	// virtual task write_act (apb_protocol_read data);
	// 	$display("Hello test");
	// 	`uvm_info("SCOREBOARD", data.convert2str(), UVM_NONE)		
	// endtask

	// virtual task write_exp (apb_protocol_transaction data);
	// 	`uvm_info("SCOREBOARD", data.convert2str(), UVM_NONE)
	// endtask

endclass: apb_protocol_scoreboard
