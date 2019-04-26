module RGB2HSV(clock, reset, in_R,in_G,in_B,out_H,out_S,out_V);

input clock;
input reset;
input [4:0]in_R;
input [5:0]in_G;
input [4:0]in_B;

output [8:0]out_H;
output [5:0]out_S;
output [5:0]out_V;

reg [5:0]R_61;
reg [5:0]G_61;
reg [5:0]B_61;
reg [8:0]H;

reg [5:0] Max;
reg [5:0] Min;




////////////////////////////////////////////////////////////
always @ (negedge reset or posedge clock)
begin

 R_61<=in_R<<1;
 G_61<=in_G;
 B_61<=in_B<<1;

 if(~reset)
 begin
 H<=9'b000000000;
 end
 

 else if((R_61>G_61)&&(R_61>B_61)&&(G_61>B_61))
 begin
 Max<=R_61;
 Min<=B_61;
 H<=(G_61-B_61)*((6'b111100/(R_61-B_61)));
 end
 
 else if((R_61>G_61)&&(R_61>B_61)&&(B_61>G_61))
 begin
 Max<=R_61;
 Min<=G_61;
 H<=9'b101101000-(B_61-G_61);
 end
///////////////////////////////////////////////////////////
 else if((G_61>R_61)&&(G_61>B_61)&&(B_61>R_61))
 begin
 Max<=G_61;
 Min<=R_61;
 H<=(B_61-R_61)*((6'b111100/(G_61-R_61)));
 end
 
 else if((G_61>R_61)&&(G_61>B_61)&&(R_61>B_61))
 begin
 Max<=G_61;
 Min<=B_61;
 H<=9'b101101000-(R_61-B_61);
 end
////////////////////////////////////////////////////////////
 else if((B_61>G_61)&&(B_61>R_61)&&(R_61>G_61))
 begin
 Max<=B_61;
 Min<=G_61;
 H<=(R_61-G_61)*((6'b111100/(B_61-G_61)));
 end
 
 else if((B_61>G_61)&&(B_61>R_61)&&(G_61>R_61))
 begin
 Max<=B_61;
 Min<=R_61;
 H<=9'b101101000-(G_61-R_61);
 end
 
end

////////////////////////////////////////////////////////////
assign out_H = H;
assign out_S = Max-Min;
assign out_V = Max;


endmodule
