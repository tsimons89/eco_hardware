`include "svunit_defines.svh"
`include "eco_includes.svh"

module forest_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "forest_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk,rst;
   logic px_strobe,load_node,load_prediction,prediction_valid;
   pixel px_in;
   node_data node_in;
   logic [`PREDICTION_WIDTH - 1:0] prediction_in,prediction_out;
   logic [`TREE_NUM_WIDTH - 1:0] tree_num;
   
  forest my_forest(.*,.px_in(px_in),.node_in(node_in));

   initial begin
      clk = 0;
      forever
	#5 clk = ~clk;
   end

   logic input_done;
   int 	 input_file,forest_file,input_value;

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
     px_in.count = 0;
     input_done = 0;
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask

   task set_input_file(string filename);
      input_file = $fopen({`TEST_DATA_DIR,filename},"r");
   endtask

   task load_forest(string filename);
      forest_file = $fopen({`TEST_DATA_DIR,filename},"r");
      for(int i = 0;i < `NUM_TREES; i++) begin
	 tree_num = i;
	 load_nodes();
	 load_predictions();
      end
   endtask // load_forest

   task load_nodes();
      int id,count,value;
      int scan_file;
      for(int i = 0; i < `NUM_NODES; i++)begin
	 scan_file = $fscanf(forest_file,"%d %d %d\n",id,count,value);
	 load_node_data(id,count,value);
      end
   endtask

   task load_predictions();
      int prediction;
      int scan_file;
      for(int i = 0; i < `NUM_PREDICTIONS; i++) begin
	 scan_file = $fscanf(forest_file,"%d\n",prediction);
	 load_prediction_data(prediction);
      end
   endtask // load_predictions

   task load_prediction_data(int prediction);
      load_prediction = 1;
      prediction_in = prediction;
      @(negedge clk);
      load_prediction = 0;
   endtask

   task load_node_data(int _id,int _count,int _value);
      node_in.id = _id;
      node_in.value = _value;
      node_in.count = _count;
      load_node = 1;
      @(negedge clk);
      load_node = 0;
   endtask
   
   task input_tick();
      int scan_file;
      scan_file = $fscanf(input_file,"%d\n",input_value);
      strobe_pixel(input_value);
      if($feof(input_file)) begin
	input_done = 1;
      end
   endtask 

   task strobe_pixel(logic[`PIXEL_VALUE_WIDTH -1:0] value);
      @(negedge clk);
      px_in.value = value;
      @(negedge clk);
      px_strobe = 1;
      @(negedge clk);
      px_strobe = 0;
      px_in.count = px_in.count + 1;
      @(negedge clk);
   endtask // input_pixel

   task pause();
      #10000;
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
   always @(*)begin
/* -----\/----- EXCLUDED -----\/-----
      $display("Time: %0d -------------",$time);
      $display("rst: %b",my_forest.my_forest_prediction.rst);
      $display("predictions valid: %b",my_forest.prediction_valid_array);
      $display("state: %0d",my_forest.my_forest_prediction.cur_state);
 -----/\----- EXCLUDED -----/\----- */
   end

  `SVUNIT_TESTS_BEGIN

  `SVTEST(reset)
   #5;
   `FAIL_UNLESS(prediction_valid === 0);
  `SVTEST_END

  `SVTEST(test_good)
   `FAIL_UNLESS(prediction_valid === 0);
   load_forest("forest_1100_raw.dat");
   set_input_file("good_1_1_0_0.dat");
   while(!input_done)
     input_tick();
   pause();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 1);
  `SVTEST_END

  `SVTEST(test_crooked)
   `FAIL_UNLESS(prediction_valid === 0);
   load_forest("forest_1100_raw.dat");
   set_input_file("crooked_1_1_0_0.dat");
   while(!input_done)
     input_tick();
   pause();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 0);
  `SVTEST_END

  `SVTEST(test_broken)
   `FAIL_UNLESS(prediction_valid === 0);
   load_forest("forest_1100_raw.dat");
   set_input_file("broken_1_1_0_0.dat");
   while(!input_done)
     input_tick();
   pause();
   `FAIL_UNLESS(prediction_valid === 1);
   `FAIL_UNLESS(prediction_out === 2);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
