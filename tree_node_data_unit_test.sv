`include "svunit_defines.svh"
`include "eco_includes.svh"

module tree_node_data_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_node_data_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   node_data node_in,node_data_out;
   reg clk,load_node,rst;
   logic test_failed;
   logic [`NODE_DATA_ADDRESS_WIDTH - 1:0] node_data_address;
  tree_node_data my_tree_node_data(.*,.node_in(node_in),.node_data_out(node_data_out));
   
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
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
     test_failed = 0;
     node_data_address = 'x;
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

   task load_node_in(int count,int id,int value);
      load_node = 0;
      node_in.count = count;
      node_in.id = id;
      node_in.value = value;
      @(negedge clk);
      load_node = 1;
      @(negedge clk);
      load_node = 0;
   endtask

   task check_node(int count,int id,int value,int test_address);
      node_data_address = test_address ; #5;
      if(test_failed === 0)
	test_failed = (node_data_out.count === count ||
		     node_data_out.id === id ||
		     node_data_out.value === value)?0:1;
      else
	test_failed = 1;

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
    
    `SVTEST(test_single_node)
   load_node_in(100,10,-20);
   check_node(100,10,-20,0);
   `FAIL_IF(test_failed);
   `SVTEST_END

    `SVTEST(test_several_nodes)
   load_node_in(0,0,0);
   load_node_in(1,11,-100);
   load_node_in(2,22,-200);
   load_node_in(3,33,-300);
   check_node(0,0,0,0);
   check_node(1,11,-100,1);
   check_node(3,33,-300,3);
   `FAIL_IF(test_failed);
   `SVTEST_END

    `SVTEST(test_all_nodes)
   $monitor("id: %0d",node_in.id);
   for(int i = 0;i < `NUM_NODES; i++)
     load_node_in(i,i,-2*i);
   for(int i = 0;i < `NUM_NODES; i++)
     check_node(i,i,-2*i,i);
   `FAIL_IF(test_failed);
   `SVTEST_END
				

  `SVUNIT_TESTS_END

endmodule
