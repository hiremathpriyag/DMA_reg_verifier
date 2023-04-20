`define DRV_IF vif.DRIVER.driver_cb

class dma_driver extends uvm_driver #(dma_seq_item);

//virtual interface

virtual dma_if vif;
`uvm_component_utils(dma_driver)

//constructor

function new(string name, uvm_component parent);

 super.new(name,parent);

endfunction

//build phase

function void build_phase(uvm_phase phase);

super.build_phase(phase);

if(!uvm_config_db #(virtual dma_if)::get(this,"","vif",vif))
 `uvm_fatal("NO_VIF", {"virtual interface must be set for : ", get_full_name(),".vif"});
 endfunction
 
 //run phase
 
 virtual task run_phase(uvm_phase phase);
 
 forever begin
 
    seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
 // transaction level to signal level drives the 
 //values from seq_item to interface signals
 
 virtual task drive();
 
 `DRIV_IF.wr_en <= 0;
 @(posedge vif.DRIVER.clk);
    
    `DRIV_IF.addr <= req.addr;

    `DRIV_IF.valid <= 1;
    `DRIV_IF.wr_en <= req.wr_en;
    if(req.wr_en) begin // write operation
      `DRIV_IF.wdata <= req.wdata;
      @(posedge vif.DRIVER.clk);
    end
    else begin //read operation
      @(posedge vif.DRIVER.clk);
      `DRIV_IF.valid <= 0;
      @(posedge vif.DRIVER.clk);
      req.rdata = `DRIV_IF.rdata;
    end
    `DRIV_IF.valid <= 0;
    
  endtask : drive
endclass : dma_driver