module ada_boost(input clk,rst,load_weight,[`WEIGHT_WIDTH - 1:0] weight, [`FOREST_NUM_WIDTH - 1:0] forest_num,
		 [`NUM_FORESTS - 1:0] prediction_valid_array,[`PREDICTION_WIDTH - 1:0] prediction_out_array [`NUM_FORESTS],
		 output logic prediction_valid,[`PREDICTION_WIDTH - 0:1] prediction_out);
   typedef enum {IDLE,SET_CHECK,ITER_CHECK,UPDATE_MAX,DONE} State;
   State cur_state,next_state;

   logic [`WEIGHT_WIDTH - 1:0] weights [`NUM_FORESTS];
   logic [`NUM_FORESTS - 1:0] checked_array;
   logic [`FOREST_NUM_WIDTH - 1:0] check_addr,iter_addr;
   logic [`WEIGHT_WIDTH*2 - 1:0] max_count,cur_count;
   logic [`PREDICTION_WIDTH - 1:0] max_prediction,cur_prediction;


   always @(posedge clk)
     if(load_weight)
       weights[forest_num] <= weight;
   
   always @(posedge clk)
     if(rst)
       cur_state = IDLE;
     else
       cur_state = next_state;

   always@(posedge clk)begin
      next_state <= cur_state;
      prediction_valid <= 0;
      case(cur_state)
	IDLE: begin
	   checked_array <= 0;
	   check_addr <= 0;
	   max_count <= 0;
	   if(&prediction_valid_array && !rst)
	     next_state <= SET_CHECK;
	end
	SET_CHECK: begin
	   if(check_addr < `NUM_FORESTS) begin
	      if(!checked_array[check_addr]) begin
		 checked_array[check_addr] <= 1'b1;
		 cur_count <= weights[check_addr];
		 cur_prediction <= prediction_out_array[check_addr];
		 next_state <= ITER_CHECK;
		 iter_addr <= check_addr + 1;
	      end
	      else
		check_addr = check_addr + 1;
	   end
	   else
	     next_state <= DONE;
	end
	ITER_CHECK:
	  if(iter_addr < `NUM_FORESTS) begin
	     if(!checked_array[iter_addr] && prediction_out_array[iter_addr] === cur_prediction) begin
		cur_count <= cur_count + weights[iter_addr];
		checked_array[iter_addr] <= 1'b1;
	     end
	     iter_addr <= iter_addr + 1;
	  end
	  else
	    next_state <= UPDATE_MAX;
	UPDATE_MAX: begin
 	   if(cur_count > max_count) begin
	      max_prediction <= cur_prediction;
	      max_count <= cur_count;
	   end
	   check_addr <= check_addr + 1;
	   next_state <= SET_CHECK;
	end
	DONE: begin
	   prediction_valid <= 1;
	end
      endcase
   end 
   assign prediction_out = max_prediction;


endmodule
