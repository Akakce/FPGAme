module deneme(input clk,  output [7:0]roms);

reg [7:0] ex2_memory [0:399];
reg [7:0] yetAnother;
integer i; 
initial begin

$readmemh("hazir_/b_background.txt", ex2_memory);
i = 0;
end
always @(posedge clk) begin
yetAnother = ex2_memory[i];
i = i+1;


end

assign roms = yetAnother;

endmodule

