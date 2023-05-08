; lcd.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================

;Configs da PM
;RS(PM0) --> 0 = comando, 1 = dado
;RW(PM1) --> 0 = escrita, 1 = leitura
;EN(PM2) --> 0 = disable, 1 = enable


	
	AREA    DATA, READONLY
strAberto		DCB     "Cofre aberto,                           digite nova senha para fechar o cofre",0
strFechando  	DCB     "Cofre fechando..",0 ;"Cofre fechando                          "
strFechado  	DCB     "Cofre fechado",0
strAbrindo  	DCB     "Cofre abrindo...",0
strTravado  	DCB     "Cofre travado",0

		ALIGN

; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo
		EXPORT Lcd_Init
		EXPORT LcdComando
		EXPORT LcdMsgCofreAberto
		EXPORT LcdMsgCofreFechando
		EXPORT LcdMsgCofreFechado
		EXPORT LcdMsgCofreAbrindo
		EXPORT LcdMsgCofreTravado
			
		EXPORT LcdDeslocaEsquerda
			
		; Se chamar alguma função externa
		IMPORT  SysTick_Wait1us	
		IMPORT  SysTick_Wait1ms	
        IMPORT  PortK_Output
		IMPORT  PortM_Output

;--------------------------------------------------------------------------------
; Lcd_Init
; Configuração para usar o LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Lcd_Init
	PUSH{LR}
	
	; Configuração do LCD: 0x38 (tempo de delay: 40 µs)
	; 0x20 (Inicia configuração do LCD)
	; 0x10 (modo 8 bits)
	; 0x08 (2 linhas)
	MOV R3, #40 ; tempo de espera para o comando
	MOV R0, #0x38 ; comando
	BL LcdComando
	
	; Cursor com autoincremento para direita: 0x06 (tempo de delay: 40 µs)
	MOV R0, #0x06 ;comando
	BL LcdComando
	
	; Configuração do cursor: 0x0E (tempo de delay: 40 µs)
	; 0x08 (Inicia configuração do cursor)
	; 0x04 (habilita display)
	; 0x02 (habilita cursor)
	MOV R0, #0x0E ;comando
	BL LcdComando
	
	; Deslocamento mensagem para direita: 0x05 (tempo de delay: 40 µs)
	MOV R0, #0x05 ;comando
	BL LcdComando
	
	BL LcdReset
	
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; LcdReset
; Limpa o display e leva o cursor para o home
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
LcdReset
	PUSH{LR}
	
	;Resetar: Limpar o display e levar o cursor para o home (0x01) ? esperar 1,64ms
	MOV R3, #1640 ; tempo de espera para o comando
	MOV R0, #0x01 ; comando
	BL LcdComando
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdComando
; Envia comando para o LCD
; Parâmetro de entrada: R1 --> tempo de espera, R0 --> Comando
; Parâmetro de saída: Não tem
LcdComando
	PUSH{LR}
	BL PortK_Output
	
	; RS(M0) = 0 (comando), RW(M1) = 0(escrita), EN(M2) = 1 (habilitado)
	MOV R0, #2_100
	BL PortM_Output
	
	; espera 10 us com LCD habilitado
	MOV R0, #10
	BL SysTick_Wait1us
	
	;desabilita LCD
	MOV R0, #2_000
	BL PortM_Output
	
	; espera pelo tempo do parâmetro R1 com LCD desabilitado
	MOV R0, R3
	BL SysTick_Wait1us
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdEscreveCaractere
; Envia caractere para o LCD
; Parâmetro de entrada: R0 --> Caractere
; Parâmetro de saída: Não tem
LcdEscreveCaractere
	PUSH{LR}
	
	; escreve o caractere no barramento da porta K
	BL PortK_Output
	
	; RS(M0) = 1 (dado), RW(M1) = 0(escrita), EN(M2) = 1 (habilitado)
	MOV R0, #2_101
	BL PortM_Output
	
	; espera 10 us com LCD habilitado
	MOV R0, #10
	BL SysTick_Wait1us
	
	; desabilita LCD
	MOV R0, #2_000
	BL PortM_Output
	
	; espera 40 us com LCD desabilitado
	MOV R0, #40
	BL SysTick_Wait1us
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdEscreveString
; Envia caractere para o LCD
; Parâmetro de entrada: R4 --> String
; Parâmetro de saída: Não tem
LcdEscreveString
	PUSH{LR}
	
	; escreve o caractere no barramento da porta K
	BL LcdReset

LoopString
	; lê caractere e armazena em R0, e incrementa posição da string
	LDRB R0, [R4], #1
	
	CMP R0, #0				; verifica se é o fim da string
	BNE EscreveProximoCaractere
	BEQ FimLcdEscreveString
	
EscreveProximoCaractere
	BL LcdEscreveCaractere
	B LoopString
	
FimLcdEscreveString
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdDeslocaEsquerda
; Parâmetro de entrada: R3 --> String
; Parâmetro de saída: Não tem
*********************************
LcdDeslocaEsquerda
	PUSH{LR}
	;Deslocar mensagem para a esquerda: (0x18) ? esperar 40us
	MOV R3, #40 ; tempo de espera para o comando
	MOV R0, #0x18 ; comando
	BL LcdComando
	
	MOV R0, #1 ;com 150 trava a mensagem ao digitar no teclado
	BL 	SysTick_Wait1ms
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdMsgCofreAberto
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
LcdMsgCofreAberto
	PUSH{LR}
	
	BL LcdReset	
	LDR R4, =strAberto
	BL LcdEscreveString

	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdMsgCofreFechando
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
LcdMsgCofreFechando
	PUSH{LR}
	
	BL LcdReset
	
	;deslocamento do cursor ao entrar com caracter pra direita
	MOV R3, #40
	MOV R0, #0x06
	BL LcdComando
	
	;espera 3ms
	MOV R0, #1
	BL 	SysTick_Wait1ms
	
	LDR R4, =strFechando
	BL LcdEscreveString

	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdMsgCofreFechado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
LcdMsgCofreFechado
	PUSH{LR}
	
	BL LcdReset
	
	
	
	LDR R4, =strFechado
	BL LcdEscreveString

	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; LcdMsgCofreAbrindo
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
LcdMsgCofreAbrindo
	PUSH{LR}
	
	BL LcdReset	
	LDR R4, =strAbrindo
	BL LcdEscreveString

	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdMsgCofreTravado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
*********************************
LcdMsgCofreTravado
	PUSH{LR}
	
	BL LcdReset	
	LDR R4, =strTravado
	BL LcdEscreveString

	POP{LR}
	BX LR
	
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo


