module tree_node_compare(input clk,rst,px_strobe,pixel px_in,node_data node_data_out,
			 output less_than,logic set_structure_node,[`NODE_ID_WIDTH - 1:0]node_id_in,logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address);

   always@(posedge clk)begin
      set_structure_node <= 0;
	if(rst)
	  node_data_address <= 0;
	else if(px_strobe & px_in.status !== NOT_VALID)
	  if(node_data_out.count === px_in.count) begin
	     node_data_address <= node_data_address + 1;
	     set_structure_node <= 1;
	  end
   end

   assign node_id_in = node_data_out.id;
   assign less_than = (px_in.value < node_data_out.value)?1'b1:1'b0;
endmodule 
