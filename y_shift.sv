import eco_types::*;
module y_shift(input clk,rst,px_strobe,input pixel px_in,output pixel px_out);
   parameter DIFF=0;
   logic signed [`PIXEL_COUNT_WIDTH -1 : 0] count;
   localparam SIZE = `IMAGE_WIDTH;
   pixel px_buffer[SIZE];


   always@(posedge clk)begin
      if(rst)
	count <= -2;
      else if(px_strobe)
	if(px_out.status === FRAME_START)
	  count <= 0;
	else if(px_out.status !== NOT_VALID)
	  if(px_in.status !== NOT_VALID)
	    count <= count + 1;
   end

   always@(posedge clk)begin
      if(rst)
	for(int i= 0; i < SIZE; i ++)
	  px_buffer[i].status <= NOT_VALID ;
      else if(px_strobe)begin
	px_buffer[0] <= px_in;
	for(int i= 1; i < SIZE; i ++)
	  px_buffer[i] <= px_buffer[i - 1];
      end
   end

   
   always_comb begin
      if(rst) begin
	 px_out.status <= NOT_VALID;
      end
      else if(px_strobe) begin
	 px_out.status <= px_buffer[SIZE - 1].status;
      end
   end // always_comb

   
   
   assign px_out.value = (DIFF)? px_in.value - px_buffer[SIZE - 1].value : px_buffer[SIZE - 1].value + px_in.value;
   assign px_out.count = count;
endmodule
