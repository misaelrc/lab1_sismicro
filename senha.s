; senha.s

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Estados
ABERTO			EQU 0x1
FECHANDO		EQU 0x2
FECHADO			EQU 0x3
ABRINDO			EQU 0x4
TRAVADO			EQU 0x5
	
END_SENHA		EQU	0x20000000
SENHA_MESTRA	EQU 0x2309
	
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
        EXPORT SetaSenha
		EXPORT ComparaSenha
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PortM_Output
		IMPORT  PortK_Output
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us
        IMPORT  Teclado_PegarTeclaPressionada
;-------------------------------------------------------------------------------		
;SetaSenha
SetaSenha
	PUSH{LR}
	
	BL Teclado_PegarTeclaPressionada
	CMP R0, #0xFF
	BEQ Fim_SetaSenha
	
	MOV R4, R0					;guarda a tecla pressionada em R4
	
	CMP R10, #4
	;se tiver 4 comparar com hashtag
	BLGE VerificaHashtag_SetaSenha
	CMP R1, #1 ; se volta 1, era hashtag
	BEQ Fim_SetaSenha
	
	LSL R9, R9, #4
	ORR R9, R4
	MOV R3, #0x0000FFFF ; para eliminar se passar de 4
	AND R9, R3
	
	ADD R10, #1
	
Fim_SetaSenha
	POP {LR}
	BX LR
	
;-------------------------------------------------------------------------------
;VerificaHashtag	
VerificaHashtag_SetaSenha
	PUSH{LR}
	CMP R0, #15
	BNE NaoHashtag_SetaSenha
	
	;salvar senha na ram
	
	MOV R3, #END_SENHA
	STR R9, [R3]
	
	;zerar senha tempor�ria e contador
	MOV R10, #0
	MOV R9, #0
	
	;esperar 1s
	MOV R0, #1000
	BL SysTick_Wait1ms
	
	MOV R12, #FECHANDO
	MOV R1, #1
	B Fim_VerificaHashtag_SetaSenha
	
NaoHashtag_SetaSenha
	; se n�o � hashtag, coloca esse contador pra 3, e a tecla atual ser� considerada a 4
	MOV R10, #3
Fim_VerificaHashtag_SetaSenha
	POP{LR}
	BX LR
	
;-------------------------------------------------------------------------------
;ComparaSenha	
ComparaSenha
	PUSH{LR}
	
	BL Teclado_PegarTeclaPressionada
	CMP R0, #0xFF
	BEQ Fim_ComparaSenha
	
	MOV R4, R0					;guarda a tecla pressionada em R4
	
	CMP R10, #4
	;se tiver 4 comparar com hashtag
	BLGE VerificaHashtag_ComparaSenha
	CMP R1, #1 ; se volta 1, era hashtag
	BEQ Fim_ComparaSenha
	
	LSL R9, R9, #4
	ORR R9, R4
	MOV R3, #0x0000FFFF ; para eliminar se passar de 4
	AND R9, R3
	
	ADD R10, #1
	
Fim_ComparaSenha
	POP {LR}
	BX LR

;-------------------------------------------------------------------------------
;VerificaHashtag	
VerificaHashtag_ComparaSenha
	PUSH{LR}
	CMP R0, #15
	BNE NaoHashtag_ComparaSenha
	
	CMP R12, #TRAVADO
	BEQ esta_travado
	
	; se n�o t� em destravamento, pega senha da ram
	MOV R3, #END_SENHA
	LDR R4, [R3]
	CMP R4, R9
	ITE EQ
	MOVEQ R12, #ABRINDO
	ADDNE R7, R7, #1
	B comum
	
esta_travado
	MOV R4, #SENHA_MESTRA
	CMP R4, R9
	ITT EQ
	MOVEQ R12, #ABRINDO
	MOVEQ R7, #0
	
comum
	;zerar senha tempor�ria e contador
	MOV R10, #0
	MOV R9, #0
	
	MOV R1, #1
	B Fim_VerificaHashtag_ComparaSenha
	
NaoHashtag_ComparaSenha
	; se n�o � hashtag, coloca esse contador pra 3, e a tecla atual ser� considerada a 4
	MOV R10, #3
Fim_VerificaHashtag_ComparaSenha
	POP{LR}
	BX LR

	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo