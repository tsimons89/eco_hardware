//`include "globals.svh"
//`include "eco_types.sv"
//`include "feature_transform.sv"
import eco_types::*;
module features(input clk, rst, frame_start,px_strobe, [`PIXEL_WIDTH -1:0]px_value,output pixel features_out [`NUM_POSSIBLE_FEATURES]);
  
   logic[`PIXEL_VALUE_WIDTH - 1:0] value_in;
   logic[`PIXEL_COUNT_WIDTH - 1:0] line_count;
   assign features_out[0].value = value_in;

   always@(posedge clk)
     if(rst)begin
	features_out[0].count <= -1;
	value_in <= 0;
	line_count <= 0;
	features_out[0].status <= FRAME_START;
     end
     else if(px_strobe) begin
	features_out[0].count <= features_out[0].count + 1;
	value_in <= px_value;
	if(line_count == `IMAGE_WIDTH - 1 ) begin
	   line_count <= 0;
	   features_out[0].status = LINE_END;
	end
	else begin
	   line_count <= line_count + 1;
	   features_out[0].status <= VALID;
	end
     end

   
   genvar xb,yb,xd,yd;
   generate 
      for (xb = 0; xb < `X_BLUR_MAX;xb++)
	x_shift my_feat_trans(.*,.px_in(features_out[xb]),.px_out(features_out[xb+1]));
   endgenerate

   generate
      for (xb = 0; xb <= `X_BLUR_MAX;xb++) begin
	 for (yb = 1; yb <= `Y_BLUR_MAX;yb++) begin
	    y_shift yb_feat_trans(.*,.px_in(features_out[`ARRAY_INDEX(xb,yb - 1,0,0)]),.px_out(features_out[`ARRAY_INDEX(xb,yb,0,0)]));
	 end
      end
   endgenerate

   generate
      for (xb = 0; xb <= `X_BLUR_MAX;xb++) begin
	 for (yb = 0; yb <= `Y_BLUR_MAX;yb++) begin
	    for (xd = 1; xd <= `X_DIFF_MAX;xd++) begin
	       x_shift #(1) xd_feat_trans(.*,.px_in(features_out[`ARRAY_INDEX(xb,yb,xd - 1,0)]),.px_out(features_out[`ARRAY_INDEX(xb,yb,xd,0)]));
	    end
	 end
      end
   endgenerate

   generate
      for (xb = 0; xb <= `X_BLUR_MAX;xb++) begin
	 for (yb = 0; yb <= `Y_BLUR_MAX;yb++) begin
	    for (xd = 0; xd <= `X_DIFF_MAX;xd++) begin
	       for (yd = 1; yd <= `Y_DIFF_MAX;yd++) begin
		  y_shift #(1) yd_feat_trans(.*,.px_in(features_out[`ARRAY_INDEX(xb,yb,xd,yd - 1)]),.px_out(features_out[`ARRAY_INDEX(xb,yb,xd,yd)]));
	       end
	    end
	 end
      end
   endgenerate


endmodule // features

