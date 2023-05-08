; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT A
GPIO_PORTA_LOCK_R    		EQU    0x40058520
GPIO_PORTA_CR_R      		EQU    0x40058524
GPIO_PORTA_AMSEL_R   		EQU    0x40058528
GPIO_PORTA_PCTL_R    		EQU    0x4005852C
GPIO_PORTA_DIR_R     		EQU    0x40058400
GPIO_PORTA_AFSEL_R   		EQU    0x40058420
GPIO_PORTA_DEN_R     		EQU    0x4005851C
GPIO_PORTA_PUR_R     		EQU    0x40058510	
GPIO_PORTA_DATA_R    		EQU    0x400583FC
GPIO_PORTA               	EQU    2_000000000000001
	
; PORT B
GPIO_PORTB_LOCK_R    		EQU    0x40059520
GPIO_PORTB_CR_R      		EQU    0x40059524
GPIO_PORTB_AMSEL_R   		EQU    0x40059528
GPIO_PORTB_PCTL_R    		EQU    0x4005952C
GPIO_PORTB_DIR_R     		EQU    0x40059400
GPIO_PORTB_AFSEL_R   		EQU    0x40059420
GPIO_PORTB_DEN_R     		EQU    0x4005951C
GPIO_PORTB_PUR_R     		EQU    0x40059510	
GPIO_PORTB_DATA_R    		EQU    0x400593FC
GPIO_PORTB               	EQU    2_000000000000010
	
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ_AHB_IM_R			EQU	   0x40060410
GPIO_PORTJ_AHB_IS_R			EQU	   0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU	   0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU	   0x4006040C
GPIO_PORTJ_AHB_ICR_R		EQU	   0x4006041C
GPIO_PORTJ_AHB_RIS_R		EQU    0x40060414
GPIO_PORTJ               	EQU    2_000000100000000

; PORT K
GPIO_PORTK_LOCK_R    		EQU    0x40061520
GPIO_PORTK_CR_R      		EQU    0x40061524
GPIO_PORTK_AMSEL_R   		EQU    0x40061528
GPIO_PORTK_PCTL_R    		EQU    0x4006152C
GPIO_PORTK_DIR_R     		EQU    0x40061400
GPIO_PORTK_AFSEL_R   		EQU    0x40061420
GPIO_PORTK_DEN_R     		EQU    0x4006151C
GPIO_PORTK_PUR_R     		EQU    0x40061510	
GPIO_PORTK_DATA_R    		EQU    0x400613FC
GPIO_PORTK               	EQU    2_000001000000000
	
; PORT L
GPIO_PORTL_LOCK_R    		EQU    0x40062520
GPIO_PORTL_CR_R      		EQU    0x40062524
GPIO_PORTL_AMSEL_R   		EQU    0x40062528
GPIO_PORTL_PCTL_R    		EQU    0x4006252C
GPIO_PORTL_DIR_R     		EQU    0x40062400
GPIO_PORTL_AFSEL_R   		EQU    0x40062420
GPIO_PORTL_DEN_R     		EQU    0x4006251C
GPIO_PORTL_PUR_R     		EQU    0x40062510	
GPIO_PORTL_DATA_R    		EQU    0x400623FC
GPIO_PORTL               	EQU    2_000010000000000
	
; PORT M
GPIO_PORTM_LOCK_R    		EQU    0x40063520
GPIO_PORTM_CR_R      		EQU    0x40063524
GPIO_PORTM_AMSEL_R   		EQU    0x40063528
GPIO_PORTM_PCTL_R    		EQU    0x4006352C
GPIO_PORTM_DIR_R     		EQU    0x40063400
GPIO_PORTM_AFSEL_R   		EQU    0x40063420
GPIO_PORTM_DEN_R     		EQU    0x4006351C
GPIO_PORTM_PUR_R     		EQU    0x40063510	
GPIO_PORTM_DATA_R    		EQU    0x400633FC
GPIO_PORTM               	EQU    2_000100000000000
	
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000
	
; PORT P
GPIO_PORTP_LOCK_R    		EQU    0x40065520
GPIO_PORTP_CR_R      		EQU    0x40065524
GPIO_PORTP_AMSEL_R   		EQU    0x40065528
GPIO_PORTP_PCTL_R    		EQU    0x4006552C
GPIO_PORTP_DIR_R     		EQU    0x40065400
GPIO_PORTP_AFSEL_R   		EQU    0x40065420
GPIO_PORTP_DEN_R     		EQU    0x4006551C
GPIO_PORTP_PUR_R     		EQU    0x40065510	
GPIO_PORTP_DATA_R    		EQU    0x400653FC
GPIO_PORTP               	EQU    2_010000000000000
	
; PORT Q
GPIO_PORTQ_LOCK_R    		EQU    0x40066520
GPIO_PORTQ_CR_R      		EQU    0x40066524
GPIO_PORTQ_AMSEL_R   		EQU    0x40066528
GPIO_PORTQ_PCTL_R    		EQU    0x4006652C
GPIO_PORTQ_DIR_R     		EQU    0x40066400
GPIO_PORTQ_AFSEL_R   		EQU    0x40066420
GPIO_PORTQ_DEN_R     		EQU    0x4006651C
GPIO_PORTQ_PUR_R     		EQU    0x40066510	
GPIO_PORTQ_DATA_R    		EQU    0x400663FC
GPIO_PORTQ               	EQU    2_100000000000000
	
NVIC_EN1_R 				EQU	   0xE000E104
NVIC_PRI12_R			EQU    0xE000E430


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
		EXPORT PortK_Output			; Permite chamar PortK_Output de outro arquivo
		EXPORT PortM_Output			; Permite chamar PortM_Output de outro arquivo
		EXPORT PortP_Output			; Permite chamar PortP_Output de outro arquivo
		EXPORT PortQ_Output			; Permite chamar PortQ_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT PortL_Input          ; Permite chamar PortL_Input de outro arquivo
		EXPORT GPIOPortJ_Handler
		
		EXPORT Teclado_ConfiguraLeituraPrimeiraColuna
		EXPORT Teclado_ConfiguraLeituraSegundaColuna
		EXPORT Teclado_ConfiguraLeituraTerceiraColuna
		EXPORT Teclado_ConfiguraLeituraQuartaColuna
			
		IMPORT  SysTick_Wait1ms
									

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Inicializar as portas J e N
; ****************************************
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enabe clock to GPIOF at clock register
	LDR R0, =SYSCTL_RCGCGPIO_R		;Carrega o endereço do registrador RCGCGPIO
	MOV R1, #GPIO_PORTA				;Seta o bit da porta A
	ORR R1, #GPIO_PORTJ				;Seta o bit da porta J, fazendo com OR
	ORR R1, #GPIO_PORTK				;Seta o bit da porta K, fazendo com OR
	ORR R1, #GPIO_PORTL				;Seta o bit da porta L, fazendo com OR
	ORR R1, #GPIO_PORTM				;Seta o bit da porta M, fazendo com OR
	ORR R1, #GPIO_PORTP				;Seta o bit da porta P, fazendo com OR
	ORR R1, #GPIO_PORTQ				;Seta o bit da porta Q, fazendo com OR
	STR R1, [R0]					;Move para a memória os bits das portas no endereço do RCGCGPIO
	
	LDR R0, =SYSCTL_PRGPIO_R		;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR R1, [R0]					;Lê da memória o conteúdo do endereço do registrador
	MOV R2, #GPIO_PORTA				;Seta os bits correspondentes às portas para fazer a comparação
	ORR R2, #GPIO_PORTJ				;Seta o bit da porta J, fazendo com OR
	ORR R2, #GPIO_PORTK				;Seta o bit da porta B, fazendo com OR
	ORR R2, #GPIO_PORTL				;Seta o bit da porta B, fazendo com OR
	ORR R2, #GPIO_PORTM				;Seta o bit da porta B, fazendo com OR
	ORR R2, #GPIO_PORTP				;Seta o bit da porta P, fazendo com OR
	ORR R2, #GPIO_PORTQ				;Seta o bit da porta Q, fazendo com OR
	TST R1, R2						;Testa o R1 com R2 fazendo R1 & R2
	BEQ EsperaGPIO					;Se o flag Z=1, volta para o laço. Senão continua executando
	
;2. Limpar o AMSEL para desabilitar a analógica
	MOV R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
	LDR R0, =GPIO_PORTA_AMSEL_R     	;Carrega o R0 com o endereço do AMSEL para a porta A
	STR R1, [R0]						;Guarda no registrador AMSEL da porta A da memória
	LDR R0, =GPIO_PORTJ_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta J
	STR R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
	LDR R0, =GPIO_PORTK_AMSEL_R     	;Carrega o R0 com o endereço do AMSEL para a porta K
	STR R1, [R0]						;Guarda no registrador AMSEL da porta K da memória
	LDR R0, =GPIO_PORTL_AMSEL_R     	;Carrega o R0 com o endereço do AMSEL para a porta L
	STR R1, [R0]						;Guarda no registrador AMSEL da porta L da memória
	LDR R0, =GPIO_PORTM_AMSEL_R     	;Carrega o R0 com o endereço do AMSEL para a porta M
	STR R1, [R0]						;Guarda no registrador AMSEL da porta M da memória
	LDR R0, =GPIO_PORTP_AMSEL_R			;Carrega o R0 com o endereço do AMSEL para a porta P
	STR R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
	LDR R0, =GPIO_PORTQ_AMSEL_R     	;Carrega o R0 com o endereço do AMSEL para a porta Q
	STR R1, [R0]						;Guarda no registrador AMSEL da porta Q da memória
	
; 3. Limpar PCTL para selecionar o GPIO
	MOV R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
	LDR R0, =GPIO_PORTA_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta A
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
	LDR R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
	LDR R0, =GPIO_PORTK_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta K
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta K da memória
	LDR R0, =GPIO_PORTL_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta L
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta L da memória
	LDR R0, =GPIO_PORTM_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta M
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta M da memória
	LDR R0, =GPIO_PORTP_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta P
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
	LDR R0, =GPIO_PORTQ_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta Q
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
	
; 4. DIR para 0 se for entrada, 1 se for saída
	LDR R0, =GPIO_PORTA_DIR_R			;Carrega o R0 com o endereço do DIR para a porta A
	MOV R1, #2_11110000					;PA4, PA5, PA6, PA7
	STR R1, [R0]						;Guarda no registrador DIR da porta A da memória
	LDR R0, =GPIO_PORTK_DIR_R			;Carrega o R0 com o endereço do DIR para a porta K 
	MOV R1, #2_11111111					;PK0, PK1, PK2, PK3, PK4, PK5, PK6, PK7
	STR R1, [R0]						;Guarda no registrador DIR da porta K da memória
	LDR R0, =GPIO_PORTM_DIR_R			;Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_00000111					;PM0, PM1, PM2, outro entrada
	STR R1, [R0]						;Guarda no registrador DIR da porta M da memória
	LDR R0, =GPIO_PORTP_DIR_R			;Carrega o R0 com o endereço do DIR para a porta P
	MOV R1, #2_100000					;PP5
	STR R1, [R0]						;Guarda no registrador DIR da porta P da memória
	LDR R0, =GPIO_PORTQ_DIR_R			;Carrega o R0 com o endereço do DIR para a porta Q
	MOV R1, #2_01111					;PQ0, PQ1, PQ2, PQ3
	STR R1, [R0]						;Guarda no registrador DIR da porta Q da memória

	; O certo era verificar os outros bits da PJ para não transformar entradas em saídas desnecessárias
	LDR R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
	MOV R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com entrada
	STR R1, [R0]						;Guarda no registrador DIR da porta J da memória
	LDR R0, =GPIO_PORTL_DIR_R			;Carrega o R0 com o endereço do DIR para a porta L
	MOV R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com entrada
	STR R1, [R0]						;Guarda no registrador DIR da porta L da memória
	
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa
	MOV R1, #0x00						;Colocar o valor 0 para não setar função alternativa
	LDR R0, =GPIO_PORTA_AFSEL_R			;Carrega o endereço do AFSEL da porta A
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
	STR R1, [R0]                        ;Escreve na porta
	LDR R0, =GPIO_PORTK_AFSEL_R			;Carrega o endereço do AFSEL da porta K
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTL_AFSEL_R			;Carrega o endereço do AFSEL da porta L
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTM_AFSEL_R			;Carrega o endereço do AFSEL da porta M
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTP_AFSEL_R			;Carrega o endereço do AFSEL da porta P
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTQ_AFSEL_R			;Carrega o endereço do AFSEL da porta Q
	STR R1, [R0]						;Escreve na porta
	
	
; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTA_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_11110000                     ;A4, A5, A6, A7
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
	LDR R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
	MOV R1, #2_00000001                     ;J0
	STR R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
	LDR R0, =GPIO_PORTK_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_11111111                     ;K0, K1, K2, K3, K4, K5, K6, K7
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
	LDR R0, =GPIO_PORTL_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_00001111                     ;L0, L1, L2, L3
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
	
	LDR R0, =GPIO_PORTM_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_11110111                     ;M0, M1, M2 ; depois  ver os do teclado
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
	
	LDR R0, =GPIO_PORTP_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_00100000                     ;P5
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital
	LDR R0, =GPIO_PORTQ_DEN_R			    ;Carrega o endereço do DEN
	MOV R1, #2_00001111                     ;Q0, Q1, Q2, Q3
	STR R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
 
	
	
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
	MOV R1, #2_1							;Habilitar funcionalidade digital de resistor de pull-up 
	STR R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
	LDR R0, =GPIO_PORTL_PUR_R				;Carrega o endereço do PUR para a porta L
	MOV R1, #2_1111							;Habilitar funcionalidade digital de resistor de pull-up 
	STR R1, [R0]							;Escreve no registrador da memória do resistor de pull-up

; Interrupções
; 1. Desabilitar GPIOIM
	LDR		R0, =GPIO_PORTJ_AHB_IM_R
	MOV		R1, #2_0
	STR		R1, [R0]
			
; 2. Configurar como borda J0 no GPIOIS
	LDR		R0, =GPIO_PORTJ_AHB_IS_R
	MOV		R1, #2_0
	STR		R1, [R0]
			
; 3.a Configurar borda única J0 no GPIOIBE
	LDR		R0, =GPIO_PORTJ_AHB_IBE_R
	MOV		R1, #2_0
	STR		R1, [R0]
			
; 3.b Configurar borda descida J0 no GPIOIEV
	LDR		R0, =GPIO_PORTJ_AHB_IEV_R
	MOV		R1, #2_0
	STR		R1, [R0]

; 4. Limpar GPIORIS e GPIOMIS realizando o ACK no GPIOICR para J0
	LDR		R0, =GPIO_PORTJ_AHB_ICR_R
	MOV 	R1, #2_1
	STR		R1, [R0]
; 5. Habilitar GPIOIM
			LDR		R0, =GPIO_PORTJ_AHB_IM_R
			MOV		R1, #2_1
			STR		R1, [R0]
			
; 6. Ativar fonte de interrupção no NVIC
			LDR 	R0, =NVIC_EN1_R
			MOV		R1, #2_1
			LSL		R1, R1, #19
			STR		R1, [R0]
; 7. Configurar a prioridade da fonte de interrupção no NVIC
			LDR		R0, =NVIC_PRI12_R
			MOV 	R1, #2_101
			LSL 	R1, R1, #29
			STR 	R1, [R0]
	BX LR

; -------------------------------------------------------------------------------
; Função PortA_Output
; Parâmetro de entrada: R0 --> Se pinos [A7-A4] estão ligados ou desligados
; Parâmetro de saída: Não tem
PortA_Output
	LDR	R1, =GPIO_PORTA_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos [A7-A4]
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Função PortK_Output
; Parâmetro de entrada: R0 --> Se pinos B5 e B4 estão ligados ou desligados
; Parâmetro de saída: Não tem
PortK_Output
	LDR	R1, =GPIO_PORTK_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11111111                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta B o barramento de dados dos pinos B5 e B4
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Função PortM_Output
; Parâmetro de entrada: R0 --> Se pinos B5 e B4 estão ligados ou desligados
; Parâmetro de saída: Não tem
PortM_Output
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000111                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta M o barramento de dados dos pinos 
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Função PortP_Output
; Parâmetro de entrada: R0 --> Se pino P5 está ligado ou desligado
; Parâmetro de saída: Não tem
PortP_Output
	LDR	R1, =GPIO_PORTP_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00100000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta P o barramento de dados do pino P5
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função PortQ_Output
; Parâmetro de entrada: R0 --> Se pinos [Q3-Q0] estão ligados ou desligados
; Parâmetro de saída: Não tem
PortQ_Output
	LDR	R1, =GPIO_PORTQ_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta Q o barramento de dados dos pinos [Q3-Q0]
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Função PortL_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortL_Input
	LDR	R1, =GPIO_PORTL_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno


; FUNÇÕES PARA LEITURA DO TECLADO MATRICIAL

; -------------------------------------------------------------------------------
; Função Teclado_ConfiguraLeituraPrimeiraColuna
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Teclado_ConfiguraLeituraPrimeiraColuna
	PUSH{LR}
	
	LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_00000111					; PM0, PM1, PM2, outro entrada
	STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	MOV R0, #50                ; debounce: Chamar a rotina para esperar 500 ms
	BL SysTick_Wait1ms
	
	LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_00010111					; PM0, PM1, PM2, outro entrada
	STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00010000                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	
	MOV R0, #0x0
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta M o barramento de dados dos pinos 
	POP{LR}
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função Teclado_ConfiguraLeituraSegundaColuna
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Teclado_ConfiguraLeituraSegundaColuna
	PUSH{LR}
	
	;LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	;MOV R1, #2_00000111					; PM0, PM1, PM2, outro entrada
	;STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	;MOV R0, #50                ; debounce: Chamar a rotina para esperar 500 ms
	;BL SysTick_Wait1ms
	
	LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_00100111					; PM0, PM1, PM2, outro entrada
	STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00100000                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	
	MOV R0, #0x0
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta M o barramento de dados dos pinos 
	POP{LR}
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função Teclado_ConfiguraLeituraTerceiraColuna
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Teclado_ConfiguraLeituraTerceiraColuna
	PUSH{LR}
	
	;LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	;MOV R1, #2_00000111					; PM0, PM1, PM2, outro entrada
	;STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	;MOV R0, #50                ; debounce: Chamar a rotina para esperar 500 ms
	;BL SysTick_Wait1ms
	
	LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_01000111					; PM0, PM1, PM2, outro entrada
	STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_01000000                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	
	MOV R0, #0x0
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta M o barramento de dados dos pinos 
	POP{LR}
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função Teclado_ConfiguraLeituraQuartaColuna
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Teclado_ConfiguraLeituraQuartaColuna
	PUSH{LR}
	
	;LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	;MOV R1, #2_00000111					; PM0, PM1, PM2, outro entrada
	;STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	;MOV R0, #50                ; debounce: Chamar a rotina para esperar 500 ms
	;BL SysTick_Wait1ms
	
	LDR R0, =GPIO_PORTM_DIR_R			; Carrega o R0 com o endereço do DIR para a porta M 
	MOV R1, #2_10000111					; PM0, PM1, PM2, outro entrada
	STR R1, [R0]						; Guarda no registrador DIR da porta M da memória
	
	
	LDR	R1, =GPIO_PORTM_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_10000000                     ;Primeiro limpamos os bits do lido da porta R2 = R2 & 11111101
	
	MOV R0, #0x0
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta M o barramento de dados dos pinos 
	POP{LR}
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função GPIOPortJ_Handler
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
GPIOPortJ_Handler
	PUSH{LR}
	;como só tem um pino com interrupção habilitado na porta J, não precisa fazer
	;verificação de qual pino veio a interrupção

	LDR	R0, =GPIO_PORTJ_AHB_ICR_R
	MOV 	R1, #2_1
	STR		R1, [R0]
	
	;debounce
	MOV R0, #500
	BL SysTick_Wait1ms
	
	CMP R12, #0x5				;TRAVADO
	BNE saida
	MOV R6, #1
saida
	POP {LR}
	BX LR
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo