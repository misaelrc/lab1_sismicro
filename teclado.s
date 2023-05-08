; teclado.s

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines





; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
		IMPORT Teclado_ConfiguraLeituraPrimeiraColuna
		IMPORT Teclado_ConfiguraLeituraSegundaColuna
		IMPORT Teclado_ConfiguraLeituraTerceiraColuna
		IMPORT Teclado_ConfiguraLeituraQuartaColuna
			
		; Se alguma função do arquivo for chamada em outro arquivo	
		IMPORT PortL_Input
		IMPORT  SysTick_Wait1ms
		
		EXPORT Teclado_PegarTeclaPressionada
			

;--------------------------------------------------------------------------------
; Teclado_PegarTeclaPressionada
; Varre o teclado e pega a tecla pressionada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 (ASCII da tecla pressionada ou 0xFF)
Teclado_PegarTeclaPressionada
	PUSH{LR}
	
	BL	Teclado_LerPrimeiraColuna
	CMP R0, #0xFF
	BNE	Fim_Teclado_PegarTeclaPressionada		

	BL	Teclado_LerSegundaColuna
	CMP R0, #0xFF
	BNE	Fim_Teclado_PegarTeclaPressionada
	
	BL	Teclado_LerTerceiraColuna
	CMP R0, #0xFF
	BNE	Fim_Teclado_PegarTeclaPressionada
	
	BL	Teclado_LerQuartaColuna
	CMP R0, #0xFF
	BNE	Fim_Teclado_PegarTeclaPressionada
	
	MOV R0, #0xFF
Fim_Teclado_PegarTeclaPressionada
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; Teclado_LerPrimeiraColuna
; Varre a coluna 1 e pega a tecla pressionada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 (ASCII da tecla pressionada ou 0xFF)
Teclado_LerPrimeiraColuna
	PUSH{LR}
	BL Teclado_ConfiguraLeituraPrimeiraColuna
	BL PortL_Input
	
	; Linha 1
	MOV R1, R0
	AND R1, #2_0001
	CMP R1, #2_0000
	MOV R5, #1
	BEQ PrimeiraColunaTemTeclaPressionada
	
	; Linha 2
	MOV R1, R0
	AND R1, #2_0010
	CMP R1, #2_0000
	MOV R5, #4
	BEQ PrimeiraColunaTemTeclaPressionada
	
	; Linha 3
	MOV R1, R0
	AND R1, #2_0100
	CMP R1, #2_0000
	MOV R5, #7
	BEQ PrimeiraColunaTemTeclaPressionada
	
	; Linha 4
	MOV R1, R0
	AND R1, #2_1000
	CMP R1, #2_0000
	MOV R5, #14 ; asterisco
	BEQ PrimeiraColunaTemTeclaPressionada
	
	MOV	R0, #0xFF
	B Fim_Teclado_LerPrimeiraColuna
	
PrimeiraColunaTemTeclaPressionada
	;debounce
	MOV R0, #500
	BL SysTick_Wait1ms
	
	MOV	R0, R5
	
Fim_Teclado_LerPrimeiraColuna
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; Teclado_LerSegundaColuna
; Varre a coluna 2 e pega a tecla pressionada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 (ASCII da tecla pressionada ou 0xFF)
Teclado_LerSegundaColuna
	PUSH{LR}
	BL Teclado_ConfiguraLeituraSegundaColuna
	BL PortL_Input
	
	; Linha 1
	MOV R1, R0
	AND R1, #2_0001
	CMP R1, #2_0000
	MOV R5, #2
	BEQ SegundaColunaTemTeclaPressionada
	
	; Linha 2
	MOV R1, R0
	AND R1, #2_0010
	CMP R1, #2_0000
	MOV R5, #5
	BEQ SegundaColunaTemTeclaPressionada
	
	; Linha 3
	MOV R1, R0
	AND R1, #2_0100
	CMP R1, #2_0000
	MOV R5, #8
	BEQ SegundaColunaTemTeclaPressionada
	
	; Linha 4
	MOV R1, R0
	AND R1, #2_1000
	CMP R1, #2_0000
	MOV R5, #0
	BEQ SegundaColunaTemTeclaPressionada
	
	MOV	R0, #0xFF
	B Fim_Teclado_LerSegundaColuna
	
SegundaColunaTemTeclaPressionada
	;debounce
	MOV R0, #500
	BL SysTick_Wait1ms
	
	MOV	R0, R5
	
Fim_Teclado_LerSegundaColuna
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; Teclado_LerTerceiraColuna
; Varre a coluna 3 e pega a tecla pressionada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 (ASCII da tecla pressionada ou 0xFF)
Teclado_LerTerceiraColuna
	PUSH{LR}
	BL Teclado_ConfiguraLeituraTerceiraColuna
	BL PortL_Input
	
	; Linha 1
	MOV R1, R0
	AND R1, #2_0001
	CMP R1, #2_0000
	MOV R5, #3
	BEQ TerceiraColunaTemTeclaPressionada
	
	; Linha 2
	MOV R1, R0
	AND R1, #2_0010
	CMP R1, #2_0000
	MOV R5, #6
	BEQ TerceiraColunaTemTeclaPressionada
	
	; Linha 3
	MOV R1, R0
	AND R1, #2_0100
	CMP R1, #2_0000
	MOV R5, #9
	BEQ TerceiraColunaTemTeclaPressionada
	
	; Linha 4
	MOV R1, R0
	AND R1, #2_1000
	CMP R1, #2_0000
	MOV R5, #15 ; hashtag
	BEQ TerceiraColunaTemTeclaPressionada
	
	MOV	R0, #0xFF
	B Fim_Teclado_LerTerceiraColuna
	
TerceiraColunaTemTeclaPressionada
	;debounce
	MOV R0, #500
	BL SysTick_Wait1ms
	
	MOV	R0, R5
	
Fim_Teclado_LerTerceiraColuna
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; Teclado_LerQuartaColuna
; Varre a coluna 4 e pega a tecla pressionada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 (ASCII da tecla pressionada ou 0xFF)
Teclado_LerQuartaColuna
	PUSH{LR}
	BL Teclado_ConfiguraLeituraQuartaColuna
	BL PortL_Input
	
	; Linha 1
	MOV R1, R0
	AND R1, #2_0001
	CMP R1, #2_0000
	MOV R5, #10 ; A
	BEQ QuartaColunaTemTeclaPressionada
	
	; Linha 2
	MOV R1, R0
	AND R1, #2_0010
	CMP R1, #2_0000
	MOV R5, #11 ; B
	BEQ QuartaColunaTemTeclaPressionada
	
	; Linha 3
	MOV R1, R0
	AND R1, #2_0100
	CMP R1, #2_0000
	MOV R5, #12 ; C
	BEQ QuartaColunaTemTeclaPressionada
	
	; Linha 4
	MOV R1, R0
	AND R1, #2_1000
	CMP R1, #2_0000
	MOV R5, #13 ; D
	BEQ QuartaColunaTemTeclaPressionada
	
	MOV	R0, #0xFF
	B Fim_Teclado_LerQuartaColuna
	
QuartaColunaTemTeclaPressionada
	;debounce
	MOV R0, #500
	BL SysTick_Wait1ms
	
	MOV	R0, R5
	
Fim_Teclado_LerQuartaColuna
	POP{LR}
	BX LR
	
	
	ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo