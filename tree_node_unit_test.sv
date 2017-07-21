`include "svunit_defines.svh"
`include "tree_node.sv"

module tree_node_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_node_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  tree_node my_tree_node(.*);
   logic clk,rst,left_branch,right_branch,less_than,set,parent_branch;
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
   less_than = 0;
   set = 0;
   parent_branch = 0; #5;

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask

  task set_and_clk(logic _less,_set,_parent);
     less_than = _less;
     set = _set;
     parent_branch = _parent;
     @(negedge clk);
  endtask;


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
    
  `SVTEST(rst_test)
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 0);
  `SVTEST_END

  `SVTEST(test_less_than_all_at_once)
   set_and_clk(1,1,1);
   `FAIL_UNLESS(left_branch === 1);
   `FAIL_UNLESS(right_branch === 0);
  `SVTEST_END

   `SVTEST(test_greater_than_all_at_once)
   set_and_clk(0,1,1);
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 1);
  `SVTEST_END

  `SVTEST(test_less_no_set)
   set_and_clk(1,0,1);
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 0);
  `SVTEST_END

  `SVTEST(test_greater_no_set)
   set_and_clk(0,0,1);
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 0);
  `SVTEST_END

  `SVTEST(test_set_and_change)
   set_and_clk(1,1,1);
   set_and_clk(0,0,1);
   `FAIL_UNLESS(left_branch === 1);
   `FAIL_UNLESS(right_branch === 0);
  `SVTEST_END


  `SVTEST(behaviour_test)
   set_and_clk(1,1,1);
   set_and_clk(0,0,1);
   `FAIL_UNLESS(left_branch === 1);
   `FAIL_UNLESS(right_branch === 0);
   set_and_clk(0,1,1);
   set_and_clk(1,0,1);
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 1);
   parent_branch = 0; #5;
   `FAIL_UNLESS(left_branch === 0);
   `FAIL_UNLESS(right_branch === 0);
   
  `SVTEST_END

    
  `SVUNIT_TESTS_END

endmodule
