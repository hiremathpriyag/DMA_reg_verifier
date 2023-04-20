class dma_sequencer extends uvm_sequencer#(dma_seq_item);

  `uvm_component_utils(dma_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass