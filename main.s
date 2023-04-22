; main.s
; Desenvolvido para a placa EK-TM4C1294XL

; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
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
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	MOV R11, #1					;passo da contagem
	MOV R10, #0					;contador
	MOV R9, #0					;estado --> 0 = funcionando / 1 = pausado
	MOV R8, #2_10000000			;estado dos leds
	MOV R7, #0					;direção dos leds --> 0 = indo / 1 = voltando
	MOV R6, #0					;estado anterior chave 1 --> 0 = desativado / 1 = ativado
	MOV R5, #0					;conta tempo de exibição

MainLoop
; ****************************************
; Escrever código que lê o estado da chave, se ela estiver desativada apaga o LED
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
	; se não tiver pausado executa aqui
	
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
	BL PortJ_Input				;Chama a subrotina que lê o estado das chaves e coloca o resultado em R0
	B  Verifica_Nenhuma

Pausado
	EOR R8, R8, #2_11111111
	B MainLoop
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave está pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	;TODO - Guardar estado das chaves
	MOV R6, #0
	B MainLoop					 ;Se o teste viu que nenhuma chave está pressionada, volta para o laço principal
Verifica_SW1	
	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 está pressionada
	BNE Verifica_SW2             ;Se o teste falhou, pula
	;TODO - Verificar se sw1 já não estava acionado antes
	CMP R6, #1
	BEQ Ativado_Anteriormente
	;TODO - Fazer incremento de passo e análise se é maior que 9 para voltar a 1
	CMP R11, #9
	BLO Passo_menorque9
	MOV R11, #0
Passo_menorque9
	ADD R11, R11, #1
Ativado_Anteriormente	
	MOV R6, #1
	B MainLoop                   ;Volta para o laço principal
	
Verifica_SW2	
	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 está pressionada
	BNE Verifica_Ambas           ;Se o teste falhou, pula
	MOV R6, #0
	;TODO - Pausar a contagem
	MOV R9, #1
	MOV R8, #2_11111111
	B MainLoop                   ;Volta para o laço principal	
Verifica_Ambas
	CMP R0, #2_00000000			 ;Verifica se ambas as chaves estão pressionadas
	BNE MainLoop          		 ;Se o teste falhou, pula

	B MainLoop                   ;Volta para o laço principal

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
