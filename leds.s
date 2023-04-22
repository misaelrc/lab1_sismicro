; leds.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	

		EXPORT Led          	; Permite chamar Display_Dezena de outro arquivo
			
		; Se chamar alguma fun��o externa
		IMPORT  SysTick_Wait1ms			
        IMPORT  PortA_Output
		IMPORT  PortQ_Output

		IMPORT Turn0n_TransistorQ1
		IMPORT Turn0ff_TransistorQ1

; Fun��o Led
; Par�metro de entrada: R8 --> bits para ligar LEDs correspondentes
; Par�metro de sa�da: N�o tem
*********************************
Led
	PUSH {LR}
	BL Turn0n_TransistorQ1				;Chamar a fun��o para setar o transistor Q1
	
	MOV R0, R8

	BL BitsToLed						;Chamar a fun��o para pegar o valor dos bits de R0 e ligar os leds correspondentes
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	BL Turn0ff_TransistorQ1				;Chamar a fun��o para resetar o transistor Q1
	
	MOV R0, #1                			;Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms
	
	POP {LR}
	BX LR

;--------------------------------------------------------------------------------
; BitsToLed
; Par�metro de entrada: R0 --> bits para ligar LEDs correspondentes
; Par�metro de sa�da: N�o tem
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
	
	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo