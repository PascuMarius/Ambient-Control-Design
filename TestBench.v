//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Testarea echipamentelor electronice
// Autor       : Pascu Marius
// Data        : 24.03.2021
//---------------------------------------------------------------------------------------
// Descriere   : modul TestBench (generează un set de stimuli de test pentru circuit) 
//---------------------------------------------------------------------------------------

module TestBench#(parameter DATA_WIDTH = 6)(
	input  reg ready_i,
	output reg clk_o,
	output reg reset_n,
	output reg enable_o,
  	output reg [DATA_WIDTH-1:0] temperature_o,
    output reg [DATA_WIDTH  :0] humidity_o,
  	output reg [DATA_WIDTH+3:0] luminous_intensity_o,
	output reg valid_o
);


//Clock generator
initial clk_o = 0;        
always #(3) clk_o <= ~clk_o; //for every 3 units of time clock will get change state

// TESTS
initial
begin
    $dumpfile("dump.vcd");
    $dumpvars;
	reset_n   <= 'b1;
  	valid_o   <= 'b0;
  	enable_o  <= 'b0;
#5 enable_o  <= 'b1;
#10	reset_n   <= 'b0;

end
  
  always@(posedge clk_o)
    if(ready_i == 'b1 )
      valid_o <= 'b1;
  else
    valid_o <= 'b0;
  
  
  always@(posedge clk_o)
    if(valid_o == 'b1 )
      valid_o <= 'b0;
  

  always@(posedge clk_o)
    if(ready_i == 'b1 && valid_o == 'b1 )
begin
  	
	temperature_o        <= 'b10111     ; // 23
	humidity_o           <= 'b110111    ; // 55
	luminous_intensity_o <= 'b0111110100; // 500
  
#30 temperature_o        <= 'b11010     ; // 26
	humidity_o           <= 'b100010    ; // 40
	luminous_intensity_o <= 'b1010111110; // 702 
  	
#6	reset_n   <= 'b1;
#15 reset_n   <= 'b0;
  
#30 temperature_o        <= 'b10010     ; // 18
	humidity_o           <= 'b11110     ; // 30
	luminous_intensity_o <= 'b11111010  ; // 300  
  
#6	reset_n   <= 'b1;
#15 reset_n   <= 'b0;
  
#30 temperature_o        <= 'b01110     ; 
	humidity_o           <= 'b10110     ; 
	luminous_intensity_o <= 'b11010010  ; 
  
#60  $finish();
end
  
endmodule