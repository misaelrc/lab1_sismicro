; lcd.s
; Desenvolvido para a placa EK-TM4C1294XL


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
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

; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo
		EXPORT Lcd_Init
		EXPORT LcdComando
		EXPORT LcdMsgCofreAberto
		EXPORT LcdMsgCofreFechando
		EXPORT LcdMsgCofreFechado
		EXPORT LcdMsgCofreAbrindo
		EXPORT LcdMsgCofreTravado
			
		EXPORT LcdDeslocaEsquerda
			
		; Se chamar alguma fun��o externa
		IMPORT  SysTick_Wait1us	
		IMPORT  SysTick_Wait1ms	
        IMPORT  PortK_Output
		IMPORT  PortM_Output

;--------------------------------------------------------------------------------
; Lcd_Init
; Configura��o para usar o LCD
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
Lcd_Init
	PUSH{LR}
	
	; Configura��o do LCD: 0x38 (tempo de delay: 40 �s)
	; 0x20 (Inicia configura��o do LCD)
	; 0x10 (modo 8 bits)
	; 0x08 (2 linhas)
	MOV R3, #40 ; tempo de espera para o comando
	MOV R0, #0x38 ; comando
	BL LcdComando
	
	; Cursor com autoincremento para direita: 0x06 (tempo de delay: 40 �s)
	MOV R0, #0x06 ;comando
	BL LcdComando
	
	; Configura��o do cursor: 0x0E (tempo de delay: 40 �s)
	; 0x08 (Inicia configura��o do cursor)
	; 0x04 (habilita display)
	; 0x02 (habilita cursor)
	MOV R0, #0x0E ;comando
	BL LcdComando
	
	; Deslocamento mensagem para direita: 0x05 (tempo de delay: 40 �s)
	MOV R0, #0x05 ;comando
	BL LcdComando
	
	BL LcdReset
	
	POP{LR}
	BX LR
	
;--------------------------------------------------------------------------------
; LcdReset
; Limpa o display e leva o cursor para o home
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: R1 --> tempo de espera, R0 --> Comando
; Par�metro de sa�da: N�o tem
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
	
	; espera pelo tempo do par�metro R1 com LCD desabilitado
	MOV R0, R3
	BL SysTick_Wait1us
	
	POP{LR}
	BX LR

;--------------------------------------------------------------------------------
; LcdEscreveCaractere
; Envia caractere para o LCD
; Par�metro de entrada: R0 --> Caractere
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: R4 --> String
; Par�metro de sa�da: N�o tem
LcdEscreveString
	PUSH{LR}
	
	; escreve o caractere no barramento da porta K
	BL LcdReset

LoopString
	; l� caractere e armazena em R0, e incrementa posi��o da string
	LDRB R0, [R4], #1
	
	CMP R0, #0				; verifica se � o fim da string
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
; Par�metro de entrada: R3 --> String
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
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
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
*********************************
LcdMsgCofreTravado
	PUSH{LR}
	
	BL LcdReset	
	LDR R4, =strTravado
	BL LcdEscreveString

	POP{LR}
	BX LR
	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo


