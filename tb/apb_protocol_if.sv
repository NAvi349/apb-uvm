interface apb_protocol_if (input logic clock);
	logic [8:0] sig_apb_write_paddr;
	logic [8:0] sig_apb_read_paddr;
	logic [7:0] sig_apb_write_data;    
	logic sig_PRESETn;
	logic sig_READ_WRITE;
	logic sig_transfer;
	logic sig_done_read;
	
	// outputs
	logic [7:0] sig_apb_read_data_out;
	logic sig_PSLVERR;

	// clocking block input monitor
	clocking cb_m @(posedge clock);
		default input #2ns output #5ns;
		input sig_apb_write_paddr;
		input sig_apb_read_paddr;
		input sig_apb_write_data;
		input sig_PRESETn;
		input sig_READ_WRITE;
		input sig_transfer;
	endclocking : cb_m

	// driver
	clocking cb @(posedge clock);
		// default input #2ns output #3ns;
		output sig_PRESETn;
		output sig_transfer;	
		output sig_apb_write_paddr;
		output sig_apb_read_paddr;
		output sig_apb_write_data;
		output sig_READ_WRITE;	
	endclocking : cb

	// write clocking block
	// write data before
	clocking cb_w @(posedge clock);
		// default input #2ns output #5ns;
		output sig_apb_write_paddr;
		output sig_apb_write_data;
		output sig_READ_WRITE;
		output sig_transfer;
	endclocking : cb_w
		
	// read clocking block
	clocking cb_r @(posedge clock);
		// default input #2ns output #5ns;
		output sig_apb_read_paddr;
		output sig_apb_write_paddr;
		output sig_apb_write_data;
		input sig_apb_read_data_out;
		output sig_READ_WRITE;
		output sig_transfer;
		input sig_done_read;
	endclocking : cb_r
	
	// output monitor
	clocking cb_om @(posedge clock);
		// default input #2ns output #3ns;
		input sig_apb_read_data_out;
		input sig_PSLVERR;
		input sig_done_read;
	endclocking
endinterface: apb_protocol_if
