; estados.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Estados
ABERTO			EQU 0x1
FECHANDO		EQU 0x2
FECHADO			EQU 0x3
ABRINDO			EQU 0x4
TRAVADO			EQU 0x5
DESTRAVAMENTO	EQU 0x6

; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	

		EXPORT CofreAberto
		EXPORT CofreFechando
		EXPORT CofreFechado
		EXPORT CofreAbrindo
		EXPORT CofreTravado			
			
		; Se chamar alguma fun��o externa
		IMPORT  SysTick_Wait1ms			
        IMPORT  PortA_Output
		IMPORT  PortQ_Output

		IMPORT Turn0n_TransistorQ1
		IMPORT Turn0ff_TransistorQ1
			
		IMPORT Led
			
		IMPORT LcdMsgCofreAberto
		IMPORT LcdMsgCofreFechando
		IMPORT LcdMsgCofreFechado
		IMPORT LcdMsgCofreAbrindo
		IMPORT LcdMsgCofreTravado
		
		IMPORT LcdDeslocaEsquerda
			
		IMPORT SetaSenha
		IMPORT ComparaSenha

;--------------------------------------------------------------------------------
; CofreAberto
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
CofreAberto
	PUSH{LR}
		
	CMP R12, R11
	BEQ LoopCofreAberto
	BLNE LcdMsgCofreAberto
	MOV R8, #0
LoopCofreAberto
	ADD R8, #1
	CMP R8, #3
	ITT GE
	MOVGE R8, #0
	BLGE LcdDeslocaEsquerda
	BL SetaSenha
	MOV R11, #ABERTO
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; CofreFechando
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
CofreFechando
	PUSH{LR}
	BL LcdMsgCofreFechando
	
	MOV R0, #5000
	BL SysTick_Wait1ms
	
	MOV R11, #FECHANDO
	MOV R12, #FECHADO
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; CofreFechado
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
CofreFechado
	PUSH{LR}
	
	CMP R12, R11
	BEQ LoopCofreFechado
	BLNE LcdMsgCofreFechado
	MOV R7, #0
LoopCofreFechado
	CMP R7, #3
	IT	GE
	MOVGE R12, #TRAVADO
	
	BL ComparaSenha
	MOV R11, #FECHADO
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; CofreAbrindo
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
CofreAbrindo
	PUSH{LR}
	BL LcdMsgCofreAbrindo
	
	MOV R0, #5000
	BL SysTick_Wait1ms
	
	MOV R11, #ABRINDO
	MOV R12, #ABERTO
	
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; CofreTravado
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
CofreTravado
	PUSH{LR}
	
	CMP R12, R11
	BEQ LoopCofreTravado
	BLNE LcdMsgCofreTravado
	MOV R7, #2_11111111
	MOV R8, #0
	MOV R6, #0
	BL Led
	
LoopCofreTravado
	ADD R8, #1
	CMP R6, #1
	ITE NE
	MOVNE R0, #250
	MOVEQ R0, #10
	CMP R8, R0
	BLO pula_led
	MOV R8, #0	
	EOR R7, R7, #2_11111111
	
pula_led
	BL Led
	CMP R6, #1
	BLEQ ComparaSenha
	;verificar flag que libera pra destravar e verificar senha mestra
	MOV R11, #TRAVADO
	POP{LR}
	BX LR

	
	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo