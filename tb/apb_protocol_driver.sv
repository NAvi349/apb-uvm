class apb_protocol_driver extends uvm_driver#(apb_protocol_transaction);
	`uvm_component_utils(apb_protocol_driver)

	virtual apb_protocol_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//void'(uvm_resource_db#(virtual apb_protocol_if)::read_by_name(.scope("ifs"), .name("apb_protocol_if"), .val(vif)));
		if (!uvm_config_db #(virtual apb_protocol_if)::get(this, "", "apb_protocol_if", vif))
			`uvm_fatal("DRIVER", "Driver failed to get interface handle")
	endfunction: build_phase
	
	task run_phase(uvm_phase phase);
		apb_protocol_transaction tx; // handle or container
		// @(vif.cb);

		reset_dut();

		forever begin
			seq_item_port.get_next_item(tx);
			@(vif.clock);
			drive(tx);	
			@(vif.clock);			
			seq_item_port.item_done();
		end

	endtask: run_phase
	
	virtual task reset_dut();
		`uvm_info("DRIVER", "Start of reset_dut() method", UVM_LOW)

		vif.cb.sig_transfer <= 1'b0;
		vif.cb.sig_apb_write_paddr <= 1'b0;
		vif.cb.sig_apb_read_paddr <= 1'b0;
		vif.cb.sig_apb_write_data <= 1'b0;
		vif.cb.sig_READ_WRITE <= 1'b0;

		vif.cb.sig_PRESETn <= 1'b0;
		@(vif.clock);
		vif.cb.sig_PRESETn <= 1'b1;

		`uvm_info("DRIVER", "End of reset_dut() method", UVM_LOW)
	endtask		

	virtual task drive(apb_protocol_transaction tx);
		//integer counter = 0, state = 0;       
		//logic [7:0] data, expected;
		
		@(vif.clock);
		// vif.cb.sig_apb_write_paddr <= tx.apb_write_paddr;
		// vif.cb.sig_apb_write_data <= tx.apb_write_data;
		// vif.cb.sig_READ_WRITE <= tx.READ_WRITE;
		// vif.cb.sig_transfer <= tx.transfer;
		// vif.cb.sig_apb_read_paddr <= tx.apb_read_paddr;
		// repeat(2) @(vif.cb);

		// old
		// write
		if ((tx.READ_WRITE == 0) && (tx.transfer == 1)) begin		
			`uvm_info("DRIVER", "Driving write packet", UVM_LOW)

			vif.cb_w.sig_apb_write_paddr <= tx.apb_write_paddr;
			vif.cb_w.sig_apb_write_data <= tx.apb_write_data;
			vif.cb_w.sig_READ_WRITE <= tx.READ_WRITE;
			vif.cb_w.sig_transfer <= tx.transfer;
			repeat (4) @(vif.clock);
		end
		// read
		else if ((tx.READ_WRITE == 1) && (tx.transfer == 1)) begin
			`uvm_info("DRIVER", "Driving read packet", UVM_LOW)
			
			vif.cb_w.sig_apb_write_paddr <= tx.apb_write_paddr;
			vif.cb_w.sig_apb_write_data <= tx.apb_write_data;
			vif.cb_r.sig_READ_WRITE <= tx.READ_WRITE;
			vif.cb_r.sig_apb_read_paddr <= tx.apb_read_paddr;
			vif.cb_r.sig_transfer <= tx.transfer;
			repeat (4) @(vif.clock);			
		end

		// old attempt
		/*
		// write ta
		@(vif.cb_w)
		begin	
			if (tx.READ_WRITE == 0)
			begin		
				//`uvm_info("WRITE", $sformatf("%dns Before write: transfer=%0d READ_WRITE=%d write_addr
				vif.cb_w.sig_apb_write_paddr <= tx.apb_write_paddr;
				vif.cb_w.sig_apb_write_data <= tx.apb_write_data;
				vif.cb_w.sig_READ_WRITE <= tx.READ_WRITE;
				vif.cb_w.sig_transfer <= tx.transfer;

				`uvm_info("WRITE", $sformatf("%dns After write: transfer=%0d READ_WRITE=%d read_addr=%h read_data=%h", $time, vif.cb_w.sig_transfer, 
															vif.cb_w.sig_READ_WRITE, 
															vif.cb_w.sig_apb_write_paddr, 
															vif.cb_w.sig_apb_write_data ), 
															UVM_NONE);		
			end
		end

		// read data
		@(vif.cb_r)
		begin		
			if (tx.READ_WRITE == 1) 
			begin
				vif.cb_r.sig_READ_WRITE <= tx.READ_WRITE;
				vif.cb_r.sig_apb_read_paddr <= tx.apb_read_paddr;
			end
		end
		*/

	endtask: drive

endclass: apb_protocol_driver
