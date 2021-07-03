//---------------------------------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Proiect     : Testarea echipamentelor electronice
// Autor       : Pascu Marius
// Data        : 24.03.2021
//---------------------------------------------------------------------------------------
// Descriere   : mediu de simulare în care sunt instanțiate cele doua componente (DUT și TestBench)
//---------------------------------------------------------------------------------------

module TestBench (); 
parameter DATA_WIDTH = 6;
wire clk;
wire reset_n;
wire enable;
wire valid;
wire [DATA_WIDTH-1:0] temperature;
wire [DATA_WIDTH  :0] humidity;
wire [DATA_WIDTH+3:0] luminous;
wire heat;
wire AC;
wire dehumidifier;
wire blinds;
wire ready;

Design DUT(
	.clk_i                 (clk         ),
	.reset_n               (reset_n     ),
	.enable_i              (enable      ),
	.temperature_i         (temperature ),
	.humidity_i            (humidity    ),
	.luminous_intensity_i  (luminous    ),
	.valid_i			   (valid       ),
	.heat_o		           (heat        ),
    .AC_o                  (AC          ),
	.dehumidifier_o        (dehumidifier),
	.blinds_o              (blinds      ),
	.ready_o               (ready       )
);


TestBench TB(
	.ready_i               (ready       ),
	.clk_o                 (clk         ),
	.reset_n               (reset_n     ),
	.enable_o              (enable      ),
	.temperature_o         (temperature ),
	.humidity_o            (humidity    ),
	.luminous_intensity_o  (luminous    ),
	.valid_o			   (valid       )
);
  
endmodule