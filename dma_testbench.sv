import uvm_pkg::*;

`include "uvm_macros.svh"

//including interface and testcase files 

`include "dma_interface.sv"
`include "dma_test.sv"

module testbench;

//clock and reset signal declaration

bit clk;
bit reset;

//clock generation

always #5 clk = ~clk;

//reset generation 

initial begin
reset=1;
#5 reset=0;
end

//interface instance
dma_if intf(clk,reset);

//DUT instance

DMA DUT (.clk(intf.clk),
         .reset(intf.reset),
		 .addr(intf.addr),
		 .wr_en(intf.wr_en),
		 .valid(intf.valid),
		 .wdata(intf.wdata),
		 .rdata(intf.radta)
);

//passing the interface hande to lower heirarchy using set method

initial begin 

uvm_config_db#(virtual dma_if)::set(uvm_root::get(),"*","vif",intf);

end 

//calling test 

initial begin

	run_test();
	uvm_top.print_topology();

end
endmodule 