section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition
;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY
    mov ecx , [len_cheie]
        ;; se itereaza prin fiecare coloana a matricii(pseudomatrice)
    lu:
    	mov edx , [edi]
            ;; se itereaza prin fiecare linie a matricii(pseudomatrice)
    	lo:
        	mov eax , 0
        	mov al , [esi+edx] 
        	mov byte [ebx] , al
        	inc ebx
        	add edx , [len_cheie]
        	cmp edx , [len_haystack]
    	jl lo
       ;; se trece la urmatoarea coloana 
        add edi , 4
    loop lu

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
    

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY