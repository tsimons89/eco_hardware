`ifndef ECO_TYPES_SV
 `define ECO_TYPES_SV

package eco_types;
   typedef struct {
      logic signed [`PIXEL_VALUE_WIDTH-1:0] value;
      logic signed [`PIXEL_COUNT_WIDTH -1:0] count;
      logic 	   is_boundry;
      enum 	   {FRAME_START,VALID,LINE_END,NOT_VALID} status;
   } pixel;
   typedef struct {
      logic signed [`PIXEL_COUNT_WIDTH -1:0] count;
      logic [`NODE_ID_WIDTH - 1:0] id;
      logic signed [`PIXEL_VALUE_WIDTH-1:0] value;
   } node_data;
   typedef enum {NULL,LESS,GREATER} node_state;
   typedef node_state [`NUM_NODES - 1 : 0] tree_struct;
   typedef logic [`PREDICTION_WIDTH - 1:0] prediction;
   typedef prediction [`NUM_NODES - 1:0] prediction_set;
endpackage
`endif
