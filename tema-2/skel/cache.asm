CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .data
	i dw 0
	offset dd 0
	tag dd 0
	l dd 0
	intermediar dd 0
section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)

		;;Se calculeaza tagul prin shiftarea adresei la dreapta cu OFFSET_BITS biti , rezultatul
		;;se salveaza in variabila globala tag
	mov dword [tag] , 0
	mov esi , edx
	shr esi , OFFSET_BITS
	mov [tag] , esi
	
		;;Se calculeaza offsetul prin scaderea din adresa a tagului shiftat la stanga cu OFFSET_BITS biti
		;;si se salveaza rezultatul in variabila gloala offset . Pentru ca am shiftat tagul la
		;;stanga , acesta este in final shiftat inapoi la dreapta
	mov esi , edx
	shl dword [tag] , OFFSET_BITS
	sub esi , [tag]
	mov [offset] , esi
	mov dword esi , [offset]
		;;Edx va fi primul element ce trebuie adaugat in cache in cazul unui CACHE MISS
	sub edx , esi	
	shr dword [tag] , OFFSET_BITS
		;;Se verifica daca adresa cautata este deja in cache prin iterarea prin vectorul de taguri .
		;;Daca are loc un CACHE HIT se sare la tag_gasit , nu se mai aduce memoria din ram in cache
		;;registrul edi va fi folosit ca linia din cache la care se afla rezultatul pentru a calcula
		;;charul din cache care se va pune in registu, nemaicontand linia to_replace
	
		;;Folosim esi in loc de eax ca address of reg pentru a putea lucra cu subregistrele acestuia
	mov esi , eax 
	mov dword [l] , 0
	mov [intermediar] , ecx
	mov ecx , [tag]
	lt:
		mov eax , [l]
		cmp ecx , [ebx+eax*8]
			je tag_gasit
		inc eax
		mov [l] , eax

		cmp eax , 100
		jl lt
		;;Daca nu s-a gasit tagul in tags acesta este adaugat la linia to_replace din tags
	mov [ebx+8*edi] , ecx
	
		;;Se adauga cele 8 elemente din ram in cache 
	mov ecx , [intermediar]
	mov word [i] , 0
	mov eax , 0 
		
    lo:
		mov dword eax , 0
		mov byte al , [edx]
		inc edx
        mov byte [ecx+edi*8] , al
		mov eax , 0
        mov ax ,[i]
		add ecx , 1
		add ax , 1
		mov [i] , ax
        cmp eax , 8
        jl lo
		sub ecx , 8
		jmp ad
		
	tag_gasit:
		mov ecx , [intermediar]
		mov eax , [l]
		mov edi , eax
		;;Se adauga elementul din cache in registru
	ad:
	add ecx , [offset]
	mov eax , 0
	mov al , [ecx+edi*8]
	mov byte [esi] , al

    popa
    leave
    ret


