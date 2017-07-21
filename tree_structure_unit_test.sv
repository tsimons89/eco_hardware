`include "svunit_defines.svh"
`include "eco_includes.svh"

module tree_structure_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_structure_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst,less_than,set_structure_node;
   logic [`NODE_ID_WIDTH - 1:0] node_id_in;
   logic prediction_valid;
   logic [`NODE_ID_WIDTH - 1:0] prediction_idx;
   
  tree_structure my_tree_structure(.*);


   //Small tree structure (depth 2)
   logic prediction_valid_1;
   logic [`NODE_ID_WIDTH - 1:0] prediction_idx_1;
   tree_structure #(1) tree_1(.*,.prediction_valid(prediction_valid_1),.prediction_idx(prediction_idx_1));


   //Small tree structure (depth 2)
   logic prediction_valid_2;
   logic [`NODE_ID_WIDTH - 1:0] prediction_idx_2;
   tree_structure #(2) tree_2(.*,.prediction_valid(prediction_valid_2),.prediction_idx(prediction_idx_2));


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
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask

   task set_node(int _id, logic _less);
      node_id_in = _id;
      set_structure_node = 1;
      less_than = _less;
      @(negedge clk);
      set_structure_node = 0;
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

  `SVTEST(test_reset)
   `FAIL_UNLESS(prediction_valid_1 === 0)
  `SVTEST_END

  `SVTEST(test_1_less)
   set_node(0,1);
   `FAIL_UNLESS(prediction_valid_1 === 1)
   `FAIL_UNLESS(prediction_idx_1 === 0)
  `SVTEST_END

  `SVTEST(test_1_greater)
   set_node(0,0);
   `FAIL_UNLESS(prediction_valid_1 === 1)
   `FAIL_UNLESS(prediction_idx_1 === 1)
  `SVTEST_END

  `SVTEST(test_2_predict_0)
   set_node(0,1);
   set_node(1,1);
   `FAIL_UNLESS(prediction_valid_2 === 1)
   `FAIL_UNLESS(prediction_idx_2 === 0)
  `SVTEST_END

  `SVTEST(test_2_predict_1)
   set_node(0,0);
   set_node(1,1);
   `FAIL_UNLESS(prediction_valid_2 === 1)
   `FAIL_UNLESS(prediction_idx_2 === 1)
  `SVTEST_END

  `SVTEST(test_2_predict_not_valid)
   set_node(0,1);
   set_node(1,0);
   `FAIL_UNLESS(prediction_valid_2 === 0)
  `SVTEST_END


  `SVTEST(test_2_predict_2)
   set_node(2,1);
   set_node(1,0);
   `FAIL_UNLESS(prediction_valid_2 === 1)
   `FAIL_UNLESS(prediction_idx_2 === 2)
  `SVTEST_END

  `SVTEST(test_2_predict_3)
   set_node(2,0);
   set_node(1,0);
   `FAIL_UNLESS(prediction_valid_2 === 1)
   `FAIL_UNLESS(prediction_idx_2 === 3)
  `SVTEST_END

  `SVTEST(test_full_0)
   set_node(15,1);
   set_node(0,1);
   set_node(1,1);
   set_node(3,1);
   `FAIL_UNLESS(prediction_valid === 0)
   set_node(7,1);
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_idx === 0)
  `SVTEST_END

  `SVTEST(test_full_21)
   set_node(19,0);
   set_node(23,1);
   set_node(20,0);
   set_node(21,1);
   `FAIL_UNLESS(prediction_valid === 0)
   set_node(15,0);
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_idx === 21)
  `SVTEST_END

		       
  `SVUNIT_TESTS_END

endmodule
