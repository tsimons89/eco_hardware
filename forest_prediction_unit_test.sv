`include "svunit_defines.svh"
`include "eco_includes.svh"

module forest_prediction_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "forest_prediction_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst;
   logic prediction_valid;
   logic [`NUM_TREES - 1:0] prediction_valid_array;
   logic [`PREDICTION_WIDTH - 1:0] prediction_out_array [`NUM_TREES];
   logic [`PREDICTION_WIDTH - 1:0] prediction_out;
  forest_prediction my_forest_prediction(.*);

   initial begin
      clk = 0;
      forever
	#5 clk = ~clk;
   end
  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
     @(negedge clk);
     rst = 1;
     @(negedge clk);
     rst = 0;
     prediction_valid_array = 0;
     #5;


  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask // teardown

   task pause();
      #100000;
   endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
   always @* begin
/* -----\/----- EXCLUDED -----\/-----
      $display("Time: %0d -------------------------",$time);
      $display("Iter addr: %0d",my_forest_prediction.iter_addr);
      $display("Check array: %b",my_forest_prediction.checked_array);
      $display("State: %d",my_forest_prediction.cur_state);
 -----/\----- EXCLUDED -----/\----- */
   end
  `SVUNIT_TESTS_BEGIN

  `SVTEST(reset)
   `FAIL_UNLESS(prediction_valid === 0)
  `SVTEST_END

  `SVTEST(test_valid)
   for(int i = 1; i < `NUM_TREES; i++)
     prediction_valid_array[i] = 1'b1;
   pause();
   `FAIL_UNLESS(prediction_valid === 0)
   prediction_valid_array[0] = 1'b1;
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
  `SVTEST_END

  `SVTEST(test_all_1)
   for(int i = 0; i < `NUM_TREES; i++)
     prediction_out_array[i] = 1'b1;
   prediction_valid_array = {`NUM_TREES{1'b1}};
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 1)
   `SVTEST_END

  `SVTEST(test_all_1_but_tree_0)
   prediction_out_array[0] = 0;
   for(int i = 1; i < `NUM_TREES; i++)
     prediction_out_array[i] = 1;
   prediction_valid_array = {`NUM_TREES{1'b1}};
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 1)
   `SVTEST_END

  `SVTEST(test_case_1)
   prediction_out_array[0] = 0;
   prediction_out_array[1] = 0;
   prediction_out_array[2] = 2;
   prediction_out_array[3] = 2;
   prediction_out_array[4] = 2;
   prediction_valid_array = {`NUM_TREES{1'b1}};
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 2)
   `SVTEST_END

  `SVTEST(test_case_2)
   prediction_out_array[0] = 0;
   prediction_out_array[1] = 1;
   prediction_out_array[2] = 2;
   prediction_out_array[3] = 3;
   prediction_out_array[4] = 4;
   prediction_valid_array = {`NUM_TREES{1'b1}};
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 0)
   `SVTEST_END


  `SVTEST(test_case_3)
   prediction_out_array[0] = 1;
   prediction_out_array[1] = 0;
   prediction_out_array[2] = 1;
   prediction_out_array[3] = 2;
   prediction_out_array[4] = 3;
   prediction_valid_array = {`NUM_TREES{1'b1}};
   pause();
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 1)
   `SVTEST_END
				  
				  
  `SVUNIT_TESTS_END

endmodule
