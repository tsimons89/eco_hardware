`ifndef ECO_TYPES_SV
 `define ECO_TYPES_SV

package eco_types;
   typedef struct {
      logic signed [`PIXEL_DATA_WIDTH-1:0] data;
      logic signed [`PIXEL_COUNT_WIDTH -1:0] count;
      logic 	   is_boundry;
      enum 	   {FRAME_START,VALID,LINE_END,NOT_VALID} status;
      //pixel_status status;
   } pixel;
endpackage
`endif
