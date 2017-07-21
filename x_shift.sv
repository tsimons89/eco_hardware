import eco_types::*;
module x_shift(input clk,rst,px_strobe,input pixel px_in,output pixel px_out);
   parameter DIFF=0;
   logic signed [`PIXEL_COUNT_WIDTH -1 : 0] count;
   logic invalid_px_out;
   
   pixel px_buffer;


   always@(posedge clk)begin
      if(rst)
	count <= -2;
      else if(px_strobe)
	if(px_in.status === FRAME_START)
	  count <= -1;
	else if(px_in.status === VALID)
	  count <= count + 1;
   end

   always@(posedge clk)begin
      if(px_strobe)
	px_buffer <= px_in;
   end

   
   always_comb begin
      if(rst) begin
	 px_out.status <= NOT_VALID;
      end
      else if(px_strobe) begin
	 if (count === -2)
	   px_out.status <= NOT_VALID;
	 else if(px_buffer.status === FRAME_START)
	   px_out.status <= FRAME_START;
	 else if(px_in.status === VALID && px_buffer.status === VALID)
	   px_out.status <= VALID;
	 else if(px_in.status === LINE_END)
	   px_out.status <= LINE_END;
	 else
	   px_out.status <= NOT_VALID;
      end
   end // always_comb

   
   
   assign px_out.value = (DIFF)? px_in.value - px_buffer.value : px_buffer.value + px_in.value;
   assign px_out.count = count;
endmodule
