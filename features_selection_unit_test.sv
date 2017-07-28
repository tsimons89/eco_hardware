`include "svunit_defines.svh"
`include "eco_includes.svh"

module features_selection_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "features_selection_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   logic clk;
   logic set_feature_index;
   logic [`FOREST_NUM_WIDTH - 1:0] forest_num;
   logic [`FEATURE_INDEX_WIDTH - 1:0] feature_index;
   pixel all_features [`NUM_POSSIBLE_FEATURES];
   pixel selected_features [`NUM_FORESTS];
   
  features_selection my_features_selection(.*,.all_features(all_features),.selected_features(selected_features));

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
     set_all_features();
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
     
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
  endtask

   task set_all_features();
      for(int i = 0; i < `NUM_POSSIBLE_FEATURES; i++) begin
	 all_features[i].value = i;
      end
   endtask // reset_features_out

   task set_forest(int num,feat_index);
      @(negedge clk);
      set_feature_index = 1;
      forest_num = num;
      feature_index = feat_index;
      @(negedge clk);
      set_feature_index =0;
   endtask // set_feature
   
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
  
  `SVTEST(set_forest_0_genome_0)
   set_forest(0,0);
   `FAIL_UNLESS(selected_features[0].value === 0 );
  `SVTEST_END

  `SVTEST(set_forest_0_genome_1)
   set_forest(0,1);
   `FAIL_UNLESS(selected_features[0].value === 1 );
  `SVTEST_END

  `SVTEST(set_1_to_1_0_to_0)
   set_forest(0,0);
   set_forest(1,1);
   `FAIL_UNLESS(selected_features[0].value === 0 );
   `FAIL_UNLESS(selected_features[1].value === 1 );
  `SVTEST_END


  `SVTEST(final_test)
   set_forest(1,19);
   set_forest(0,122);
   set_forest(3,33);
   set_forest(2,100);
   `FAIL_UNLESS(selected_features[0].value === 122 );
   `FAIL_UNLESS(selected_features[1].value === 19 );
   `FAIL_UNLESS(selected_features[2].value === 100 );
   `FAIL_UNLESS(selected_features[3].value === 33 );
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
