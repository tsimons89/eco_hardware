`define PIXEL_WIDTH 8
`define PIXEL_DATA_WIDTH 21
`define PIXEL_COUNT_WIDTH 21
`define X_BLUR_MAX 5
`define Y_BLUR_MAX 5
`define X_DIFF_MAX 1
`define Y_DIFF_MAX 1
`define NUM_POSSIBLE_FEATURES 144
`define ARRAY_INDEX(xb,yb,xd,yd)(xb + (`X_BLUR_MAX + 1)*(yb + (`Y_BLUR_MAX + 1)*(xd + (`X_DIFF_MAX + 1)*(yd))))

//`define NUM_POSSIBLE_FEATURES 0 + (`X_BLUR_MAX + 1) * (`Y_BLUR_MAX + 1) * (`X_DIFF_MAX + 1) * (`Y_DIFF_MAX +1)

`define IMAGE_WIDTH 100

