module batalha_naval 
(

    input [2:0] x_coord_and_map_code , y_coord_code , 
    input [1:0] game_state_code ,
    input confirmAttack , cpld_clk ,

    output [6:0] matrix_colune_data , display_colune_data ,
	output [4:0] matrix_colune_activator , 
    output [3:0] display_colune_activator ,
    output [1:0] ledRgb

 );
	
    //////CLOCKS, BOTÕES E CONTROLE DE MODO//////

    and andMapCode [2:0] (map_code , x_coord_and_map_code);
    and andXCoordCode [2:0] (x_coord_code , x_coord_and_map_code);

    wire [2:0] map_code , x_coord_code;


    //Enable para ativar independentemente de qual modo.
	or orEnable (enable , game_state_code[0] , game_state_code[1]);
    //Apenas para identificação do sinal
    and andEnablePreparation (enablePreparation , game_state_code[0]);
    
    //Ativar o ataque apenas quando a preparação estiver desativada
    not notGameState0 (notEnablePreparation , game_state_code[0]);
    and andEnableAttack (enableAttack , game_state_code[1] , notEnablePreparation);

    //divisor de frequenquência de 13 TFF; = 6KHz
    sync_freq_divider freq_div_1(
        .clk       (cpld_clk) ,
        .enable    (enable) ,

        .final_clk (clk)
    );

    //Debouncer para o botão de confirmar attack.
    //Detalhes no arquivo do módulo.
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

    //shift register que controla as colunas ativadas.
    //Quando o clock esta em 000, loopEnd mantem nível lógico alto na entrada no registro, dessa maneira, a cada 8 pulsos de clock, um " 1 " " atravessa " o shift register.
    register5bitSIPO registerMatrixDisplay (
        .in (loopEnd) ,
        .clk (clk) ,
        .reset (enable) ,

        .out  (registerOut)
    );
    
    //A saída do registro é utilizada para ativar as colunas da matriz e do display em sincronia com os dados que serão mostrados.
    wire [4:0] registerOut;

    and matrixColuneActivator [4:0] (matrix_colune_activator , registerOut);

    not displayColuneActivator [3:0] (display_colune_activator , registerOut[4:1]);//lógica inversa do display

    //Lógica para mostrar os dados:
    //O shift register funciona da esquerda para a direita
    //colunas são contadas da esquerda para a direita
    //na array de 35 bits, os 7 bits de maior valor correspondem à coluna esquerda...
    //e assim respectivamente para as outras colunas

    //gambiarra para colocar 2 bits em um mux4x1 com largura de 3 bits, não sei outra maneira kkkkk ~sinval
    wire [2:0] game_state_code_w;

    and andGambiarra [1:0](game_state_code_w[1:0] , game_state_code);

    // Mux4x1 decide qual código enviar para o decoder do display utilizando a contagem do contador como seleção, dessa maneira, as informações serão sincronizadas com a coluna acesa.
    mux4x1 displayCode0 [2:0](
        .in_a (game_state_code_w) , //1
        .in_c (x_coord_code) , //3
        .in_d (y_coord_code) , //4
        .select (counterOut[1:0]) ,
        .enable (enable) ,

        .out (displayCodeOut)
    );

    wire[2:0] displayCodeOut;

    //Decodificador do display de sete segmentos.
    //Recebe 3 bits e decodifica nos sinais de ativação para cada segmento do display. 
    display_decoder displayDecoder(
        .binary_code (displayCodeOut) ,
        .enable (enable) ,

        .digitOut (display_colune_data)
    );

    /////JOGO//////

    //PIPO para salvar o código do mapa. Ativado no modo de ataque. Resetado no modo desligado.
    d_flipflop saveMapCode [2:0] (
			.d (map_code) ,
			.clk (enableAttack) ,
			.reset (enable) ,
	 
			.out(savedMapCode)
	);
	 
	wire [2:0] savedMapCode;
	 
    //Mux2x1 para selecionar qual código deve ser passado ao decodificador de mapas. Caso no modo de ataque: Código salvo; Caso no modo de preparação: código dos inputs.
	mux2x1 codeSelect [2:0] (
			.in_a (map_code) ,
			.in_b (savedMapCode) ,
			.select (enableAttack) ,
			.enable (enable) ,
			
			.out (finalMapCode)
	);

    wire [2:0] finalMapCode;

    //decodificador de mapas. Recebe um código de 3 bits e decodifica em um mapa com 35 bits. Há 5 possíveis mapas.
    map_decoder_5maps mapDecoder (
        .map_code (finalMapCode) ,

        .map      (map)
    );

    wire [34:0] map;
    
    //Inversão da lógica do botão para seguir a lógica positiva dos flipflops
    not not_confirm_attack (notConfirmAttack , debouncedConfirmAttack);

    //2 Demux conectam o sinal do botão à um dos clocks do PIPO de 35 bits, que é usado como histórico de ataques.
    //O primeiro, um demux1x7(implementado utilizando um demux1x8), utiliza a coordenada Y como seleção, para decidir qual linha conectar o botão ao clock. 
    demux1x8 yCoordDemuxHitsMap (
        .in     (notConfirmAttack) , 
        .select (y_coord_code) ,
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

    //A saída primeiro demux é conectada à entrada do segundo demux1x5, que será responsável por conectar definitivamente o botão de confirmação de ataque ao clock do flipflop do PIPO que representa a coordenada selecionada. Utilizando a coordenada X como seleção.

    //Para simular um demux1x5
    not notXCoord2 (notXCoordCode2 , x_coord_code[2]);

    and andEnableDemux0 (enableDemux0 , notXCoordCode2 , enableAttack);

    demux1x4 xCoordDemuxHitsMap_0 [6:0] (
        .in     (hits_map_clk_colune) , 
        .select (x_coord_code[1:0]) ,
        .enable (enableDemux0) ,
        
        .out_a  (hits_map_clk[34:28]) ,
        .out_b  (hits_map_clk[27:21]) ,
        .out_c  (hits_map_clk[20:14]) ,
        .out_d  (hits_map_clk[13:7]) 
    );
    //quinta entrada do " demux5x1 " 
    and andHitsMapClk [6:0] (hits_map_clk[6:0] , hits_map_clk_colune , x_coord_code[2] , enableAttack);
	 
	wire [34:0] hits_map_clk;

    // PIPO de 35 bits que serve como histórico de ataques.
    //O clock dos flipflops são controlados especificamente, pelos demux acima e o botão de confirmar ataque.
    // Ao pressionar o botão, após decidir as coordenadas, o sinal de nível alto é repassado pelos demux ao clock do flipflop que representa aquela coordenada. Ao ser ativado, o flip flop passa a ter nível lógico alto, já que a entrada de todos os flipflops estão fixas em valor alto.
    d_flipflop hits_map_register [34:0] (
        .d     (1'b1) ,
        .clk   (hits_map_clk) ,
        .reset (enableAttack) ,

        .out   (hitsRegisterOut)
    );
	 
	wire [34:0] hitsRegisterOut , notHistRegisterOut , correctHitsOut;

    // Lógica combinacional para gerar o mapa de acertos
    // ~HA + M
    not notHistRegister [34:0] (notHistRegisterOut , hitsRegisterOut); 

	or correctHits [34:0] (correctHitsOut , notHistRegisterOut , map);

    //Mux2x1 para decidir qual mapa mostrar na matriz. Caso no modo de preparação: Mostrar a saída do decoder, para que o mapa seja visualizado e selecionado. Caso no modo de Ataque: Mostrar o mapa de acertos corretos.

    mux2x1 matrixData [34:0] (
        .in_a (correctHitsOut) ,
        .in_b (map) ,
        .select (enablePreparation) ,
        .enable (enable) ,

        .out (matrixDataOut)
    ); 

    wire [34:0] matrixDataOut;

    //Simulando MUX5x1 com 1 mux4x1 e 1 mux2x1.
    //Mux5x1 utilizado para completar a multiplexação da matriz, a informação que será mostrada na coluna acesa é decidida pelo contador, sua contagem é utilizada como seleção do mux.
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

    //Mesma lógica aplicada  para ativar flip flop individualmente no registro pipo é utilizado para conectar um bit especifico da saída do decoder(35 bits) ao ledrgb, que reagirá ao seu valor. 
    //Caso tenha barco = verde
    //Caso não tenha barco = vermelho

    //Mux5x1 com coordenada X como seleção
    mux4x1 xCoordMuxLedRgb_0 [6:0](
        .in_a   (correctHitsOut[34:28]) ,
        .in_b   (correctHitsOut[27:21]) ,
        .in_c   (correctHitsOut[20:14]) ,
        .in_d   (correctHitsOut[13:7]) ,
        .select (x_coord_code[1:0]) ,
        .enable (enableAttack) ,

        .out    (correctHitsOut_colune_0)
    );

    mux2x1 xCoordMuxLedRgb_1 [6:0] (
        .in_a   (correctHitsOut_colune_0) ,
        .in_b   (correctHitsOut[6:0]) ,
        .select (x_coord_code[2]) ,
        .enable (enableAttack) ,

        .out    (correctHitsOut_colune)
    );

    wire [6:0] correctHitsOut_colune_0 , correctHitsOut_colune;

    //Mux7x1 com coordenada Y como seleção.
    mux8x1 yCoordMuxLedRgb (
        .in_a   (correctHitsOut_colune[0]) ,
        .in_b   (correctHitsOut_colune[1]) ,
        .in_c   (correctHitsOut_colune[2]) ,
        .in_d   (correctHitsOut_colune[3]) ,
        .in_e   (correctHitsOut_colune[4]) ,
        .in_f   (correctHitsOut_colune[5]) ,
        .in_g   (correctHitsOut_colune[6]) ,
        .select (y_coord_code) ,
        .enable (enableAttack) ,

        .out    (ledRgbRed)
    );

    //Invalidar o código Y = 111.
    nand nandInvalidYCoord ( invalidYCoord , y_coord_code[2] , y_coord_code[1] , y_coord_code[0] );

    not notRed (ledRgbGreen , ledRgbRed);

    // o ledrgb apenas acenderá caso esteja no modo de ataque e botão de confirmação for pressionado.
    and andGreen (ledRgb[0] , ledRgbGreen , notConfirmAttack , invalidYCoord , enableAttack);
    and andRed   (ledRgb[1] , ledRgbRed   , notConfirmAttack , invalidYCoord , enableAttack);


endmodule