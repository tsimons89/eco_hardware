module tree_node_data(input clk,rst,load_node,[`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address ,node_data node_in,output  node_data node_data_out);
   node_data data [`NUM_NODES];
   logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] data_ptr;
   always @(posedge clk)begin
      if(rst)
	  data_ptr <= 0;
      else if(load_node) begin
	 data_ptr <= data_ptr + 1;
	 data[data_ptr] <= node_in;
      end
   end

   assign node_data_out = data[node_data_address];
   
endmodule
