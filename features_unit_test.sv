`include "svunit_defines.svh"
`include "eco_includes.svh"
`define COUNT_TARGET xb_strobe - xb - xd + `IMAGE_WIDTH * (yb_strobe + (`Y_BLUR_MAX + 1) * (xd_strobe + yd_strobe * (`X_DIFF_MAX + 1))  - yb - yd)
`define TEST_DATA_DIR "/fse/tsimons/eco_hardware/"
module features_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "features_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
   reg 	[`PIXEL_WIDTH -1:0] px_value;
   reg 	 clk;
   reg 	 rst;
   reg 	 frame_start;
   reg 	 px_strobe;
   pixel features_out [`NUM_POSSIBLE_FEATURES];
   
  features my_features(.*,.features_out(features_out));
   
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end


   int input_file,test_file;
   logic signed [`PIXEL_VALUE_WIDTH - 1:0] input_value,test_value;
   reg input_done;
   int next_test_count;
   int test_input_count,test_input_index;
   logic test_failed;
   int 	 test_genome_count;

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
     rst = 1;
     @(negedge clk);
     @(negedge clk);
     rst = 0;
    /* Place Setup Code Here */
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
   task strobe_pixel(logic[`PIXEL_WIDTH -1:0] value);
      @(negedge clk);
      px_value = value;
      @(negedge clk);
      px_strobe = 1;
      @(negedge clk);
      px_strobe = 0;
      @(negedge clk);
   endtask // input_pixel

   task multi_strobe(logic[`PIXEL_WIDTH -1:0] value, integer num_strobes);
     for(int i = 0; i < num_strobes; i = i+1)
       strobe_pixel(value);
   endtask // multi_strobe

   

   task set_input_file();
      input_file = $fopen({`TEST_DATA_DIR,"cookie_0_0_0_0.dat"},"r");
   endtask

   task set_test_file(string filename);
      test_file = $fopen({`TEST_DATA_DIR,filename},"r");
   endtask
   
   task input_tick();
      int scan_file;
      scan_file = $fscanf(input_file,"%d\n",input_value);
      strobe_pixel(input_value);
      if($feof(input_file)) begin
	$display("end of input data");
	input_done = 1;
      end
   endtask // input_tick
   
   task test_tick();
      int scan_file;
      scan_file = $fscanf(test_file,"%d\n",test_value);
      if($feof(test_file)) 
	$display("end of test data");
   endtask // test_tick
   

   task test_genome(int xb, int yb, int xd, int yd);
      string test_filename;
      test_failed = 1;
      $sformat(test_filename,"cookie_%0d_%0d_%0d_%0d.dat",xb,yb,xd,yd);
      set_input_file();
      set_test_file(test_filename);
      test_genome_count = 0;
      test_input_count = 0;
      if(yd > 0)
	test_input_index = `ARRAY_INDEX(xb,yb,xd,yd - 1);
      else if(xd > 0)
	test_input_index = `ARRAY_INDEX(xb,yb,xd - 1,0);
      else if(yb > 0)
	test_input_index = `ARRAY_INDEX(xb,yb - 1,0,0);
      else if(xb > 0)
	test_input_index = `ARRAY_INDEX(xb - 1,0,0,0);
      else
	test_input_index = `ARRAY_INDEX(0,0,0,0);
      while(!input_done) begin
	 if(features_out[test_input_index].count === test_input_count) begin
	    test_input_count = test_input_count + 1;
	 end
	 if(features_out[`ARRAY_INDEX(xb,yb,xd,yd)].count > test_genome_count)
	   return;
	 if(features_out[`ARRAY_INDEX(xb,yb,xd,yd)].count === test_genome_count) begin
	    test_tick();
	    if(features_out[`ARRAY_INDEX(xb,yb,xd,yd)].value !== test_value && features_out[`ARRAY_INDEX(xb,yb,xd,yd)].status !== NOT_VALID)begin
	       $display("!!!!!!Bad test - pixel: %0d %0d!==%0d",test_genome_count,features_out[`ARRAY_INDEX(xb,yb,xd,yd)].value,test_value);
	      return;
	    end
//	    $display("Good test - pixel: %0d %0d===%0d",test_genome_count,features_out[`ARRAY_INDEX(xb,yb,xd,yd)].value,test_value);
	    test_genome_count = test_genome_count +1;
	 end
	 input_tick();
      end
      if(test_genome_count > features_out[0].count/2)
	test_failed = 0;
   endtask
   
  `SVUNIT_TESTS_BEGIN

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(init_module)
   for(int i = 0; i < `NUM_POSSIBLE_FEATURES; i = i+1) begin
      `FAIL_UNLESS(features_out[i].count < 0 && features_out[i].count !== 'x);
   end
   `SVTEST_END	    
 -----/\----- EXCLUDED -----/\----- */


/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(test_genome_0_0_0_0)
   test_genome(0,0,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END


   `SVTEST(Test_genome_1_0_0_0)
   test_genome(1,0,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END

   `SVTEST(Test_genome_0_1_0_0)
   test_genome(0,1,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_2_0_0_0)
   test_genome(2,0,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */
     
/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_5_0_0_0)
   test_genome(5,0,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_0_0_1_0)
   test_genome(0,0,1,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_1_0_1_0)
   test_genome(1,0,1,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_5_0_1_0)
   test_genome(5,0,1,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
   `SVTEST(Test_genome_1_1_0_0)
   test_genome(1,1,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
    `SVTEST(Test_genome_1_1_0_0)
   test_genome(0,2,0,0);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
 -----/\----- EXCLUDED -----/\----- */

    `SVTEST(Test_genome_5_5_1_1)
   test_genome(5,5,1,1);
   `FAIL_IF(test_failed === 1);
   `SVTEST_END
   
  `SVUNIT_TESTS_END
    
endmodule
