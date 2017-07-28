module features_selection(input clk,set_feature_index,[`FOREST_NUM_WIDTH - 1:0] forest_num,[`FEATURE_INDEX_WIDTH - 1:0] feature_index,pixel all_features [`NUM_POSSIBLE_FEATURES],
			  output pixel selected_features [`NUM_FORESTS]);

   logic [`FEATURE_INDEX_WIDTH - 1:0] feature_index_array [`NUM_FORESTS];
   
   always@(posedge clk)
     if(set_feature_index)
       feature_index_array[forest_num] = feature_index;

   always_comb
     for(int i = 0; i < `NUM_FORESTS;i++)
       selected_features[i] = all_features[feature_index_array[i]];
endmodule
