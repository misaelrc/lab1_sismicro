; ssd.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; ========================

; Portas usadas para cada d�gito
DIG0_PQ	EQU	2_1111
DIG0_PA	EQU	2_00110000
DIG1_PQ	EQU	2_0110
DIG1_PA	EQU	2_00000000
DIG2_PQ	EQU	2_1011
DIG2_PA	EQU	2_01010000
DIG3_PQ	EQU	2_1111
DIG3_PA	EQU	2_01000000
DIG4_PQ	EQU	2_0110
DIG4_PA	EQU	2_01100000
DIG5_PQ	EQU	2_1101
DIG5_PA	EQU	2_01100000
DIG6_PQ	EQU	2_1101
DIG6_PA	EQU	2_01110000
DIG7_PQ	EQU	2_0111
DIG7_PA	EQU	2_00000000
DIG8_PQ	EQU	2_1111
DIG8_PA	EQU	2_01110000
DIG9_PQ	EQU	2_0111
DIG9_PA	EQU	2_01100000


; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Digito_0         		; Permite chamar Digito_0 de outro arquivo
		EXPORT Digito_1					; Permite chamar Digito_1 de outro arquivo
		EXPORT Digito_2					; Permite chamar Digito_2 de outro arquivo
		EXPORT Digito_3					; Permite chamar Digito_3 de outro arquivo
		EXPORT Digito_4					; Permite chamar Digito_4 de outro arquivo
		EXPORT Digito_5          		; Permite chamar Digito_5 de outro arquivo
		EXPORT Digito_6					; Permite chamar Digito_4 de outro arquivo
		EXPORT Digito_7          		; Permite chamar Digito_5 de outro arquivo
		EXPORT Digito_8					; Permite chamar Digito_4 de outro arquivo
		EXPORT Digito_9          		; Permite chamar Digito_5 de outro arquivo
		EXPORT Display_Dezena          	; Permite chamar Display_Dezena de outro arquivo
		EXPORT Display_Unidade          ; Permite chamar Display_Unidade de outro arquivo
			
		; Se chamar alguma fun��o externa
		IMPORT  SysTick_Wait1ms			
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortP_Output
		IMPORT  PortQ_Output

		IMPORT Turn0n_TransistorQ2
		IMPORT Turn0ff_TransistorQ2
		IMPORT Turn0n_TransistorQ3
		IMPORT Turn0ff_TransistorQ3

; Fun��o Display_Dezena
; Par�metro de entrada: R0 --> valor do contador 
; Par�metro de sa�da: N�o tem
*********************************
Display_Dezena
	PUSH {LR}
	BL Turn0n_TransistorQ2				;Chamar a fun��o para setar o transistor Q2
	
	MOV R1, #10
	UDIV R0, R0, R1						;Divide o valor da entrada R0 por 10 e pega a dezena e armazena em R0

	BL BinarioToDigito					;Chamar a fun��o para pegar o valor bin�rio de R0 e ligar o digito correspondente
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	BL Turn0ff_TransistorQ2				;Chamar a fun��o para resetar o transistor Q2
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	POP {LR}
	BX LR

; Fun��o Display_Unidade
; Par�metro de entrada: R0 --> valor do contador
; Par�metro de sa�da: N�o tem
*********************************
Display_Unidade
	PUSH {LR}
	BL Turn0n_TransistorQ3				;Chamar a fun��o para setar o transistor Q3
	
	MOV R1, #10
	UDIV R2, R0, R1						;Divide o valor da entrada R0 por 10 e pega a dezena e armazena em R2
	MLS R0, R2, R1, R0					;Pega unidade ,fazendo entrada (R0) - dezena (R2) * 10, e armazena em R0
	
	BL BinarioToDigito					;Chamar a fun��o para pegar o valor bin�rio de R0 e ligar o digito correspondente
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	BL Turn0ff_TransistorQ3				;Chamar a fun��o para resetar o transistor Q3
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	POP {LR}
	BX LR

;--------------------------------------------------------------------------------
; BinarioToDigito
; Par�metro de entrada: R0 --> n�mero bin�rio para ligar digito correspondente 
; Par�metro de sa�da: N�o tem
*********************************
BinarioToDigito
	PUSH{LR}
	CMP R0, #0
	BLEQ Digito_0
	CMP R0, #1
	BLEQ Digito_1
	CMP R0, #2
	BLEQ Digito_2
	CMP R0, #3
	BLEQ Digito_3
	CMP R0, #4
	BLEQ Digito_4
	CMP R0, #5
	BLEQ Digito_5
	CMP R0, #6
	BLEQ Digito_6
	CMP R0, #7
	BLEQ Digito_7
	CMP R0, #8
	BLEQ Digito_8
	CMP R0, #9
	BLEQ Digito_9	
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; Fun��o Digito_0
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_0
	PUSH{LR}
	MOV R0, #DIG0_PQ	
	BL PortQ_Output	
	MOV R0, #DIG0_PA	
	BL PortA_Output	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; Fun��o Digito_1
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_1
	PUSH{LR}
	MOV R0, #DIG1_PQ	
	BL PortQ_Output	
	MOV R0, #DIG1_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_2
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_2
	PUSH{LR}
	MOV R0, #DIG2_PQ	
	BL PortQ_Output	
	MOV R0, #DIG2_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_3
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_3
	PUSH{LR}
	MOV R0, #DIG3_PQ	
	BL PortQ_Output	
	MOV R0, #DIG3_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_4
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_4
	PUSH{LR}
	MOV R0, #DIG4_PQ	
	BL PortQ_Output	
	MOV R0, #DIG4_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_5
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_5
	PUSH{LR}
	MOV R0, #DIG5_PQ	
	BL PortQ_Output	
	MOV R0, #DIG5_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_6
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_6
	PUSH{LR}
	MOV R0, #DIG6_PQ	
	BL PortQ_Output	
	MOV R0, #DIG6_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_7
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_7
	PUSH{LR}
	MOV R0, #DIG7_PQ	
	BL PortQ_Output	
	MOV R0, #DIG7_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
	;--------------------------------------------------------------------------------
; Fun��o Digito_8
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_8
	PUSH{LR}
	MOV R0, #DIG8_PQ	
	BL PortQ_Output	
	MOV R0, #DIG8_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; Fun��o Digito_9
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Digito_9
	PUSH{LR}
	MOV R0, #DIG9_PQ	
	BL PortQ_Output	
	MOV R0, #DIG9_PA	
	BL PortA_Output	
	POP{LR}
	BX LR
	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo