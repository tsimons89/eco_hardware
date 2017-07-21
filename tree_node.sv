module tree_node(input clk,rst,set,less_than,parent_branch,output left_branch,right_branch);
   reg set_reg,less_reg;
   always @(posedge clk)
     if(rst)
       set_reg = 0;
     else if (set) begin
	set_reg = 1;
	less_reg = less_than;
     end
   assign left_branch = less_reg & parent_branch & set_reg;
   assign right_branch = ~less_reg & parent_branch & set_reg;
   
endmodule
