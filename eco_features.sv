module eco_features(input clk,rst,
		    px_strobe,load_node,load_prediction,set_feature_index,load_weight,
		    [`PIXEL_WIDTH - 1:0] px_value,
		    [`FEATURE_INDEX_WIDTH - 1:0] feature_index,
		    node_data node_in,
		    [`PREDICTION_WIDTH - 1:0] prediction_in,
		    [`WEIGHT_WIDTH - 1:0] weight,
		    [`TREE_NUM_WIDTH - 1:0] tree_num,
		    [`FOREST_NUM_WIDTH - 1:0] forest_num,
		    output prediction_valid,
		    [`PREDICTION_WIDTH - 1:0] prediction_out);

   pixel all_features[`NUM_POSSIBLE_FEATURES];
   pixel selected_features[`NUM_FORESTS];
   logic [`NUM_FORESTS - 1:0] load_node_array;
   logic [`NUM_FORESTS - 1:0] load_prediction_array;
   logic [`NUM_FORESTS - 1:0] prediction_valid_array;
   logic [`PREDICTION_WIDTH - 1:0] prediction_out_array [`NUM_FORESTS];

   assign load_node_array = (load_node)?1<<forest_num:0;
   assign load_prediction_array = (load_prediction)?1<<forest_num:0;
   
   features my_features(.*,.features_out(all_features));
   
   features_selection my_features_selection(.*,.all_features(all_features),
					    .selected_features(selected_features));

   forest my_forest_0(.*,.load_node(load_node_array[0]),
		      .load_prediction(load_prediction_array[0]),
		      .node_in(node_in),
		      .px_in(selected_features[0]),
		      .prediction_valid(prediction_valid_array[0]),
		      .prediction_out(prediction_out_array[0]));
   
   forest my_forest_1(.*,.load_node(load_node_array[1]),
		      .load_prediction(load_prediction_array[1]),
		      .node_in(node_in),
		      .px_in(selected_features[1]),
		      .prediction_valid(prediction_valid_array[1]),
		      .prediction_out(prediction_out_array[1]));
   
   forest my_forest_2(.*,.load_node(load_node_array[2]),
		      .load_prediction(load_prediction_array[2]),
		      .node_in(node_in),
		      .px_in(selected_features[2]),
		      .prediction_valid(prediction_valid_array[2]),
		      .prediction_out(prediction_out_array[2]));
   
   forest my_forest_3(.*,.load_node(load_node_array[3]),
		      .load_prediction(load_prediction_array[3]),
		      .node_in(node_in),
		      .px_in(selected_features[3]),
		      .prediction_valid(prediction_valid_array[3]),
		      .prediction_out(prediction_out_array[3]));
   
   forest my_forest_4(.*,.load_node(load_node_array[4]),
		      .load_prediction(load_prediction_array[4]),
		      .node_in(node_in),
		      .px_in(selected_features[4]),
		      .prediction_valid(prediction_valid_array[4]),
		      .prediction_out(prediction_out_array[4]));
   
   forest my_forest_5(.*,.load_node(load_node_array[5]),
		      .load_prediction(load_prediction_array[5]),
		      .node_in(node_in),
		      .px_in(selected_features[5]),
		      .prediction_valid(prediction_valid_array[5]),
		      .prediction_out(prediction_out_array[5]));
   
   forest my_forest_6(.*,.load_node(load_node_array[6]),
		      .load_prediction(load_prediction_array[6]),
		      .node_in(node_in),
		      .px_in(selected_features[6]),
		      .prediction_valid(prediction_valid_array[6]),
		      .prediction_out(prediction_out_array[6]));
   
   forest my_forest_7(.*,.load_node(load_node_array[7]),
		      .load_prediction(load_prediction_array[7]),
		      .node_in(node_in),
		      .px_in(selected_features[7]),
		      .prediction_valid(prediction_valid_array[7]),
		      .prediction_out(prediction_out_array[7]));
   
   forest my_forest_8(.*,.load_node(load_node_array[8]),
		      .load_prediction(load_prediction_array[8]),
		      .node_in(node_in),
		      .px_in(selected_features[8]),
		      .prediction_valid(prediction_valid_array[8]),
		      .prediction_out(prediction_out_array[8]));
   
   forest my_forest_9(.*,.load_node(load_node_array[9]),
		      .load_prediction(load_prediction_array[9]),
		      .node_in(node_in),
		      .px_in(selected_features[9]),
		      .prediction_valid(prediction_valid_array[9]),
		      .prediction_out(prediction_out_array[9]));
   

   ada_boost my_ada_boost(.*);







   
   
endmodule
