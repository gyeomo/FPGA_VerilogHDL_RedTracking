module Search(clk_llc8, resetx, oddframe,href2, href2_wr, in_data, out_data, adr_counter);
input clk_llc8;
input resetx;
input href2;
input href2_wr;
input oddframe;
input [15:0] in_data;
input [15:0] adr_counter;

output [15:0] out_data;



reg LineBuffer1[0:179];
reg LineBuffer2[0:179];
reg LineBuffer3[0:179];
reg LineBuffer4[0:179];
reg LineBuffer5[0:179];
reg LineBuffer6[0:179];

///////////////////////////////////////////////////////////////////////////

reg flag1[0:2];
reg flag2;
integer i;

always@(negedge resetx or posedge href2)
if(~resetx)
begin
	flag1[0] <= 1'b1;
	flag1[1] <= 1'b0;
	flag1[2] <= 1'b0;
	flag2 <= 1'b0;
	i <= 2'b0;
end
else if(oddframe)
begin
	if(flag1[2] == 1'b1)
		flag2 <= ~ flag2;
	flag1[i] <= 1'b0;
	if(i == 2'd2)
		i <= 2'd0;
	else
		i<=i+1'd1;
	flag1[i] <= 1'b1;
end

///////////////////////////////////////////////////////////////////////////////


always@(posedge clk_llc8)
if((flag2 == 1'b0)&&(href2_wr))
begin
	if(flag1[0] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer1[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer1[adr_counter%15'd180] <= 1'b0;
		end
	else if(flag1[1] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer2[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer2[adr_counter%15'd180] <= 1'b0;
		end
	else if(flag1[2] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer3[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer3[adr_counter%15'd180] <= 1'b0;
		end
end

//////////////////////////


reg [15:0] redPoint1;
reg frameFinish1;

always@(negedge resetx or posedge clk_llc8)

	if(~resetx)
	begin
		redPoint1 <= 16'b0;
		frameFinish1 <= 1'b0;
	end

	else
	begin
		if(adr_counter == 15'b0)
		begin
			redPoint1 <= 16'b0;
			frameFinish1 <= 1'b0;
		end

		if((flag2 == 1'b1)&&(frameFinish1==1'b0)&&(frameFinish2==1'b0)&&href2_wr)
		begin
			if(((adr_counter%15'd179)==15'b0)&&(adr_counter>=15'b000000010110100)&&(adr_counter <= 15'b101001110101010))
			begin
			redPoint1 <= LineBuffer1[(adr_counter%15'd180)-1]&LineBuffer1[adr_counter%15'd180]&LineBuffer1[(adr_counter%15'd180)+1]
							&LineBuffer2[(adr_counter%15'd180)-1]&LineBuffer2[adr_counter%15'd180]&LineBuffer2[(adr_counter%15'd180)+1]
							&LineBuffer3[(adr_counter%15'd180)-1]&LineBuffer3[adr_counter%15'd180]&LineBuffer3[(adr_counter%15'd180)+1];
			end
			if(redPoint1 == 16'b0000000000000001)
			begin
				redPoint1 <= adr_counter;
				frameFinish1 <= 1'b1;
			end
		end
	end

//////////////////////////////////////////////////////////////////////////////////////////////


always@(posedge clk_llc8)
if((flag2 == 1'b1)&&(href2_wr))
begin
	if(flag1[0] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer4[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer4[adr_counter%15'd180] <= 1'b0;
		end
	else if(flag1[1] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer5[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer5[adr_counter%15'd180] <= 1'b0;
		end
	else if(flag1[2] == 1'b1)
		begin
		if(in_data == 16'b1111111111111111)
			LineBuffer6[adr_counter%15'd180] <= 1'b1;
		else
			LineBuffer6[adr_counter%15'd180] <= 1'b0;
		end
end

//////////////////////////


reg [15:0] redPoint2;
reg frameFinish2;

always@(negedge resetx or posedge clk_llc8)

	if(~resetx)
	begin
		redPoint2 <= 16'b0;
		frameFinish2 <= 1'b0;
	end

	else
	begin
		if(adr_counter == 15'b0)
		begin
			redPoint2 <= 16'b0;
			frameFinish2 <= 1'b0;
		end

		if((flag2 == 1'b0)&&(frameFinish1==1'b0)&&(frameFinish2==1'b0)&&href2_wr)
		begin
			if(((adr_counter%15'd179)==15'b0)&&(adr_counter>=15'b000000010110100)&&(adr_counter <= 15'b101001110101010))
			begin
			redPoint2 <= LineBuffer4[(adr_counter%15'd180)-1]&LineBuffer4[adr_counter%15'd180]&LineBuffer4[(adr_counter%15'd180)+1]
							&LineBuffer5[(adr_counter%15'd180)-1]&LineBuffer5[adr_counter%15'd180]&LineBuffer5[(adr_counter%15'd180)+1]
							&LineBuffer6[(adr_counter%15'd180)-1]&LineBuffer6[adr_counter%15'd180]&LineBuffer6[(adr_counter%15'd180)+1];
			end
			if(redPoint2 == 16'b0000000000000001)
			begin
				redPoint2 <= adr_counter;
				frameFinish2 <= 1'b1;
			end
		end
	end
///////////////////////////////////////////////////////////////////////////////////////

assign out_data = redPoint1 | redPoint2;


endmodule





