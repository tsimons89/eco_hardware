`include "eco_includes.svh"

module eco_features_tb;
   //Testbench signals
   real weights [`NUM_CREATURES];
   string genomes [`NUM_CREATURES];
   logic input_done;
   int 	 input_file,forest_file,input_value;
   int num_correct,num_wrong,num_total;

   // eco_features signals
   logic  clk,rst,px_strobe,load_node,load_prediction,set_feature_index,load_weight;
   logic [`PIXEL_WIDTH - 1:0] px_value;
   logic [`FEATURE_INDEX_WIDTH - 1:0] feature_index;
   logic [`WEIGHT_WIDTH - 1:0] weight;
   node_data node_in;
   logic [`PREDICTION_WIDTH - 1:0] prediction_in;
   logic [`TREE_NUM_WIDTH - 1:0] tree_num;
   logic [`FOREST_NUM_WIDTH - 1:0] forest_num;
   logic prediction_valid;
   logic [`PREDICTION_WIDTH - 1:0] prediction_out;

   eco_features my_eco_features(.*,.node_in(node_in));



   
   initial begin
      clk = 0;
      forever
	#5 clk = ~clk;
   end

   task setup();
      reset();
      num_correct = 0;
      num_wrong = 0;
      num_total = 0;
   endtask;

   task reset();
      px_strobe = 0;
      load_node = 0;
      load_prediction = 0;
      set_feature_index = 0;
      load_weight = 0;
      input_done = 0;
      @(negedge clk);
      rst = 1;
      @(negedge clk);
      rst = 0;
   endtask
   
   task read_adaboost_file();
      real weight;
      string genome;
      int input_file;
      open_file({`CREATURES_DATA_DIR,"adaboost_model"},input_file);
      for(int i = 0; i < `NUM_CREATURES; i++)begin
	 $fscanf(input_file,"%g %s\n",weights[i],genomes[i]);
      end
   endtask // read_adaboost_file

   task load_weights();
      load_weight = 1;
      for(int i = 0; i < `NUM_CREATURES; i ++)begin
	 forest_num = i;
	 weight = weights[i] * `WEIGHT_MULTIPLIER;
	 @(negedge clk);
      end
      load_weight = 0;
   endtask // load_weights

   string char [4];
   int gene [4];

   task set_genomes();
      set_feature_index = 1;
      for(int i = 0; i < `NUM_CREATURES; i ++)begin
	 forest_num = i;
	 for(int j = 0; j < 4; j ++) begin
	    char[j] = genomes[i].getc(j);
	    gene[j] = char[j].atoi();
	 end
	 feature_index = `FEATURE_INDEX(gene[0],gene[1],gene[2],gene[3]);
	 @(negedge clk);
      end
      set_feature_index = 0;
   endtask // set_genomes

   task load_forests();
      for(int i = 0; i < `NUM_CREATURES; i++) begin
	 forest_num = i;
	 load_forest({"forest_",genomes[i],".dat"});
      end
   endtask

   task load_forest(string filename);
      open_file({`CREATURES_DATA_DIR,filename},forest_file);
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

   task read_directory(string dirname);
      int scan_file;
      open_input_file(dirname);
      scan_file = $fscanf(input_file,"%s\n",input_value);
      $display("Thing: %s",input_value);
      if($feof(input_file)) begin
	input_done = 1;
      end
   endtask
   
   task predict(string filename);
      open_input_file(filename);
      while(!input_done)
	input_tick();
      pause();
   endtask


   task test();
      int class_index_file;
      string class_name;
      int class_value;
      open_file({`IMAGES_DIR,"class_index.dat"},class_index_file);
      while(!$feof(class_index_file)) begin
	 $fscanf(class_index_file,"%s %d\n",class_name,class_value);
	 $display("class_name: %s, value: %0d",class_name,class_value);
	 test_class({`IMAGES_DIR,class_name},class_value);
      end
   endtask

   task test_class(string class_dir,int class_value);
      int image_index_file;
      string filename;
      open_file({class_dir,"/image_index.dat"},image_index_file);
      while(!$feof(image_index_file)) begin
	 $fscanf(image_index_file,"%s\n",filename);
	 $display("Image: %s",filename);
	 test_image({class_dir,"/",filename},class_value);
      end
   endtask // test_class

   task test_image(string image_path,int class_value);
      open_file(image_path,input_file);
      reset();
      while(!input_done) begin
	 input_tick();
      end
      pause();
      if(prediction_valid === 0) begin
	 $display("Prediction not valid on %s",image_path);
	 $finish;
      end
      if(prediction_out === class_value) begin
	 num_correct = num_correct + 1;
	 $display("Correct");
      end
      else begin
	 $display("Wrong ture: %0d, prediction: %0d",class_value,prediction_out);
	 num_wrong = num_wrong + 1;
      end
      num_total = num_total + 1;
   endtask
   
   task open_input_file(string filename);
      open_file({`IMAGES_DIR,filename},input_file);
   endtask // open_input_file

   task open_file(input string filename,output int file_handle);
      file_handle = $fopen(filename,"r");
      if (file_handle === 0)begin
	 $display("-------%s could not be opened",filename);
	 $finish;
      end
   endtask

   task input_tick();
      int scan_file;
      scan_file = $fscanf(input_file,"%d\n",input_value);
      strobe_pixel(input_value);
      if($feof(input_file)) begin
	input_done = 1;
      end
   endtask // input_tick

   task strobe_pixel(logic[`PIXEL_VALUE_WIDTH -1:0] value);
      @(negedge clk);
      px_value = value;
      @(negedge clk);
      px_strobe = 1;
      @(negedge clk);
      px_strobe = 0;
      @(negedge clk);
   endtask // input_pixel

   task pause();
      #10000;
   endtask // pause

   task display_results();
      real percent_correct;
      percent_correct = (num_correct*100)/(num_total*100);
      $display("Percent correct: %g  %d/%d",percent_correct,num_correct,num_total);
   endtask

/* -----\/----- EXCLUDED -----\/-----
   always @(posedge clk)begin
      if(my_eco_features.all_features[`FEATURE_INDEX(1,1,0,0)].count === 4217) begin
	 $display("px_in.value %0d",my_eco_features.my_forest_0.px_in.value);
	 $display("px_in.count %0d",my_eco_features.my_forest_0.px_in.count);
      end
   end
 -----/\----- EXCLUDED -----/\----- */

   //main
   initial begin
      reset();
      read_adaboost_file();
      load_weights();
      set_genomes();
      load_forests();
      test();
      display_results();
      $finish;
   end
endmodule
