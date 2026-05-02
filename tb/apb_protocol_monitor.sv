class apb_protocol_monitor extends uvm_monitor;
	`uvm_component_utils(apb_protocol_monitor)

	apb_protocol_transaction apb_p_tx;
	apb_protocol_read apb_p_tx_out;

	function new(string name, uvm_component parent);
		super.new(name, parent);

	endfunction: new
	
	virtual apb_protocol_if vif;

	uvm_analysis_port #(apb_protocol_transaction) dut_in_tx_port;
	uvm_analysis_port #(apb_protocol_read) dut_out_tx_port;

	function void build_phase(uvm_phase phase);	
		//super.build_phase(phase);
		
		//void'(uvm_resource_db#(virtual apb_protocol_if)::read_by_name(.scope("ifs"), .name("apb_protocol_if"), .val(vif)));
		dut_in_tx_port = new("dut_in_tx_port", this);
		dut_out_tx_port = new("dut_out_tx_port", this);
		
		if (!uvm_config_db #(virtual apb_protocol_if)::get(this, "", "apb_protocol_if", vif))
			`uvm_fatal("MONITOR", "No virtual interface found for uvm_monitor")
			
	endfunction: build_phase


	task run_phase(uvm_phase phase);
		integer counter_mon = 0, state = 0;
		
		fork 
			forever begin	// monitor DUT inputs
				apb_p_tx = apb_protocol_transaction::type_id::create("apb_p_tx");
				get_inputs();
				`uvm_info("INPUT MON", $sformatf("%s", apb_p_tx.convert2str()), UVM_LOW)
				// apb_p_tx.print();
				@(vif.clock);
				dut_in_tx_port.write(apb_p_tx);
			end
	
			forever begin	// monitor DUT outputs
				apb_p_tx_out = apb_protocol_read::type_id::create("apb_p_tx_out");
				get_outputs();
				// if (apb_p_tx_out.done_read)
				`uvm_info("OUTPUT MON", $sformatf("%s", apb_p_tx_out.convert2str()), UVM_LOW)
				// apb_p_tx_out.print();
				// repeat (3) @(vif.clock);
				@(vif.clock);
				dut_out_tx_port.write(apb_p_tx_out);
			end
		join

	endtask: run_phase

	virtual task automatic get_inputs();		
		// @(vif.cb_m);
		apb_p_tx.apb_write_paddr = vif.cb_m.sig_apb_write_paddr;
		apb_p_tx.apb_read_paddr = vif.cb_m.sig_apb_read_paddr;
		apb_p_tx.apb_write_data = vif.cb_m.sig_apb_write_data;
		apb_p_tx.READ_WRITE = vif.cb_m.sig_READ_WRITE;
		apb_p_tx.transfer = vif.cb_m.sig_transfer;
		apb_p_tx.PRESETn = vif.cb_m.sig_PRESETn;
	endtask: get_inputs

	virtual task automatic get_outputs();		
		// @(vif.cb_om);
		apb_p_tx_out.apb_read_data_out = vif.cb_om.sig_apb_read_data_out;
		apb_p_tx_out.PSLVERR = vif.cb_om.sig_PSLVERR;
		apb_p_tx_out.done_read = vif.cb_om.sig_done_read;

	endtask: get_outputs

endclass: apb_protocol_monitor


