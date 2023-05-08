; ssd.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Portas usadas para cada transistor
TRANSISTOR_Q1	EQU	2_00100000

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Turn0n_TransistorQ1         			; Permite chamar Turn0n_TransistorQ1 de outro arquivo
		EXPORT Turn0ff_TransistorQ1					; Permite chamar Turn0ff_TransistorQ1 de outro arquivo
	
		; Se chamar alguma função externa	
		IMPORT  PortP_Output

; Função Turn0n_TransistorQ1
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
Turn0n_TransistorQ1
	PUSH {LR}
	MOV R0, #TRANSISTOR_Q1			; Setar o parâmetro de entrada da função setando o bit P5
	BL PortP_Output				; Chamar a função para setar a entrada do transistor Q1
	POP {LR}
	BX LR

; Função Turn0ff_TransistorQ1
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
Turn0ff_TransistorQ1
	PUSH {LR}
	MOV R0, #2_00000000			; Setar o parâmetro de entrada da função apagando o bit P5
	BL PortP_Output				; Chamar a função para resetar a entrada do transistor Q1
	POP {LR}
	BX LR
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo