module fifo(wr_en,rd_en,lfd_state,sft_rst,rst,clk,d_in,d_out,empty,full);
input wr_en,rd_en,lfd_state,sft_rst,rst,clk;
input[7:0] d_in;
output reg[7:0] d_out;
output empty,full;
reg lfd_state_d;
reg[6:0] fifo_counter;
reg [4:0] wr_ptr;
reg [4:0] rd_ptr;
reg [8:0] mem [15:0];
integer i;
always @(posedge clk)
 begin
    if(!rst)
         lfd_state_d<=0;
    else
	   lfd_state_d<=lfd_state;
		end
//write logic
always @(posedge clk)
   begin
    if(!rst)
	 begin
	     wr_ptr<=0;
		   for(i=0;i<16;i=i+1)
	     mem[i]<=0;
		  end
	 else if(sft_rst)
	 begin
	      wr_ptr<=0;
	     for(i=0;i<16;i=i+1)
	         mem[i]<=0;
				end
	 else if(wr_en && !full)
	 begin
	    mem[wr_ptr[3:0]] <= {lfd_state_d,d_in};
		 wr_ptr<=wr_ptr+1;
		 end
		 else
		 wr_ptr<=wr_ptr;
		 end
//read logic
always @(posedge clk)
   begin
     if(!rst)
	  begin
	    rd_ptr<=0;
	      d_out<=8'hz;
		end
	  else if(sft_rst)
	  begin
	      rd_ptr<=0;
	      d_out<=8'hz;
			end
		else if(fifo_counter==0 && d_out!=0)
		begin
		   d_out<=8'hz;
		end
		else if(rd_en && !empty)
		begin
		   d_out<=mem[rd_ptr[3:0]];
			rd_ptr <=rd_ptr+1;
		end
		else 
			rd_ptr <= rd_ptr;
	end
	//fifo counter logic
	always@(posedge clk)
	begin
		if(!rst)
			fifo_counter<=0;
		else if(sft_rst)
			fifo_counter<=0;
		else if(rd_en&& !empty)
		begin
			if (mem[rd_ptr[3:0]][8]) 
			fifo_counter <= mem[rd_ptr[3:0]][7:2] + 1;
		
			else if(fifo_counter!=0)
			fifo_counter <= fifo_counter-1;
		end
	end
	
	assign full =((wr_ptr[4] != rd_ptr[4]) && (wr_ptr[3:0] == rd_ptr[3:0]))?1'b1:1'b0;
	assign empty =(wr_ptr == rd_ptr)?1'b1:1'b0;
	
endmodule
	  
 
	 
		 

	 
 
