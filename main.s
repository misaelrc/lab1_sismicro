; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

DIG0_PQ	EQU	2_1111
DIG0_PA	EQU	2_00110000
DIG1_PQ	EQU	2_0110
DIG1_PA	EQU	2_00000000
DIG2_PQ	EQU	2_1101
DIG2_PA	EQU	2_01010000
DIG3_PQ	EQU	2_1111
DIG3_PA	EQU	2_01000000
DIG4_PQ	EQU	2_0110
DIG4_PA	EQU	2_01100000
DIG5_PQ	EQU	2_1011
DIG5_PA	EQU	2_01100000
DIG6_PQ	EQU	2_1011
DIG6_PA	EQU	2_01110000
DIG7_PQ	EQU	2_1110
DIG7_PA	EQU	2_00000000
DIG8_PQ	EQU	2_1111
DIG8_PA	EQU	2_01110000
DIG9_PQ	EQU	2_1110
DIG9_PA	EQU	2_01100000

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


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

MainLoop
; ****************************************
; Escrever c�digo que l� o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************
	BL Digito0
	B MainLoop

;--------------------------------------------------------------------------------
; Fun��o Pisca_LED
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
Pisca_LED
; ****************************************
; Escrever fun��o que acende o LED, espera 1 segundo, apaga o LED e espera 1 s
; Esta fun��o deve chamar a rotina SysTick_Wait1ms com o par�metro de entrada em R0
; ****************************************

Digito0
	PUSH{LR}
	MOV R0, #DIG0_PQ	
	BL PortQ_Output	
	MOV R0, #DIG0_PA	
	BL PortA_Output	
	POP{LR}
	BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
