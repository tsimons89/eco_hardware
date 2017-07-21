module tree(input clk,rst,px_strobe,load_node,load_prediction,pixel px_in,node_data node_in,[`PREDICTION_WIDTH - 1:0] prediction_in,
	    output prediction_valid,[`PREDICTION_WIDTH - 1:0] prediction_out);
   logic set_structure_node,less_than,valid_prediction_idx;
   logic [`NODE_ID_WIDTH - 1:0]node_id_in,prediction_idx;
   node_data node_data_out;
   logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address;

   
   tree_structure my_struct(.*);
   tree_node_compare my_compare(.*,.px_in(px_in),.node_data_out(node_data_out));
   tree_node_data my_node_data(.*,.node_in(node_in),.node_data_out(node_data_out));
   tree_prediction_data my_prediction_data(.*);
endmodule
