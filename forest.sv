module forest(input clk,rst,px_strobe,load_node,load_prediction,pixel px_in,node_data node_in,[`PREDICTION_WIDTH - 1:0] prediction_in, [`TREE_NUM_WIDTH - 1:0] tree_num,
	    output prediction_valid,[`PREDICTION_WIDTH - 1:0] prediction_out);

   logic [`NUM_TREES - 1:0] load_node_array;
   logic [`NUM_TREES - 1:0] load_prediction_array;
   logic [`PREDICTION_WIDTH - 1:0] prediction_out_array [`NUM_TREES];
   logic [`NUM_TREES - 1:0] prediction_valid_array;

   assign load_node_array = (load_node)?1<<tree_num:0;
   assign load_prediction_array = (load_prediction)?1<<tree_num:0;
   tree my_tree_0(.*,
		  .prediction_valid(prediction_valid_array[0]),
		  .load_node(load_node_array[0]),
		  .load_prediction(load_prediction_array[0]),
		  .prediction_out(prediction_out_array[0]),
		  .node_in(node_in),
		  .px_in(px_in));
   
   tree my_tree_1(.*,
		  .prediction_valid(prediction_valid_array[1]),
		  .load_node(load_node_array[1]),
		  .load_prediction(load_prediction_array[1]),
		  .prediction_out(prediction_out_array[1]),
		  .node_in(node_in),
		  .px_in(px_in));
   
   tree my_tree_2(.*,
		  .prediction_valid(prediction_valid_array[2]),
		  .load_node(load_node_array[2]),
		  .load_prediction(load_prediction_array[2]),
		  .prediction_out(prediction_out_array[2]),
		  .node_in(node_in),
		  .px_in(px_in));
   
   tree my_tree_3(.*,
		  .prediction_valid(prediction_valid_array[3]),
		  .load_node(load_node_array[3]),
		  .load_prediction(load_prediction_array[3]),
		  .prediction_out(prediction_out_array[3]),
		  .node_in(node_in),
		  .px_in(px_in));
   
   tree my_tree_4(.*,
		  .prediction_valid(prediction_valid_array[4]),
		  .load_node(load_node_array[4]),
		  .load_prediction(load_prediction_array[4]),
		  .prediction_out(prediction_out_array[4]),
		  .node_in(node_in),
		  .px_in(px_in));
   
/* -----\/----- EXCLUDED -----\/-----
   genvar i;
   for(i = 1;i < `NUM_TREES; i++ )
     tree my_tree(.*,
		  .prediction_valid(prediction_valid_array[i]),
		  .load_node(load_node_array[i]),
		  .load_prediction(load_prediction_array[i]),
		  .prediction_out(prediction_out_array[i]),
		  .node_in(node_in),
		  .px_in(px_in));
 -----/\----- EXCLUDED -----/\----- */

   forest_prediction my_forest_prediction(.*);
	      
endmodule
