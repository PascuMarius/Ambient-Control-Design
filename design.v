//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Testarea echipamentelor electronice
// Autor       : Pascu Marius
// Data        : 24.03.2021
//---------------------------------------------------------------------------------------
// Descriere   : Implementarea unui control ambiental
//---------------------------------------------------------------------------------------

// create module
module ambient (clk_i, reset_n, enable_i, temperature_i, humidity_i, luminous_intensity_i, heat_o, AC_o, dehumidifier_o, blinds_o, ready_o, valid_i);
parameter DATA_WIDTH = 6;
// input control signals
input                  clk_i               ; // Clock signal
input                  reset_n             ; // Asynchronous reset, activ low
input                  enable_i            ; // Enable signal
// input values
  input  [DATA_WIDTH-1:0]  temperature_i       ; // Temperature data, 6 bits
  input  [DATA_WIDTH  :0]  humidity_i          ; // Humidity data, 7 bits
  input  [DATA_WIDTH+3:0]  luminous_intensity_i; // Luminous intensity data, 10 bits
// Valid input
input                     valid_i             ; // Valid data input
// Output pins
output   reg              heat_o              ; // Heat output
output   reg              AC_o                ; // AC output
output   reg              dehumidifier_o      ; // Dehumidifier output
output   reg              blinds_o            ; // Blinds output
// Ready output
output    reg             ready_o             ; // ready output

// FSM states
parameter OFF     = 3'b000                 ; // OFF, inactive machine
parameter START   = 3'b001	               ; // START, output ready 1 and wait for valid 1
parameter LOAD    = 3'b010                 ; // LOAD, load data from input to registers
parameter CONTROL = 3'b011                 ; // CONTROL, get decisions by data values

// registers
reg [DATA_WIDTH-1:0]   data_temp           ; // register for load temperature data
reg [DATA_WIDTH  :0]   data_hum            ; // register for load humidity data
reg [DATA_WIDTH+3:0]   data_lumin          ; // register for load luminous intensity data
reg [2:0]              state               ; // register for state machine

// FSM control
always@(posedge clk_i)
  begin
    if (enable_i) state <= START;    
begin case (state)  
	START: 	state <=  (valid_i)? LOAD : START;
 	 LOAD: 	state <=   CONTROL;
  	CONTROL:state <=   START;
	endcase
	end
  end

// Enable and reset  
  always@(posedge clk_i)
    begin
        if(reset_n && enable_i)
          state <= START; 
            
  		if (~enable_i) 
          state <= OFF;
    end
  
// data flow
  
  // output signals init
  initial begin 
     	 heat_o 		<= 'b0;
         AC_o 		 	<= 'b0;
         dehumidifier_o <= 'b0;
         blinds_o 		<= 'b0;
    	 ready_o 		<= 'b0;
    end

// ready signal
  always@(posedge clk_i)
    if(state == START && ~valid_i)
    	ready_o <= 'b1; 
  else
   	    ready_o <= 'b0;
  
// output signals reset
  always@(posedge clk_i)
    if(state == OFF||reset_n||~enable_i)
    begin
     	 heat_o 		<= 'b0;
         AC_o 		 	<= 'b0;
         dehumidifier_o <= 'b0;
         blinds_o 		<= 'b0;
     	 ready_o 		<= 'b0;
    end
  
// Load data temperature
always@(posedge clk_i)
begin
  if(reset_n || state == OFF ||~enable_i)          data_temp <= 'b0 ;else
      if(state == LOAD)     data_temp <= temperature_i[DATA_WIDTH-1:0];
end 

// Load data humidity
always@(posedge clk_i)
begin
  if(reset_n || state == OFF ||~enable_i)          data_hum <= 'b0 ;else
      if(state == LOAD)     data_hum <= humidity_i[DATA_WIDTH:0];
end 

// Load data luminous intensity
always@(posedge clk_i)
begin
  if(reset_n || state == OFF ||~enable_i)          data_lumin <= 'b0 ;else
      if(state == LOAD)     data_lumin <= luminous_intensity_i[DATA_WIDTH+3:0];
end 

// Control data temperature
always@(posedge clk_i)
begin
  if(state == CONTROL && enable_i)
	begin
      if(data_temp < 'b10110) //22 grade 
			heat_o <= 'b1;else
              if(data_temp >= 'b10110) // 22 
			heat_o <= 'b0;
      if(data_temp >= 'b11001) // 25
			AC_o <= 1;else
      if(data_temp <= 'b10110) // 22
			AC_o <= 'b0;
	end
end

// Control data humidity
always@(posedge clk_i)
begin
  if(state == CONTROL && enable_i)
	begin
      if(data_hum >= 'b110010) //50
			dehumidifier_o <= 'b1;else
              if(data_hum <= 'b100011) // 35
			dehumidifier_o <= 'b0;
	end
end

// Control data luminous intensity
always@(posedge clk_i)
begin
  if(state == CONTROL && enable_i)
	begin
		if(data_lumin >= 'b1010111100) // >=700
			blinds_o <= 'b1;else
              if(data_lumin <= 'b11001000)  // <=200
			blinds_o <= 'b0;
	end
end

endmodule