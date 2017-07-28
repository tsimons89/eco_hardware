module tree_node_compare(input clk,rst,px_strobe,pixel px_in,node_data node_data_out,
			 output logic less_than, set_structure_node,logic [`NODE_ID_WIDTH - 1:0]node_id_in,logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address);

   always@(posedge clk)begin
      set_structure_node <= 0;
	if(rst)
	  node_data_address <= 0;
	else if(node_data_out.count === 0 && node_data_out.value === 0)begin
	     node_data_address <= node_data_address + 1;
	     set_structure_node <= 1;
	     node_id_in <= node_data_out.id;
	     less_than <= 0;
	end
	else if(px_strobe & px_in.status !== NOT_VALID)
	  if(node_data_out.count === px_in.count) begin
	     node_data_address <= node_data_address + 1;
	     set_structure_node <= 1;
	     node_id_in <= node_data_out.id;
	     less_than <= (px_in.value < node_data_out.value)?1'b1:1'b0;
	  end
   end

endmodule 
