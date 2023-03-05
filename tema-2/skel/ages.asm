struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages
    
; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
        ;; ebx este indicele i din dates[i]
  	mov ebx , 0
    lo:
        ;; se calculeaza varsta scazand din prezent.year dates[ebx].year
    	mov eax , 0
    	mov ax , [esi+4]
    	sub ax , [edi+4+ebx*8]
    	mov [ecx+4*ebx] , eax 
        ;; se verifica daca data de nastere este dupa prezent 
        ;; se compara anii , daca anul prezent este dupa anul dates[ebx] inseamna ca data de
        ;; nastere este ok si se sare la pasul urmator . Daca este mai mic se trece la nok_dn  
        ;; care va pune 0 in all_ages[ebx] , cum se cere in enunt . In caz ca anii sunt egali
        ;; se compara lunile pe acelasi principiu , daca nu zilele . 
    	mov eax , 0
    	mov ax , [esi+4]
    	cmp ax , [edi+4+ebx*8]
    		jg ok_dn
    		jl nok_dn
    	mov eax , 0
    	mov ax , [esi+2]
    	cmp ax , [edi+2+ebx*8] 
    		jg ok_dn
    		jl nok_dn
    	mov eax , 0
    	mov ax , [esi]
    	cmp ax , [edi+ebx*8] 
    		jg ok_dn
    		jl nok_dn
    ;; Se verifica daca a trecut sau nu ziua de nastere din anul prezent , comparandu-se lunile si
    ;; zilele . In cazul in care ziua de nastere a trecut , se sare decrementarea varstei de la
    ;; dec_dn
    	ok_dn:
    ;; if uri
    		mov eax , 0
    		mov ax , [esi+2]
    		cmp ax , [edi+2+ebx*8]
    			jg sk
    			jne dec_dn
    	mov eax , 0
   		mov ax , [esi]
    	cmp ax , [edi+ebx*8]
    		jge sk
		dec_dn:
    ;; In cazul in care ziua de nastere urmeaza sa vina anul prezent , se decrementeaza varsta cu 1
    		dec dword [ecx+4*ebx]
    	sk:
    		jmp skip
    	nok_dn:
    		mov word [ecx+4*ebx] , 0 
    	skip:
    ;; Se incrementeaza ebx pentru a trece la urmatoarea data de nastere si apoi se compara cu len pentru
    ;; a itera toate datele de nastere si a calcula toare varstele din dates
    		inc ebx
    		cmp ebx , edx
    		jl lo

    popa
    leave
    ret
