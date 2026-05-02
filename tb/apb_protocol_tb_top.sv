`include "apb_protocol.v"
`include "apb_protocol_if.sv"

module apb_protocol_tb_top;
	import uvm_pkg::*;
	import apb_protocol_pkg::*;

	logic clock; // global clock

	// interface of apb protocol
	apb_protocol_if vif(.clock(clock));

	// connect interface to dut
	apb_protocol dut(clock,
			vif.sig_PRESETn,
			vif.sig_transfer,
			vif.sig_READ_WRITE,
			vif.sig_apb_write_paddr,
			vif.sig_apb_write_data,
			vif.sig_apb_read_paddr,
			vif.sig_PSLVERR,
			vif.sig_apb_read_data_out,
			vif.sig_done_read
			);

	initial begin
		//A set() call in a context higher up the component hierarchy takes precedence over a set() call that occurs lower in the hierarchical path.

		uvm_config_db#(virtual apb_protocol_if)::set(uvm_root::get(), "*", "apb_protocol_if", vif);
		
		// first: context, UVM component object handle
		// second: access to specified components, * indicates all
		// lookup name string	
		// static interface
	end
	
	initial begin
		run_test("apb_protocol_write_read_test");
		//run_test("apb_protocol_write_test");
		//run_test("apb_protocol_read_test");
		//run_test();
		// use +UVM_TESTNAME with vsim terminal argument
	end
	
	// clock initialization
	initial begin
		clock <= 0;

		// clock generation
		forever #5 clock = ~clock;	
	end
endmodule
