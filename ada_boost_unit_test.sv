`include "svunit_defines.svh"
`include "eco_includes.svh"

module ada_boost_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "ada_boost_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst;
   logic load_weight;
   logic [`WEIGHT_WIDTH - 1:0] weight;
   logic [`FOREST_NUM_WIDTH - 1:0] forest_num;
   logic [`NUM_FORESTS - 1:0] prediction_valid_array;
   logic [`PREDICTION_WIDTH - 1:0] prediction_out_array [`NUM_FORESTS];
   logic prediction_valid;
   logic [`PREDICTION_WIDTH - 0:1] prediction_out;
  ada_boost my_ada_boost(.*);
   
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
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask

   task pause();
      #1000;
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
   task load_in_prediction(int index,pred);
      prediction_out_array[index] = pred;
   endtask

   task load_in_weight(int _forest_num,_weight);
      @(negedge clk);
      forest_num = _forest_num;
      weight = _weight;
      load_weight = 1;
      @(negedge clk);
      load_weight = 0;
   endtask
   
   task do_prediction();
      prediction_valid_array = '1;
      pause();
   endtask


  `SVUNIT_TESTS_BEGIN
  `SVTEST(assending_weight_and_prediction)
   for(int i = 0; i < `NUM_FORESTS; i++)begin
      load_in_prediction(i,i);
      load_in_weight(i,i);
   end
   do_prediction();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === `NUM_FORESTS - 1);
  `SVTEST_END

  `SVTEST(assending_prediction)
   for(int i = 0; i < `NUM_FORESTS; i++)begin
      load_in_prediction(i,i);
   end

   load_in_weight(0,20);
   load_in_weight(1,5);
   load_in_weight(2,15);
   load_in_weight(3,6);
   load_in_weight(4,9);
   load_in_weight(5,8);
   load_in_weight(6,30);
   load_in_weight(7,17);
   load_in_weight(8,2);
   load_in_weight(9,10);
   

   do_prediction();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 6);
  `SVTEST_END

  `SVTEST(test_case_same_weights)
   load_in_prediction(0,3);
   load_in_prediction(1,3);
   load_in_prediction(2,0);
   load_in_prediction(3,3);
   load_in_prediction(4,3);
   load_in_prediction(5,0);
   load_in_prediction(6,3);
   load_in_prediction(7,0);
   load_in_prediction(8,3);
   load_in_prediction(9,0);
   
   for(int i = 0; i < `NUM_FORESTS; i++)begin
      load_in_weight(i,10);
   end

   do_prediction();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 3);
  `SVTEST_END

  `SVTEST(test_case_different_all)
   load_in_prediction(0,3);
   load_in_prediction(1,3);
   load_in_prediction(2,0);
   load_in_prediction(3,3);
   load_in_prediction(4,3);
   load_in_prediction(5,0);
   load_in_prediction(6,3);
   load_in_prediction(7,0);
   load_in_prediction(8,3);
   load_in_prediction(9,0);
   
   load_in_weight(0,10);
   load_in_weight(1,10);
   load_in_weight(2,30);
   load_in_weight(3,5);
   load_in_weight(4,10);
   load_in_weight(5,10);
   load_in_weight(6,10);
   load_in_weight(7,10);
   load_in_weight(8,10);
   load_in_weight(9,10);

   do_prediction();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 0);
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
