package apb_protocol_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	`include "apb_protocol_sequencer.sv"
	`include "apb_protocol_monitor.sv"
	`include "apb_protocol_driver.sv"
	`include "apb_protocol_agent.sv"
	`include "apb_protocol_scoreboard.sv"
	//`include "apb_protocol_eval.sv"
	`include "apb_protocol_config.sv"
	`include "apb_protocol_env.sv"
	`include "apb_protocol_test.sv"
	
endpackage: apb_protocol_pkg
