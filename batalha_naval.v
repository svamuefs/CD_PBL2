module batalha_naval 
(

    input [2:0] x_coord_and_map_code , y_coord_code , 
    input [1:0] game_state_code ,
    input confirmAttack , cpld_clk ,

    output [6:0] matrix_colune_data , display_colune_data ,
	output [4:0] matrix_colune_activator , display_colune_activator ,
    output [1:0] ledRgb

 );
	
    //////CLOCKS, BOTÕES E CONTROLE DE MODO//////

    and andMapCode [2:0] (map_code , x_coord_and_map_code);
    and andXCoordCode [2:0] (x_coord_code , x_coord_and_map_code);

    wire [2:0] map_code , x_coord_code;

	or orEnable (enable , game_state_code[0] , game_state_code[1]);

    and andEnablePreparation (enablePreparation , game_state_code[0]);
    
    not notGameState0 (notEnablePreparation , game_state_code[0]);
    and andEnableAttack (enableAttack , game_state_code[1] , notEnablePreparation);

    sync_freq_divider freq_div_1(
        .clk       (cpld_clk) ,
        .enable    (enable) ,

        .final_clk (clk)
    );

    debouncer debouncerConfirmAttack (
        .button (confirmAttack),
        .clk    (clk) ,

        .out    (debouncedConfirmAttack)
    );

    //////MATRIZ E DISPLAY//////

    //counter para controlar as colunas e informações da matriz e display

    sync_3b_counter counterMatrixDisplay (
        .clk       (clk) ,
        .enable    (enable) ,

        .loopEnd   (loopEnd) ,
        .out       (counterOut)
    );

    wire [2:0] counterOut;

    //shift register que controla as colunas ativadas

    register5bitSIPO registerMatrixDisplay (
        .in (loopEnd) ,
        .clk (clk) ,
        .reset (enable) ,

        .out  (registerOut)
    );
    
    wire [4:0] registerOut;

    and matrixColuneActivator [4:0] (matrix_colune_activator , registerOut);

    not displayColuneActivator [4:0] (display_colune_activator , registerOut);//lógica inversa do display

    //Lógica para mostrar os dados:
    //O shift register funciona da esquerda para a direita
    //colunas são contadas da esquerda para a direita
    //na array de 35 bits, os 7 bits de maior valor correspondem à coluna esquerda...
    //e assim respectivamente para as outras colunas

    wire game_state_code_w;

    and andGambiarra [1:0](game_state_code_w[1:0] , game_state_code);

    mux4x1 displayCode0 [2:0](
        .in_a (game_state_code_w) , //1
        .in_c (x_coord_code) , //3
        .in_d (y_coord_code) , //4
        .select (counterOut[1:0]) ,
        .enable (enable) ,

        .out (displayCodeOut0)
    );

    wire[2:0] displayCodeOut;

    display_decoder displayDecoder(
        .binary_code (displayCodeOut) ,
        .enable (enable) ,

        .digitOut (display_colune_data)
    );

    /////JOGO//////

    d_flipflop saveMapCode [2:0] (
			.d (map_code) ,
			.clk (enableAttack) ,
			.reset (enable) ,
	 
			.out(savedMapCode)
	);
	 
	wire [2:0] savedMapCode;
	 
	mux2x1 codeSelect [2:0] (
			.in_a (map_code) ,
			.in_b (savedMapCode) ,
			.select (enableAttack) ,
			.enable (enable) ,
			
			.out (finalMapCode)
	);

    wire [2:0] finalMapCode;

    map_decoder_5maps mapDecoder (
        .map_code (finalMapCode) ,

        .map      (map)
    );

    wire [34:0] map;
    
    not not_confirm_attack (notConfirmAttack , debouncedConfirmAttack);

    demux1x8 xCoordDemuxHitsMap (
        .in     (notConfirmAttack) , 
        .select (x_coord_code) ,
        .enable (enableAttack) ,

        .out_a  (hits_map_clk_colune[0]) ,
        .out_b  (hits_map_clk_colune[1]) , //topo - linha 1
        .out_c  (hits_map_clk_colune[2]) , //2
        .out_d  (hits_map_clk_colune[3]) , //3
        .out_e  (hits_map_clk_colune[4]) , //4
        .out_f  (hits_map_clk_colune[5]) , //5
        .out_g  (hits_map_clk_colune[6]) , //6
    );
    
	wire [6:0] hits_map_clk_colune;

    not notYCoord2 (notYCoordCode2 , y_coord_code[2]);

    and andEnableDemux0 (enableDemux0 , notYCoordCode2 , enableAttack);

    demux1x4 yCoordDemuxHitsMap_0 [6:0] (
        .in     (hits_map_clk_colune) , 
        .select (y_coord_code[1:0]) ,
        .enable (enableDemux0) ,
        
        .out_a  (hits_map_clk[34:28]) ,
        .out_b  (hits_map_clk[27:21]) ,
        .out_c  (hits_map_clk[20:14]) ,
        .out_d  (hits_map_clk[13:7]) 
    );

    and andHitsMapClk [6:0] (hits_map_clk[6:0] , hits_map_clk_colune , y_coord_code[2] , enableAttack);
	 
	wire [34:0] hits_map_clk;

    d_flipflop hits_map_register [34:0] (
        .d     (1'b1) ,
        .clk   (hits_map_clk) ,
        .reset (enableAttack) ,

        .out   (hitsRegisterOut)
    );
	 
	wire [34:0] hitsRegisterOut , notHistRegisterOut , correctHitsOut;

    not notHistRegister [34:0] (notHistRegisterOut , hitsRegisterOut); 

	or correctHits [34:0] (correctHitsOut , notHistRegisterOut , map);

    mux2x1 matrixData [34:0] (
        .in_a (correctHitsOut) ,
        .in_b (map) ,
        .select (enablePreparation) ,
        .enable (enable) ,

        .out (matrixDataOut)
    ); 

    wire [34:0] matrixDataOut;

    mux4x1 matrixColuneData_0 [6:0] (
        .in_a (matrixDataOut[34:28]) , //1
        .in_b (matrixDataOut[27:21]) , //2
        .in_c (matrixDataOut[20:14]) , //3
        .in_d (matrixDataOut[13:7]) , //4
        .select (counterOut[1:0]) ,
        .enable (enable) ,

        .out (matrix_colune_data_0)
    );

    wire [6:0] matrix_colune_data_0;

    mux2x1 matrixColuneData_1 [6:0] (
        .in_a (matrix_colune_data_0) ,
        .in_b (matrixDataOut[6:0]) , //5
        .select (counterOut[2]) ,
        .enable (enable) ,

        .out (matrix_colune_data)
    );

    //Indicar acerto ou erro atraves do led rgb

    mux4x1 yCoordMuxLedRgb_0 [6:0](
        .in_a   (correctHitsOut[34:28]) ,
        .in_b   (correctHitsOut[27:21]) ,
        .in_c   (correctHitsOut[20:14]) ,
        .in_d   (correctHitsOut[13:7]) ,
        .select (y_coord_code[1:0]) ,
        .enable (enableAttack) ,

        .out    (correctHitsOut_colune_0)
    );

    mux2x1 yCoordMuxLedRgb_1 [6:0] (
        .in_a   (correctHitsOut_colune_0) ,
        .in_b   (correctHitsOut[6:0]) ,
        .select (y_coord_code[2]) ,
        .enable (enableAttack) ,

        .out    (correctHitsOut_colune)
    );

    wire [6:0] correctHitsOut_colune_0 , correctHitsOut_colune;

    mux8x1 xCoordMuxLedRgb (
        .in_a   (correctHitsOut_colune[0]) ,
        .in_b   (correctHitsOut_colune[1]) ,
        .in_c   (correctHitsOut_colune[2]) ,
        .in_d   (correctHitsOut_colune[3]) ,
        .in_e   (correctHitsOut_colune[4]) ,
        .in_f   (correctHitsOut_colune[5]) ,
        .in_g   (correctHitsOut_colune[6]) ,
        .select (x_coord_code) ,
        .enable (enableAttack) ,

        .out    (ledRgbRed)
    );

    nand nandInvalidXCoord ( invalidXCoord , x_coord_code[2] , x_coord_code[1] , x_coord_code[0] );

    not notRed (ledRgbGreen , ledRgbRed);

    and andGreen (ledRgb[0] , ledRgbGreen , notConfirmAttack , );
    and andRed   (ledRgb[1] , ledRgbRed   , notConfirmAttack , );


endmodule