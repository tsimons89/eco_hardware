module tree_structure(input clk,rst,less_than,set_structure_node,[`NODE_ID_WIDTH - 1:0]node_id_in,output valid_prediction_idx, logic [`NODE_ID_WIDTH - 1:0] prediction_idx);
   parameter DEPTH = `TREE_DEPTH;
   localparam NUM_LEAVES = 2**DEPTH;
   localparam NUM_NODES = (2**DEPTH) - 1;
   localparam ROOT_ID = 2**(DEPTH - 1) - 1;

   logic [NUM_NODES - 1:0]branches;
   logic [NUM_LEAVES - 1:0]leaves;
   logic [NUM_NODES - 1:0] set_array;
   
   assign set_array = (set_structure_node)?1 << node_id_in:0;
   
   genvar i,id;
   for( i = 0; i < DEPTH;i++)
     for(id = 2**(i+1) - 1; id < NUM_NODES; id = id + 2**(i+2))
       tree_node leaf_node(.*,.set(set_array[id]),.left_branch(branches[id - 2**i]),.right_branch(branches[id + 2**i]),.parent_branch(branches[id]));
       
   for(id = 0;id < NUM_NODES;id = id + 2)
     tree_node leaf_node(.*,.set(set_array[id]),.left_branch(leaves[id]),.right_branch(leaves[id + 1]),.parent_branch(branches[id]));

		      

   assign branches[ROOT_ID] = 1'b1;
   assign valid_prediction_idx = |leaves;
   always_comb begin
      prediction_idx = 0;
      for(int i = 0; i < NUM_LEAVES; i++)
	if(leaves[i])
	  prediction_idx = i;
   end
endmodule
