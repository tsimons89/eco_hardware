`define PIXEL_DATA_WIDTH 21
`define PIXEL_COUNT_WIDTH 21
typedef struct {
   [PIXEL_DATA_WIDTH - 1:0] data;
   [PIXEL_COUNT_WIDTH - 1:0] count;
} pixel;


module features(input clk, rst, frame,start,px_valid,[7:0] px_data,output pixel);
endmodule // features

