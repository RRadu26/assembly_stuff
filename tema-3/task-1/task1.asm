section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	mov esi , [ebp+8]
	mov ebx , [ebp+12]
	
	mov ecx , 0
	first_node:
		cmp dword [ebx] , 1
		je found_first
		add ebx , 8
		inc ecx
		cmp ecx , esi
		jl first_node
	
	found_first:
	mov eax , ebx
	
	mov edx , 1
	mov edi , 2
	
	all_nodes:
		mov ecx , 0
		mov ebx , [ebp+12]
		current_node:
			cmp [ebx] , edi
			je found_current
			add ebx , 8
			inc ecx
			cmp ecx , esi
			jl current_node
			
		found_current:
			mov [eax+4] , ebx
			inc edi
			mov eax , ebx
		inc edx
		cmp edx , esi
		jl all_nodes
		
	mov ebx , [ebp+12]
	mov ecx , 0
	first_node2:
		cmp dword [ebx] , 1
		je found_first2
		add ebx , 8
		inc ecx
		cmp ecx , esi
		jl first_node2
	
	found_first2:
	mov eax , ebx
	leave
	ret
