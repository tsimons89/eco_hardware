`include "svunit_defines.svh"
`include "eco_includes.svh"

module tree_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "tree_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst;
   logic px_strobe,load_node,load_prediction,prediction_valid;
   logic [`PREDICTION_WIDTH - 1:0] prediction_in,prediction_out;
   node_data node_in;
   pixel px_in;
  tree my_tree(.*,.px_in(px_in),.node_in(node_in));

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
     load_prediction = 0;
     load_node = 0;
     px_strobe = 0;
     @(negedge  clk);
     rst = 1;
     @(negedge  clk);
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

   task load_node_in(int count, int id,int value);
      node_in.count = count;
      node_in.id = id;
      node_in.value = value;
      load_node = 1;
      @(negedge clk);
      load_node = 0;
   endtask 

   task load_prediction_in(int prediction);
      prediction_in = prediction;
      load_prediction = 1;
      @(negedge clk);
      load_prediction = 0;
   endtask

   task strobe_pixel(int value,int count,int status);
      px_in.value = value;
      px_in.count = count;
      px_in.status = status;
      px_strobe = 1;
      @(negedge clk);
      px_strobe = 0;
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
   always_comb begin
/* -----\/----- EXCLUDED -----\/-----
      $display("----------------");
     $display($time," - set array: %b",my_tree.my_struct.set_array);
     $display($time," - set struct node: %b",my_tree.set_structure_node);
     $display($time," - node id: %0d",my_tree.node_id_in);
      $display($time,"branches: %b",my_tree.my_struct.branches);
      $display($time,"leaves: %b",my_tree.my_struct.leaves);
      $display("----------------");
 -----/\----- EXCLUDED -----/\----- */
   end
  `SVUNIT_TESTS_BEGIN



   `SVTEST(tivial_data)
   `FAIL_UNLESS(prediction_valid === 0)
//   $monitor("branches: %b",my_tree.my_struct.branches);
//   $monitor("set struct: %b",my_tree.set_structure_node);
   for(int i = 0; i < `NUM_PREDICTIONS; i++)
     load_prediction_in(i);
   load_node_in(15,15,15);
   load_node_in(7,7,7);
   load_node_in(3,3,3);
   load_node_in(1,1,1);
   load_node_in(0,0,0);

   strobe_pixel(5,15,VALID);
   strobe_pixel(0,7,VALID);
   strobe_pixel(0,3,VALID);
   strobe_pixel(0,1,VALID);
   strobe_pixel(1,0,VALID);
   @(negedge clk);
   `FAIL_UNLESS(prediction_valid === 1)
   `FAIL_UNLESS(prediction_out === 1);
   
   `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
