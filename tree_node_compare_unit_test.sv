`include "svunit_defines.svh"
`include "eco_includes.svh"

module tree_node_compare_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_node_compare_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst;
   logic set_structure_node,less_than,px_strobe;
   logic [`NODE_ID_WIDTH - 1:0]node_id_in;
   logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address;
   pixel px_in;
   node_data node_data_out;
  tree_node_compare my_tree_node_compare(.*,.px_in(px_in),.node_data_out(node_data_out));

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
   px_strobe = 0;

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
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

  `SVTEST(reset)
   `FAIL_UNLESS(set_structure_node === 0)
   `FAIL_UNLESS(node_data_address === 0)
  `SVTEST_END

  `SVTEST(increment_count)
   px_in.count = 150;
   px_in.status = VALID;
   node_data_out.count = 150;
   px_strobe = 1;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(node_data_address === 1)
  `SVTEST_END

  `SVTEST(dont_increment_count_invalid)
   px_in.count = 150;
   px_in.status = NOT_VALID;
   node_data_out.count = 150;
   px_strobe = 1;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(node_data_address === 0)
  `SVTEST_END
				   
  `SVTEST(dont_increment_count_wrong_pixel)
   px_in.count = 150;
   px_in.status = VALID;
   node_data_out.count = 101;
   px_strobe = 1;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(node_data_address === 0)
  `SVTEST_END

  `SVTEST(check_set_struct_on_strobe)
   px_in.count = 150;
   px_in.status = VALID;
   node_data_out.count = 150;
   px_strobe = 1;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(set_structure_node === 1)
   @(negedge clk);
   `FAIL_UNLESS(set_structure_node === 0 )
  `SVTEST_END

  `SVTEST(check_node_id_on_strobe)
   px_in.count = 150;
   px_in.status = VALID;
   node_data_out.count = 150;
   px_strobe = 1;
   node_data_out.id = 7;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(node_id_in === 7)
  `SVTEST_END

  `SVTEST(check_less_than_on_strobe)
   px_in.count = 150;
   px_in.status = VALID;
   px_in.value = 100;
   node_data_out.count = 150;
   node_data_out.value = 200;
   px_strobe = 1;
   node_data_out.id = 7;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(less_than === 1)
  `SVTEST_END

  `SVTEST(check_grater_than_on_strobe)
   px_in.count = -5;
   px_in.status = VALID;
   px_in.value = 100;
   node_data_out.count = 150;
   node_data_out.value = -10;
   px_strobe = 1;
   node_data_out.id = 7;
   @(negedge clk);
   px_strobe = 0;
   `FAIL_UNLESS(less_than === 0)
  `SVTEST_END

			    

  `SVUNIT_TESTS_END

endmodule
