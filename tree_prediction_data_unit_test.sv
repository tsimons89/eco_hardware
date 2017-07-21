`include "svunit_defines.svh"
`include "eco_includes.svh"

module tree_prediction_data_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_prediction_data_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst,load_prediction_in;
   logic [`PREDICTION_WIDTH - 1:0] prediction_in,prediction_out;
   logic [`PREDICTION_DATA_ADDRESS_WIDTH - 1:0] prediction_idx;
   tree_prediction_data my_tree_prediction_data(.*);

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
     load_prediction_in = 0;
    /* Place Setup Code Here */
     @(negedge clk);
     rst = 1;
     @(negedge clk);
     rst = 0;

  endtask

   task strobe_prediction(int prediction);
     prediction_in = prediction;
      load_prediction_in = 1;
      @(negedge clk);
      load_prediction_in = 0;
   endtask

  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests sk@#aiSE.232
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

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
   `SVUNIT_TESTS_BEGIN
     
   `SVTEST(all_0)
   for(int i = 0; i < `NUM_PREDICTIONS; i++)begin
      strobe_prediction(0);
   end
   prediction_idx = 0; #5;
   `FAIL_UNLESS(prediction_out === 0)
  `SVTEST_END

   `SVTEST(all_i)
   for(int i = 0; i < `NUM_PREDICTIONS; i++)begin
      strobe_prediction(i/(`NUM_PREDICTIONS/2**`PREDICTION_WIDTH));
   end
   for(int i = 0; i < `NUM_PREDICTIONS; i++)begin
      prediction_idx = i; #5;
      `FAIL_UNLESS(prediction_out === i/(`NUM_PREDICTIONS/2**`PREDICTION_WIDTH))
   end
  `SVTEST_END
				
  `SVUNIT_TESTS_END

endmodule
