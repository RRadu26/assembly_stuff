section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    push    ebp
    mov     ebp, esp
    pusha
    
    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    lu:
   		mov eax , 0
    	mov ebx , 0
			;; copiem charul din plaintext in eax
    	mov byte al, [esi]
			;; copiem charul din cheie in ebx , pornind de la final spre inceput(cheia trebuie inversata)
   			;; pentru a lua caracterele din key de la dreapta la stanga , se calculeaza adresa caracterlui
			;; dorit prin adunarea adresei key(edi) si length(ecx) si se scade 1 . Pentru ca se foloseste
			;; comanda loop , registrul ecx este decrementat cu fiecare executare a loop-ului , deci
			;; la fiecare repetare se va lua caracterul anterior din key
   		mov byte bl, [edi+ecx-1]
			;; se face operatie xor intre cele 2 charuri , se salveaza rezultatul in eax
    	xor al , bl
			;; se muta rezultatul din eax in ciphertext
    	mov byte [edx] , al
			;; se incrementeaza edx pentru a trece la urmatorul caracter din ciphertext
		inc edx
			;; se incrementeaza esi pentru a trece la urmatorul caracter din plaintext
    	inc esi
    loop lu    

    popa
    leave
    ret