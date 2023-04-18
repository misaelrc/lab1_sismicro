; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
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
GPIO_PORTJ               	EQU    2_000000100000000
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


; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
		EXPORT PortB_Output			; Permite chamar PortB_Output de outro arquivo
		EXPORT PortP_Output			; Permite chamar PortP_Output de outro arquivo
		EXPORT PortQ_Output			; Permite chamar PortQ_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
									

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; ****************************************
; Escrever fun��o de inicializa��o dos GPIO
; Inicializar as portas J e N
; ****************************************
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enabe clock to GPIOF at clock register
	LDR R0, =SYSCTL_RCGCGPIO_R		;Carrega o endere�o do registrador RCGCGPIO
	MOV R1, #GPIO_PORTA				;Seta o bit da porta A
	ORR R1, #GPIO_PORTB				;Seta o bit da porta B, fazendo com OR
	ORR R1, #GPIO_PORTJ				;Seta o bit da porta J, fazendo com OR
	ORR R1, #GPIO_PORTP				;Seta o bit da porta P, fazendo com OR
	ORR R1, #GPIO_PORTQ				;Seta o bit da porta Q, fazendo com OR
	STR R1, [R0]					;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
	
	LDR R0, =SYSCTL_PRGPIO_R		;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR R1, [R0]					;L� da mem�ria o conte�do do endere�o do registrador
	MOV R2, #GPIO_PORTA				;Seta os bits correspondentes �s portas para fazer a compara��o
	ORR R2, #GPIO_PORTB				;Seta o bit da porta B, fazendo com OR
	ORR R2, #GPIO_PORTJ				;Seta o bit da porta J, fazendo com OR
	ORR R2, #GPIO_PORTP				;Seta o bit da porta P, fazendo com OR
	ORR R2, #GPIO_PORTQ				;Seta o bit da porta Q, fazendo com OR
	TST R1, R2						;Testa o R1 com R2 fazendo R1 & R2
	BEQ EsperaGPIO					;Se o flag Z=1, volta para o la�o. Sen�o continua executando
	
;2. Limpar o AMSEL para desabilitar a anal�gica
	MOV R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
	LDR R0, =GPIO_PORTA_AMSEL_R     	;Carrega o R0 com o endere�o do AMSEL para a porta A
	STR R1, [R0]						;Guarda no registrador AMSEL da porta A da mem�ria
	LDR R0, =GPIO_PORTB_AMSEL_R     	;Carrega o R0 com o endere�o do AMSEL para a porta B
	STR R1, [R0]						;Guarda no registrador AMSEL da porta B da mem�ria
	LDR R0, =GPIO_PORTJ_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta J
	STR R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
	LDR R0, =GPIO_PORTP_AMSEL_R			;Carrega o R0 com o endere�o do AMSEL para a porta P
	STR R1, [R0]						;Guarda no registrador AMSEL da porta P da mem�ria
	LDR R0, =GPIO_PORTQ_AMSEL_R     	;Carrega o R0 com o endere�o do AMSEL para a porta Q
	STR R1, [R0]						;Guarda no registrador AMSEL da porta Q da mem�ria
	
; 3. Limpar PCTL para selecionar o GPIO
	MOV R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
	LDR R0, =GPIO_PORTA_PCTL_R      	;Carrega o R0 com o endere�o do PCTL para a porta A
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta A da mem�ria
	LDR R0, =GPIO_PORTB_PCTL_R      	;Carrega o R0 com o endere�o do PCTL para a porta B
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta B da mem�ria
	LDR R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
	LDR R0, =GPIO_PORTP_PCTL_R      	;Carrega o R0 com o endere�o do PCTL para a porta P
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta P da mem�ria
	LDR R0, =GPIO_PORTQ_PCTL_R      	;Carrega o R0 com o endere�o do PCTL para a porta Q
	STR R1, [R0]                        ;Guarda no registrador PCTL da porta Q da mem�ria
	
; 4. DIR para 0 se for entrada, 1 se for sa�da
	LDR R0, =GPIO_PORTA_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta A
	MOV R1, #2_11110000					;PA4, PA5, PA6, PA7
	STR R1, [R0]						;Guarda no registrador DIR da porta A da mem�ria
	LDR R0, =GPIO_PORTB_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta B 
	MOV R1, #2_110000					;PB4, PB5
	STR R1, [R0]						;Guarda no registrador DIR da porta B da mem�ria
	LDR R0, =GPIO_PORTP_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta P
	MOV R1, #2_100000					;PP5
	STR R1, [R0]						;Guarda no registrador DIR da porta P da mem�ria
	LDR R0, =GPIO_PORTQ_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta Q
	MOV R1, #2_01111					;PQ0, PQ1, PQ2, PQ3
	STR R1, [R0]						;Guarda no registrador DIR da porta Q da mem�ria

	; O certo era verificar os outros bits da PJ para n�o transformar entradas em sa�das desnecess�rias
	LDR R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
	MOV R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com entrada
	STR R1, [R0]						;Guarda no registrador DIR da porta J da mem�ria
	
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem fun��o alternativa
	MOV R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
	LDR R0, =GPIO_PORTA_AFSEL_R			;Carrega o endere�o do AFSEL da porta A
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTB_AFSEL_R			;Carrega o endere�o do AFSEL da porta B
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTP_AFSEL_R			;Carrega o endere�o do AFSEL da porta P
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTQ_AFSEL_R			;Carrega o endere�o do AFSEL da porta Q
	STR R1, [R0]						;Escreve na porta
	LDR R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
	STR R1, [R0]                        ;Escreve na porta
	
; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTA_DEN_R			    ;Carrega o endere�o do DEN
	MOV R1, #2_11110000                     ;A4, A5, A6, A7
	STR R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
	LDR R0, =GPIO_PORTB_DEN_R			    ;Carrega o endere�o do DEN
	MOV R1, #2_00110000                     ;B4, B5
	STR R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
	LDR R0, =GPIO_PORTP_DEN_R			    ;Carrega o endere�o do DEN
	MOV R1, #2_00100000                     ;P5
	STR R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
	LDR R0, =GPIO_PORTQ_DEN_R			    ;Carrega o endere�o do DEN
	MOV R1, #2_00001111                     ;Q0, Q1, Q2, Q3
	STR R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
 
	LDR R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
	MOV R1, #2_00000011                     ;J0, J1
	STR R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
	
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
	MOV R1, #2_11							;Habilitar funcionalidade digital de resistor de pull-up 
	STR R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
	
	BX LR

; -------------------------------------------------------------------------------
; Fun��o PortA_Output
; Par�metro de entrada: R0 --> Se pinos [A7-A4] est�o ligados ou desligados
; Par�metro de sa�da: N�o tem
PortA_Output
	LDR	R1, =GPIO_PORTA_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta A o barramento de dados dos pinos [A7-A4]
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Fun��o PortB_Output
; Par�metro de entrada: R0 --> Se pinos B5 e B4 est�o ligados ou desligados
; Par�metro de sa�da: N�o tem
PortB_Output
	LDR	R1, =GPIO_PORTB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta B o barramento de dados dos pinos B5 e B4
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Fun��o PortP_Output
; Par�metro de entrada: R0 --> Se pino P5 est� ligado ou desligado
; Par�metro de sa�da: N�o tem
PortP_Output
	LDR	R1, =GPIO_PORTP_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00100000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta P o barramento de dados do pino P5
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Fun��o PortQ_Output
; Par�metro de entrada: R0 --> Se pinos [Q3-Q0] est�o ligados ou desligados
; Par�metro de sa�da: N�o tem
PortQ_Output
	LDR	R1, =GPIO_PORTQ_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta Q o barramento de dados dos pinos [Q3-Q0]
	BX LR									;Retorno
	
; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo