global get_words
global compare_func
global sort

extern strpbrk
extern strcpy
extern strncpy
extern strlen
extern strcmp
extern qsort
extern printf

section .data
delimitator db " ,." , 10 ,0
arg db " %d " , 0
section .text

;; compare(char *s1,char *s2)
;  returneaza strlen(s1)-strlen(s2) , daca sunt egale returneaza strcmp(s1,s2)

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
        enter 0, 0
        leave
        ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
	mov eax , 0
	mov ebx , [ebp+8] ; ebx= char *s
	mov edx , [ebp+12] ;edx=words
    
    ;iterez pana cand toate cuvintele din sir sunt despartite in cuvinte
    loop:
        mov eax , delimitator
    
    ;se pune in edx adresa cuvantului din words
        mov dword edx , [edx]
        push eax
        push ebx
        call strpbrk
    ;functia strpbrk va cauta un sir sau orice char din sir dintr-un sir sursa si va returna
    ;un pointer la caracterul cautat.Aici este folosit pentru a cauta un caracter de tip delimitator
    ;in sirul sursa
        pop ebx
        add esp , 4
        
    ;se restaureaza registrele cu valorile anterioare, cu exceptia lui ecx

    ;se calculeaza lungimea cuvantului curent
        sub eax , ebx
    ;se copiaza cuvantul curent din stringul sursa in words[i] cu functia strncpy
        push eax
        push ebx
        push edx
        call strncpy
        add esp , 12
    ;se muta ebx pe caracterul de dupa delimitator din sirul sursa, se va lucra cu acesta ca fiind
    ;noul sir sursa

    ;se trece la urmatorul cuvant din words ; echivalent cu edx=words[i]

    ;cmp esi , [ebp+16]
    ;jl loop
    ;se contunua iteratia pana se ajunge la penultimul cuvant , esi incepand de la 1.Deoarece
    ;ultimul caracter al sirului sursa este \0 acesta nu poate fi adaugat in sirul delimitator
    ;iar apelarea strpbrk va returna null , deci nu se va putea calcula lungimea ultimului cuvant
    ;asa , se copiaza in words[size-1] cu strcpy

    
    leave
    ret
