; leds.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	

		EXPORT Led          	; Permite chamar Display_Dezena de outro arquivo
			
		; Se chamar alguma função externa
		IMPORT  SysTick_Wait1ms			
        IMPORT  PortA_Output
		IMPORT  PortQ_Output

		IMPORT Turn0n_TransistorQ1
		IMPORT Turn0ff_TransistorQ1

; Função Led
; Parâmetro de entrada: R8 --> bits para ligar LEDs correspondentes
; Parâmetro de saída: Não tem
*********************************
Led
	PUSH {LR}
	BL Turn0n_TransistorQ1				;Chamar a função para setar o transistor Q1
	
	MOV R0, R8

	BL BitsToLed						;Chamar a função para pegar o valor dos bits de R0 e ligar os leds correspondentes
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	BL Turn0ff_TransistorQ1				;Chamar a função para resetar o transistor Q1
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	POP {LR}
	BX LR

;--------------------------------------------------------------------------------
; BitsToLed
; Parâmetro de entrada: R0 --> bits para ligar LEDs correspondentes
; Parâmetro de saída: Não tem
*********************************
BitsToLed
	PUSH{LR}
	MOV R4, R0
	
	AND R0, R4, #2_11110000
	BL PortA_Output
	
	AND R0, R4, #2_00001111
	BL PortQ_Output
	POP{LR}
	BX LR
	
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo