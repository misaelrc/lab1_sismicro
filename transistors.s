; ssd.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; ========================

; Portas usadas para cada d�gito
TRANSISTOR_Q1	EQU	2_00100000
TRANSISTOR_Q2	EQU	2_00010000
TRANSISTOR_Q3	EQU	2_00100000



; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Turn0n_TransistorQ1         			; Permite chamar Turn0n_TransistorQ1 de outro arquivo
		EXPORT Turn0ff_TransistorQ1					; Permite chamar Turn0ff_TransistorQ1 de outro arquivo
		EXPORT Turn0n_TransistorQ2					; Permite chamar Turn0n_TransistorQ2 de outro arquivo
		EXPORT Turn0ff_TransistorQ2					; Permite chamar Turn0ff_TransistorQ2 de outro arquivo
		EXPORT Turn0n_TransistorQ3					; Permite chamar Turn0n_TransistorQ3 de outro arquivo
		EXPORT Turn0ff_TransistorQ3          		; Permite chamar Turn0ff_TransistorQ3 de outro arquivo
	
		; Se chamar alguma fun��o externa	
		IMPORT  PortB_Output
		IMPORT  PortP_Output

; Fun��o Turn0n_TransistorQ1
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0n_TransistorQ1
	PUSH {LR}
	MOV R0, #TRANSISTOR_Q1			; Setar o par�metro de entrada da fun��o setando o bit P5
	BL PortP_Output				; Chamar a fun��o para setar a entrada do transistor Q1
	POP {LR}
	BX LR

; Fun��o Turn0n_TransistorQ2
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0n_TransistorQ2
	PUSH {LR}
	MOV R0, #TRANSISTOR_Q2			; Setar o par�metro de entrada da fun��o setando o bit B4
	BL PortB_Output				; Chamar a fun��o para setar a entrada do transistor Q2
	POP {LR}
	BX LR

; Fun��o Turn0n_TransistorQ3
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0n_TransistorQ3
	PUSH {LR}
	MOV R0, #TRANSISTOR_Q3			; Setar o par�metro de entrada da fun��o setando o bit B5
	BL PortB_Output				; Chamar a fun��o para setar a entrada do transistor Q3
	POP {LR}
	BX LR

; Fun��o Turn0ff_TransistorQ1
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0ff_TransistorQ1
	PUSH {LR}
	MOV R0, #2_00000000			; Setar o par�metro de entrada da fun��o apagando o bit P5
	BL PortP_Output				; Chamar a fun��o para resetar a entrada do transistor Q1
	POP {LR}
	BX LR
	
; Fun��o Turn0ff_TransistorQ2
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0ff_TransistorQ2
	PUSH {LR}
	MOV R0, #2_00000000			; Setar o par�metro de entrada da fun��o apagando o bit B4
	BL PortB_Output				; Chamar a fun��o para resetar a entrada do transistor Q2
	POP {LR}
	BX LR

; Fun��o Turn0ff_TransistorQ3
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
Turn0ff_TransistorQ3
	PUSH {LR}
	MOV R0, #2_00000000			; Setar o par�metro de entrada da fun��o apagando o bit B5
	BL PortB_Output				; Chamar a fun��o para resetar a entrada do transistor Q3
	POP {LR}
	BX LR

	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo