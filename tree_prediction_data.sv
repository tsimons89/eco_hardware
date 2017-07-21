module tree_prediction_data(input clk,rst,load_prediction_in,
			    [`PREDICTION_DATA_ADDRESS_WIDTH -1:0] prediction_idx,[`PREDICTION_WIDTH - 1:0]prediction_in,
			    output [`PREDICTION_WIDTH - 1:0] prediction_out);
   
   logic [`PREDICTION_DATA_ADDRESS_WIDTH :0] pred_ptr;
   logic [`PREDICTION_WIDTH - 1:0] predictions[`NUM_PREDICTIONS];

   always@(posedge clk)
     if(rst)
       pred_ptr <= 0;
     else if(load_prediction_in)begin
	predictions[pred_ptr] <= prediction_in;
	pred_ptr <= pred_ptr + 1;
     end
   assign prediction_out = predictions[prediction_idx];
       
   
   
endmodule
