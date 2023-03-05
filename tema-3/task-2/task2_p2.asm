section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression

;;Programul functioneaza in felul urmator: se itereaza prin tot sirul si se tine minte diferenta
;;dintre numarul parantezelor deschise si inchise.Daca aceasta diferenta va fi negativa, secventa
;;va fi gresita.In caz contrar se trece la urmatorul caracter din sir. Daca la final diferenta
;;este nenula secventa va fi gresita. In caz contrar aceasta va fi corecta
par:
	pop ecx ;return
	pop eax ;str
	pop ebx ; str_length
	
	push ebx
	push eax
	push ecx
	
	push 0
	pop ecx ;; in ecx va fi memorat un indice cu care se va itera prin str
	push 0
	pop edx ;; diferenta dintre nr. de paranteze deschise si inchise se tine in edx
	jmp loop
	
	deschisa:
		inc edx
		jmp loop_finish
	
	inchisa:
		dec edx
		cmp edx , 0 ;daca diferenta e negativa in timpul iterarii se returneaza 0
		jl return_0
		jmp loop_finish
	
	;loopul este pentru iterarea caracterelor din str
	loop:
		;se compara valoarea de la ebx(caracterul curent) cu valorile din ascii ale parantezelor
		;se face un salt, dupa caz
 		cmp byte [ebx] , 40
		je deschisa 
		cmp byte [ebx] , 41
		je inchisa
		
		loop_finish:
		inc ebx ;ebx-ul se incrementeaza, acesta va memora adresa urmatorului caracter
		inc ecx ;se incrementeaza indicele
		cmp ecx , eax
		jl loop
		
	cmp edx , 0
	je return_1 ;;daca diferenta este 0 , secventa e corecta
	
	;pune in eax(return) 0
	return_0:
		push 0
		pop eax
		jmp finish
		
	;pune in eax(return) 1	
	return_1:
		push 1
		pop eax
	finish:
	
	ret
