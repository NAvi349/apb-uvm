// container for agents, scoreboards,
// reusing block-level environment components at the SoC level

class apb_protocol_env extends uvm_env;
	`uvm_component_utils(apb_protocol_env)

	apb_protocol_agent apb_p_agent;
	apb_protocol_scoreboard apb_p_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_p_agent	= apb_protocol_agent::type_id::create("apb_p_agent", this);
		apb_p_sb	= apb_protocol_scoreboard::type_id::create("apb_p_sb", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_p_agent.apb_p_mon.dut_out_tx_port.connect(apb_p_sb.out_export);
		apb_p_agent.apb_p_mon.dut_in_tx_port.connect(apb_p_sb.in_export);

		//apb_p_agent.dut_in_tx_port.connect(apb_p_sb.dut_in_pass_port);
		//apb_p_agent.dut_out_tx_port.connect(apb_p_sb.dut_out_pass_port);
	endfunction: connect_phase

endclass: apb_protocol_env


