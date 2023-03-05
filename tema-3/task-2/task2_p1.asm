section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
;; Progamul functioneaza prin iterarea prin toate numerele incepand cu 1 pana gaseste un numar
;; care se imparte la ambii parametrii
cmmmc:
	pop ecx ;memoram returnul in ebx
	pop edi ; memoram a in edi
	pop ebx ; memoram b in ebx
	push ebx
	push edi
	push ecx
	
	push edi ; punem b pe stiva
	push ebx ; punem a pe stiva
	
	push 0
	pop esi ; esi va fi multiplul ipotetic testat
	
	loop:
	;; se verifica daca s-a gasit un multiplu de-al lui a 
		mov edx , 0 
		inc esi
		push esi
		pop eax ; se pune in eax valoarea lui esi pentru impartire
		pop ebx ; ebx = a
		push ebx 
		div ebx 
;; daca restul impartirii este diferit de 0 esi-ul curent nu este multiplu si se trece la urmatorul numar
		cmp edx , 0 
			jne loop
	;; se verifica daca s-a gasit un multiplu de-al lui b
		mov edx , 0 
		pop eax ; eax = a
		pop ebx ; ebx = b
		push ebx
		push eax
		push esi
		pop eax
		div ebx
;; daca restul impartirii este diferit de 0 esi-ul curent nu este multiplu si se trece la urmatorul numar
		cmp edx , 0
			jne loop
	push esi
	pop eax
	pop ebx
	pop ebx
	;;se restaureaza stiva
	ret
