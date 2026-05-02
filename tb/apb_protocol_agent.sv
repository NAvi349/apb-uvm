class apb_protocol_agent extends uvm_agent;
	uvm_active_passive_enum is_active = UVM_ACTIVE;	
	
	`uvm_component_utils(apb_protocol_agent)
	
	apb_protocol_sequencer apb_p_seqr;
	apb_protocol_driver apb_p_drvr;
	apb_protocol_monitor apb_p_mon;

	// uvm_analysis_port #(apb_protocol_transaction) dut_in_tx_port;
	// uvm_analysis_port #(apb_protocol_read) dut_out_tx_port;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	

		apb_p_mon = apb_protocol_monitor::type_id::create(.name("apb_p_mon"), .parent(this));
		
		if (is_active == UVM_ACTIVE) begin
			apb_p_seqr = apb_protocol_sequencer::type_id::create(.name("apb_p_seqr"), .parent(this));
			apb_p_drvr = apb_protocol_driver::type_id::create(.name("apb_p_drvr"), .parent(this));
		end


		// dut_in_tx_port	= new(.name("dut_in_tx_port"), .parent(this));
		// dut_out_tx_port	= new(.name("dut_out_tx_port"), .parent(this));

		//apb_p_mon_after = apb_protocol_monitor_after::type_id::create(.name("apb_p_mon_after"), .parent(this));

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// dut_in_tx_port.connect(apb_p_mon.dut_in_tx_port);
		// dut_out_tx_port.connect(apb_p_mon.dut_out_tx_port);
		
		if (is_active == UVM_ACTIVE)
			apb_p_drvr.seq_item_port.connect(apb_p_seqr.seq_item_export);

		//apb_p_mon_before.mon_ap_before.connect(agent_ap_before);
		//apb_p_mon_after.mon_ap_after.connect(agent_ap_after);
	endfunction: connect_phase

endclass: apb_protocol_agent
