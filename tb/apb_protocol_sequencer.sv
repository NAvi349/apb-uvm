// input transaction
class apb_protocol_transaction extends uvm_sequence_item;

	bit [8:0] apb_write_paddr;
	bit [8:0] apb_read_paddr;
	rand bit [7:0] apb_write_data;
	bit READ_WRITE;	
	
	bit PRESETn;	
	bit transfer;

	function new(string name = "");
		super.new(name);
	endfunction: new

	virtual function string convert2str();
    	return $sformatf("write_paddr=0x%0h read_paddr=0x%0h write_data=0x%0h READ_WRITE=%0b PRESETn=%0b transfer=%0b", apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE, PRESETn, transfer);
  	endfunction

	// macros do macros
	`uvm_object_utils_begin(apb_protocol_transaction)
		`uvm_field_int(apb_write_paddr, UVM_ALL_ON)
		`uvm_field_int(apb_read_paddr, UVM_ALL_ON)
		`uvm_field_int(apb_write_data, UVM_ALL_ON)
		`uvm_field_int(PRESETn, UVM_ALL_ON)
		`uvm_field_int(READ_WRITE, UVM_ALL_ON)
		`uvm_field_int(transfer, UVM_ALL_ON)
	`uvm_object_utils_end

endclass: apb_protocol_transaction

class apb_protocol_read extends uvm_sequence_item;
	// outputs
	bit [7:0] apb_read_data_out;
	bit PSLVERR;
	bit done_read;

	function new(string name = "");
		super.new(name);
	endfunction: new

	virtual function string convert2str();
    	return $sformatf("read_data_out=0x%0h PSLVERR=%0b done_read=%0b", apb_read_data_out, PSLVERR, done_read);
  	endfunction

	`uvm_object_utils_begin(apb_protocol_read)
		`uvm_field_int(apb_read_data_out, UVM_ALL_ON)
		`uvm_field_int(PSLVERR, UVM_ALL_ON)
		`uvm_field_int(done_read, UVM_ALL_ON)
	`uvm_object_utils_end

endclass: apb_protocol_read

typedef uvm_sequencer#(apb_protocol_transaction) apb_protocol_sequencer;
//class apb_protocol_sequencer extends uvm_sequencer #(apb_protocol_transaction);
//	
//	function new (string name, uvm_component parent);
//		super.new(name, parent);
//		`uvm_update_sequence_lib_and_item(apb_protocol_transaction)
//	endfunction
//	
//	`uvm_sequencer_utils(apb_protocol_sequencer)
//endclass

class apb_protocol_write_read_sequence extends uvm_sequence#(apb_protocol_transaction);
	
	apb_protocol_transaction req;	
	
	`uvm_object_utils(apb_protocol_write_read_sequence)
	//`uvm_sequence_utils(apb_protocol_write_read_sequence, apb_protocol_sequencer)

	function new(string name = "");
		super.new(name);
	endfunction: new
	
	virtual task body();

		for (int i = 2; i < 5; i++) begin
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());	// only write data randomized
			`uvm_info("SEQ", $sformatf("Generate new slave 1 write item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b0;	
			req.apb_write_paddr = 9'b0_0000_0000 + i;		
			req.print();
			finish_item(req);
		end
		
		// slave 2 write
		for (int i = 2; i < 5; i++) begin
			// write to slave 2 MSB address is set to 1
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());	// only write data randomized
			`uvm_info("SEQ", $sformatf("Generate new slave 2 write item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b0;	
			req.apb_write_paddr = 9'b1_0000_0000 + i;
			req.print();		
			finish_item(req);
		end

		// slave 1 read
		for (int i = 2; i < 5; i++) begin
			// read
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			`uvm_info("SEQ", $sformatf("Generate new slave 1 read item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b1;	
			req.apb_write_paddr = 0;
			req.apb_read_paddr = 9'b0_0000_0000 + i;	
			req.print();
			finish_item(req);
		end
		
		// slave 2 read
		for (int i = 2; i < 5; i++) begin
			// read
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			`uvm_info("SEQ", $sformatf("Generate new slave 2 read item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b1;	
			req.apb_write_paddr = 0;
			req.apb_read_paddr = 9'b1_0000_0000 + i;	
			req.print();
			finish_item(req);
		end
	endtask: body

endclass: apb_protocol_write_read_sequence

class apb_protocol_write_sequence extends uvm_sequence#(apb_protocol_transaction);
	
	apb_protocol_transaction req;	
	
	`uvm_object_utils(apb_protocol_write_sequence)
	//`uvm_sequence_utils(apb_protocol_write_sequence, apb_protocol_sequencer)

	function new(string name = "");
		super.new(name);
	endfunction: new
	
	virtual task body();

	for (int i = 2; i < 5; i++) begin
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());	// only write data randomized
			`uvm_info("SEQ", $sformatf("Generate new write item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b0;	
			req.apb_write_paddr = 9'b0_0000_0000 + i;		
			req.print();
			finish_item(req);
		end

		for (int i = 2; i < 5; i++) begin
			// write to slave 2 MSB address is set to 1
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());	// only write data randomized
			`uvm_info("SEQ", $sformatf("Generate new write item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b0;	
			req.apb_write_paddr = 9'b1_0000_0000 + i;
			req.print();		
			finish_item(req);
		end
	endtask: body

endclass: apb_protocol_write_sequence


class apb_protocol_read_sequence extends uvm_sequence#(apb_protocol_transaction);
	
	apb_protocol_transaction req;	
	
	`uvm_object_utils(apb_protocol_read_sequence)
	//`uvm_sequence_utils(apb_protocol_read_sequence, apb_protocol_sequencer)

	function new(string name = "");
		super.new(name);
	endfunction: new
	
	virtual task body();
		for (int i = 2; i < 5; i++) begin
			// read
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			`uvm_info("SEQ", $sformatf("Generate new read item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b1;	
			req.apb_read_paddr = 9'b0_0000_0000 + i;	
			req.print();
			finish_item(req);
		end

		for (int i = 2; i < 5; i++) begin
			// read
			req = apb_protocol_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			`uvm_info("SEQ", $sformatf("Generate new read item: "), UVM_LOW)
			req.PRESETn = 1'b1;
			req.transfer = 1'b1;
			req.READ_WRITE = 1'b1;	
			req.apb_read_paddr = 9'b1_0000_0000 + i;	
			req.print();
			finish_item(req);
		end
	endtask: body

endclass: apb_protocol_read_sequence
