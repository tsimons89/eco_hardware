//Features defines
`define PIXEL_WIDTH 8
`define PIXEL_VALUE_WIDTH 21
`define PIXEL_COUNT_WIDTH 21
`define X_BLUR_MAX 5
`define Y_BLUR_MAX 5
`define X_DIFF_MAX 1
`define Y_DIFF_MAX 1
`define NUM_POSSIBLE_FEATURES 144
`define FEATURE_INDEX(xb,yb,xd,yd)(xb + (`X_BLUR_MAX + 1)*(yb + (`Y_BLUR_MAX + 1)*(xd + (`X_DIFF_MAX + 1)*(yd))))
`define IMAGE_WIDTH 100

//Tree defines
`define TREE_DEPTH 5
`define NODE_ID_WIDTH `TREE_DEPTH
`define NODE_DATA_ADDRESS_WIDTH `NODE_ID_WIDTH
`define PREDICTION_DATA_ADDRESS_WIDTH `NODE_ID_WIDTH
`define NUM_NODES 2 ** `TREE_DEPTH - 1
`define PREDICTION_WIDTH 5
`define NUM_PREDICTIONS 2**`TREE_DEPTH
`define NUM_TREES 5
`define TREE_NUM_WIDTH 5

//Full integration defines
`define NUM_FORESTS 10
`define FOREST_NUM_WIDTH 5
`define FEATURE_INDEX_WIDTH 8
`define WEIGHT_WIDTH 10

//Testing defines
`define COUNT_TARGET xb_strobe - xb - xd + `IMAGE_WIDTH * (yb_strobe + (`Y_BLUR_MAX + 1) * (xd_strobe + yd_strobe * (`X_DIFF_MAX + 1))  - yb - yd)
`define TEST_DATA_DIR "/fse/tsimons/eco_hardware/"
