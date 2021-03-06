;     By                                 
;                               Quirico Davis
;                                 Oct 1991
;
;                             FILENAME :  TRIS.ASM
;
TITLE     GAME_TRIS
;
Stackarea SEGMENT Stack 'stack'
	   DW     32   Dup(?)                  ; definizione area stack
Stackarea ENDS
;
Datarea  SEGMENT        'data'
   Giocatore_1   DB    1  Dup (0)
   Giocatore_2   DB    1  Dup (0)
   Intesta       DB  ' *  GIOCO  DEL  TRIS  *',13,10,'$'
   Player1       DB  ' Giocatore 1 :    X   ',13,10,'$'
   Player2       DB  ' Giocatore 2 :    O   ',13,10,'$'
   Game          DB  ' Vuoi Giocare di nuovo ? ',13,10,'$'
   Griglia       DB  '    ≥      ≥  ',13,10,'$'
   Griglia2      DB  'ƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒ',13,10,'$'
   Mess1         DB  'Non Fare il Furbo non tocca a te','$'
   Mess2         DB  '                                  ','$'
   Pres1         DB  'Davis Presenta il Gioco Del..','$'
Datarea ENDS
;
Codearea  SEGMENT   'code'
;
ASSUME    Ss:Stackarea,Ds:Datarea,Cs:Codearea,Es:Nothing
;
   Dos       Equ   21H
   Video     Equ   10H
   Left      Equ   4Bh
   Right     Equ   4DH
   Down      Equ   50H
   Up        Equ   48H
   X         Equ   58H
   O         Equ   4FH
   S         Equ   53H
   N         Equ   4EH
;
  MAIN :
;

	PUSH DS             ; Viene salvato il valore di DS nell'area di STACK
	SUB  AX,AX          ; Azzeramento dell'accumulatore
	PUSH AX             ; Viene salvato il valore di AX nell'area di STACK
	MOV  AX,Datarea     ; Viene assegnato l'indirizzo di partenza dell'area
			    ; dei dati
	MOV  DS,AX          ; Viene assegnato il valore di AX a DS
;
;
;
;

	Call PRESENTA

Start:  Mov Si,00
	Mov Ah,00
	Mov Al,03H
	Int Video
	Mov Ah,02
	Mov Dh,2
	Mov Dl,25
	Int Video
	Mov Dx,OffSet Intesta
	Mov Ah,09H
	Int Dos
	Mov Dx,OffSet Player1
	Mov Ah,09
	Int Dos
	Mov Dx,OffSet Player2
	Mov Ah,09
	Int Dos

	Call DISEGNA

	Call MOV_CURS

XX:     Mov Ah,02
	Mov Dh,20
	Mov Dl,25
	Int Video
	Mov Ah,09
	Mov Dx,Offset Game
	Int Dos
	Mov Ah,08
	Int Dos
	Cmp Al,S
	Jz  Start
	Cmp Al,N
	JNZ XX
	Mov Ah,4cH
	Int Dos
;
;
 Disegna  Proc  Near
;
	Mov Ah,02H
	Mov bh,00
	Mov DH,7
	Mov Dl,30
	Int Video
	Mov ah,9
	mov dx,offset griglia
	Int Dos
	Mov Ah,02
	mov bh,00
	Mov dh,8
	Mov dl,30
	Int Video
	Mov ah,9
	mov dx,offset griglia2
	int Dos
	Mov Ah,02H
	Mov bh,00
	Mov DH,9
	Mov Dl,30
	Int Video
	Mov ah,9
	mov dx,offset griglia
	Int Dos
	Mov Ah,02
	mov bh,00
	Mov dh,10
	Mov dl,30
	Int Video
	Mov ah,9
	mov dx,offset griglia2
	int Dos
	Mov Ah,02
	mov bh,00
	Mov dh,11
	Mov dl,30
	Int Video
	Mov ah,9
	mov dx,offset griglia
	Int Dos
	Ret
;
 Disegna Endp
;
;
 Mov_Curs  Proc  Near
;
	 Mov Di,00
	 Mov Dl,30
	 Mov Dh,7
 Repeat: Cmp Di,9
	 Jz Fine
	 Mov Ah,02H
	 Mov bh,00
	 Int Video
	 Mov AH,08H
	 Int Dos
	 Call Write_Char
	 Cmp Al,Left
	 Jnz @@1
	 Cmp Dl,30
	 JZ Repeat
	 Sub Dl,7
	 Jmp Repeat
  @@1 :  Cmp Al,Right
	 Jnz @@2
	 Cmp Dl,44
	 JZ Repeat
	 Add Dl,7
	 Jmp Repeat
  @@2 :  Cmp Al,Down
	 jnz @@3
	 Cmp Dh,11
	 Jz Repeat
	 Add Dh,2
	 Jmp Repeat
  @@3 :  Cmp Al,Up
	 Jnz Repeat
	 Cmp DH,7
	 Jz Repeat
	 Sub DH,2
	 Jmp Repeat
Fine:    Ret

  Mov_Curs Endp


 Write_Char Proc  Near

       Cmp Al,X
       Jnz J1
       SHR Si,1
       JNC J4
       Call Messaggi
       Dec Di
J4:    Mov Giocatore_1,DH
       Mov Ah,0EH
       Mov Bl,2
       Int Video
       Inc Di
       Inc Si
J1:    Cmp Al,O
       Jnz J2
       SHR Si,1
       JC J3
       Call Messaggi
       Dec Di
J3:    Mov Ah,0EH
       Mov Bl,2
       Int Video
       Inc Di
J2:    Ret

  Write_Char  Endp


;


Messaggi  Proc Near

       Push Dx
       Mov Ah,02
       Mov DH,22
       Mov Dl,2
       Int Video
       Mov Dx,OffSet Mess1
       Mov Ah,9
       Int Dos
       Mov Ah,02
       Mov Dh,22
       Mov Dl,2
       Int Video
       Mov Ah,0aH
       Int Dos
       Mov ah,09
       Mov Dx,OffSet Mess2
       Int Dos
       Pop Dx
      Ret

Messaggi Endp


Presenta  Proc Near

	Mov Ah,00
	Mov Al,12H
	Int Video
	Mov Ah,09
	Mov Dx,OffSet Pres1
	Int Dos
	Mov Ah,0aH
	Int Dos
	Mov Ah,00
	Mov Al,13H
	Int Video
	Mov Ah,02H
	Mov Dh,12
	Mov Dl,18
	Int Video
	Mov Ah,0EH
	Mov Bl,50
	Mov Al,54H ;  T
	Int Video
	Mov Ah,0EH
	Mov Bl,51
	Mov al,52H ;  R
	Int Video
	Mov Ah,0EH
	Mov Bl,52
	Mov Al,49H ;  I
	Int Video
	Mov Ah,0EH
	Mov Bl,53
	Mov al,S   ;  S
	Int Video
	Mov Ah,0aH
	Int Dos
	Ret

  Presenta Endp


Codearea ENDS

;
END MAIN  ; Fine Programma
