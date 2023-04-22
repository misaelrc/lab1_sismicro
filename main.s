; main.s
; Desenvolvido para a placa EK-TM4C1294XL

; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortP_Output
		IMPORT  PortQ_Output
        IMPORT  PortJ_Input
			
		IMPORT Display_Dezena
		IMPORT Display_Unidade
		IMPORT Led
		IMPORT Turn0n_TransistorQ1
		IMPORT Turn0ff_TransistorQ1


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	MOV R11, #1					;passo da contagem
	MOV R10, #0					;contador
	MOV R9, #0					;estado --> 0 = funcionando / 1 = pausado
	MOV R8, #2_10000000			;estado dos leds
	MOV R7, #0					;dire��o dos leds --> 0 = indo / 1 = voltando
	MOV R6, #0					;estado anterior chave 1 --> 0 = desativado / 1 = ativado
	MOV R5, #0					;conta tempo de exibi��o

MainLoop
; ****************************************
; Escrever c�digo que l� o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************

Exibicao
	MOV R0, R10
	BL Display_Dezena
	MOV R0, R10
	BL Display_Unidade
	MOV R0, R8
	BL Led
	
	ADD R5, #1
	CMP R5, #80
	BLO Exibicao
	
	MOV R5, #0	
	CMP R9, #0
	BNE Pausado
	; se n�o tiver pausado executa aqui
	
	ADD R10, R10, R11
	CMP R10, #99
	IT	HI
	MOVHI R10, #0
	
	CMP R7, #0
	BNE Led_Voltando
	LSR R8, R8, #1
	CMP R8, #2_00000001
	IT	EQ
	MOVEQ R7, #1
	B ler_botoes
Led_Voltando
	LSL R8, R8, #1
	CMP R8, #2_10000000
	IT	EQ
	MOVEQ R7, #0
	
ler_botoes
	BL PortJ_Input				;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
	B  Verifica_Nenhuma

Pausado
	EOR R8, R8, #2_11111111
	B MainLoop
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave est� pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	;TODO - Guardar estado das chaves
	MOV R6, #0
	B MainLoop					 ;Se o teste viu que nenhuma chave est� pressionada, volta para o la�o principal
Verifica_SW1	
	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 est� pressionada
	BNE Verifica_SW2             ;Se o teste falhou, pula
	;TODO - Verificar se sw1 j� n�o estava acionado antes
	CMP R6, #1
	BEQ Ativado_Anteriormente
	;TODO - Fazer incremento de passo e an�lise se � maior que 9 para voltar a 1
	CMP R11, #9
	BLO Passo_menorque9
	MOV R11, #0
Passo_menorque9
	ADD R11, R11, #1
Ativado_Anteriormente	
	MOV R6, #1
	B MainLoop                   ;Volta para o la�o principal
	
Verifica_SW2	
	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 est� pressionada
	BNE Verifica_Ambas           ;Se o teste falhou, pula
	MOV R6, #0
	;TODO - Pausar a contagem
	MOV R9, #1
	MOV R8, #2_11111111
	B MainLoop                   ;Volta para o la�o principal	
Verifica_Ambas
	CMP R0, #2_00000000			 ;Verifica se ambas as chaves est�o pressionadas
	BNE MainLoop          		 ;Se o teste falhou, pula

	B MainLoop                   ;Volta para o la�o principal

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
