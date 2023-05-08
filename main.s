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

; Estados
ABERTO			EQU 0x1
FECHANDO		EQU 0x2
FECHADO			EQU 0x3
ABRINDO			EQU 0x4
TRAVADO			EQU 0x5

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
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortP_Output
		IMPORT  PortQ_Output
        IMPORT  PortJ_Input
			
		IMPORT Led
		IMPORT Turn0n_TransistorQ1
		IMPORT Turn0ff_TransistorQ1
		
		IMPORT Lcd_Init
		IMPORT LcdMsgCofreAberto
		
		IMPORT CofreAberto
		IMPORT CofreFechando
		IMPORT CofreFechado
		IMPORT CofreAbrindo
		IMPORT CofreTravado


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	MOV R12, #ABERTO			;estado do cofre
	MOV R11, #0					;estado anterior do cofre
	MOV R10, #0					;contador caracteres senha
	MOV R9, #0					;guarda a senha temporariamente
	MOV R8, #0					;contador deslocamento esquerda msg (aberto) / contador mudar estado led (travado)
	MOV R7, #0					;contador senhas incorretas (fechado) / bits dos leds (travado)
	MOV R6, #0					;flag pra liberar pra colocar senha mestra
	
	BL Lcd_Init
	BL LcdMsgCofreAberto
MainLoop
	CMP R12, #ABERTO
	BLEQ CofreAberto
	
	CMP R12, #FECHANDO
	BLEQ CofreFechando
	
	CMP R12, #FECHADO
	BLEQ CofreFechado
	
	CMP R12, #ABRINDO
	BLEQ CofreAbrindo
	
	CMP R12, #TRAVADO
	BLEQ CofreTravado

	B MainLoop                   ;Volta para o laço principal

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
