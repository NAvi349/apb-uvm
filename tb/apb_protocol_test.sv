`include "uvm_macros.svh"
import uvm_pkg::*;
// initiates the environment component construction
// baseclass test
class apb_protocol_test extends uvm_test;
	`uvm_component_utils(apb_protocol_test)
		
	apb_protocol_env apb_p_env;
	//apb_protocol_config apb_p_cfg;	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
		
	function void build_phase(uvm_phase phase);	
		//super.build_phase(phase);
		apb_p_env = apb_protocol_env::type_id::create(.name("apb_p_env"), .parent(this));
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);	// simulation time
		// apb_protocol_sequence apb_p_seq;
		
		phase.raise_objection(.obj(this));
			// apb_p_seq = apb_protocol_sequence::type_id::create(.name("apb_p_seq"), .contxt(get_full_name()));
			// assert(apb_p_seq.randomize());
			// apb_p_seq.start(apb_p_env.apb_p_agent.apb_p_seqr);
		phase.drop_objection(.obj(this));

	endtask: run_phase

      virtual function void end_of_elaboration_phase (uvm_phase phase); // zero simulation time
         uvm_top.print_topology ();
      endfunction

endclass: apb_protocol_test

// write to a location
class apb_protocol_write_test extends apb_protocol_test;
	//`uvm_component_utils(apb_protocol_write_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		apb_protocol_write_sequence apb_p_w_seq;

		phase.raise_objection(.obj(this));
			apb_p_w_seq = apb_protocol_write_sequence::type_id::create(.name("apb_p_w_seq"), .contxt(get_full_name()));
			apb_p_w_seq.start(apb_p_env.apb_p_agent.apb_p_seqr);
		phase.drop_objection(.obj(this));
	endtask: run_phase
endclass

// read from a location
class apb_protocol_read_test extends apb_protocol_test;
	//`uvm_component_utils(apb_protocol_read_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		apb_protocol_read_sequence apb_p_r_seq;

		phase.raise_objection(.obj(this));
			apb_p_r_seq = apb_protocol_read_sequence::type_id::create(.name("apb_p_r_seq"), .contxt(get_full_name()));
			apb_p_r_seq.start(apb_p_env.apb_p_agent.apb_p_seqr);
		phase.drop_objection(.obj(this));
	endtask: run_phase
endclass

// write and read from a location
class apb_protocol_write_read_test extends apb_protocol_test;
	//`uvm_component_utils(apb_protocol_write_read_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		apb_protocol_write_read_sequence apb_p_w_r_seq;

		phase.raise_objection(.obj(this));
			apb_p_w_r_seq = apb_protocol_write_read_sequence::type_id::create(.name("apb_p_w_r_seq"), .contxt(get_full_name()));
			apb_p_w_r_seq.start(apb_p_env.apb_p_agent.apb_p_seqr);
		phase.drop_objection(.obj(this));
	endtask: run_phase
endclass
