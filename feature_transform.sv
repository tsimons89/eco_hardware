//`include "globals.svh"
//`include "eco_types.sv"
import eco_types::*;
module feature_transform(input clk,rst,px_valid_in,input pixel px_in,
			 output px_valid_out,pixel px_out, output [`PIXEL_DATA_WIDTH - 1:0] a,b);
   parameter SIZE =1;
   parameter DIFF=0;
   logic signed [`PIXEL_COUNT_WIDTH -1 : 0] boundry_count;
   logic invalid_px_out;
   
   assign px_out.count = (SIZE !== 1)?px_in.count - SIZE : px_in.count - SIZE - boundry_count;
   pixel px_buffer [SIZE];
   int count;
   always@(posedge clk)begin
      if(rst)
	for(int i = 0; i < SIZE; i = i + 1)
	   px_buffer[i].is_boundry <= 0;
      else if(px_valid_in)begin
	 px_buffer[0] <= px_in;
	 for(int i = 1; i < SIZE; i = i + 1)
	   px_buffer[i] <= px_buffer[i-1];
      end
   end // always@ (posedge clk)

   always@(posedge clk)begin
      if(rst)
	boundry_count <= 0;
      else if(px_valid_in === 1 && px_buffer[SIZE - 1].is_boundry === 1)
	boundry_count <= boundry_count + 1;
   end
   reg valid_supress;
   always@(posedge clk)begin
      if(px_valid_in === 1 && px_buffer[SIZE - 1].is_boundry)
	valid_supress <= 1;
      else
	valid_supress <= 0;
   end
   
   assign px_valid_out = px_valid_in;
   assign px_out.data = (DIFF)? px_in.data - px_buffer[SIZE - 1].data : px_buffer[SIZE -1].data + px_in.data;
   assign px_out.is_boundry = px_in.is_boundry;
   assign a = px_in.data;
   assign b = px_buffer[SIZE - 1].data;
endmodule
