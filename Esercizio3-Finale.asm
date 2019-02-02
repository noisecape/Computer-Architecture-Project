# AUTORI: 
# Federico Moncini, 5936828, federico.moncini@stud.unifi.it 
# Lorenzo Mungai, 5962693, lorenzo.mungai@stud.unifi.it 
# Tommaso Capecchi, 5943118, tommaso.capecchi@stud.uni.it 
# 
# ---------DATA DI CONSEGNA---------

.data
     message1: .asciiz "Insert a number between 1 and 4 \n"
     message2: .asciiz "a) Inserting matrix \n"
     message3: .asciiz "b) Add A + B \n"
     message4: .asciiz "c) Subtraction A-B \n"
     message5: .asciiz "d) Product A*B \n"
     message6: .asciiz "e) Exit \n"
     message7: .asciiz "Insert matrix A \n"
	 message8: .asciiz "Insert matrix B \n"
     message9: .asciiz "Insert number into matrix \n"
	 newLine:  .asciiz "\n"
	 
	 val: .space 4
	 endl:	.asciiz	"\n"
     tab:	.asciiz	"\t"
.text
.globl main

main:

menu:
     
     la $a0, message2           #carica in a0 l'indirizzo del message2
     li $v0, 4                  #carica in v0 la procedura per stampare la stringa
     syscall
     
     la $a0, message3           #carica in a0 l'indirizzo del message3
     syscall
     
     la $a0, message4           #carica in a0 l'indirizzo del message4
     syscall
     
     la $a0, message5           #carica in a0 l'indirizzo del message5
     syscall
     
     la $a0, message6           #carica in a0 l'indirizzo del message6
     syscall
     
     li $v0, 12	                #carica in v0 la procedura per leggere un carattere
	 la $a0, val
	 li $a1, 4
     syscall                    #chiamata a sistema
     
     move $t1, $v0              #salvo in t1 il carattere scelto dall'utente
	 la $a0, newLine            #carica in a0 l'indirizzo del newLine
     li $v0, 4                  #carica in v0 la procedura per stampare la stringa
     syscall
     
     #FARE UN CONTROLLO SUI CARATTERI INSERITI  
    li $t2, 'a' 
    beq $t1, $t2, caseA
	li $t2, 'b'
    beq $t1, $t2, caseB	
	li $t2, 'c'
    beq $t1, $t2, caseC
	li $t2, 'd'
	beq $t1, $t2, caseD
    li $t2, 'e' 
    beq $t1, $t2, caseE
	j menu
      
caseA:
    jal input
	move $s0,$v0
    add $a0, $zero, $s0	       #come primo argomento = nuovo n
	add $a1, $zero, $s3        #secondo argomento = vecchio n
	add $a2, $zero, $s1        #terzo argomento = indirizzo matrice A
	add $a3, $zero, $s2        #quarto argomento = indirizzo matrice B
    jal inserimenti
    add $s1, $zero, $v0        #carico i nuovi indirizzi di A e B
    add $s2, $zero, $v1	
	add $s3, $zero, $s0        # sposti s0 in s3
    j menu
	
caseB:
    li $t0, 'b'
    add $a0, $zero, $t0
    jal controllo_operazione	
	j menu
	
caseC:
    li $t0, 'c'
    add $a0, $zero, $t0
    jal controllo_operazione	
	j menu

caseD:
    jal prodotto
    j menu	
     
caseE:
    j exit
	
	
input: 
     la $a0, message1           #carica in a0 l'indirizzo del message1
     li $v0, 4                  #carica in v0 la procedura per stampare la stringa
     syscall
     
     li $v0, 5                  #carica in v0 la procedura per leggere un intero in input
	 syscall                    #effettua la chiamata di sistema per leggere l'intero in input
     
     add $t0, $zero, $v0        #t0 = v0+0
	 li $t1, 1                  #carica in t1 il valore 1, lower number
	 slt $t2, $t0, $t1          #t2 = 1 se t0 < t1, altrimenti t2 = 0   
	 li $t3, 1                  #carica in t3 il valore 1
	 beq $t2, $t3, input        #if t2 == t3 then goto input   
	 li $t1, 4                  #carica in $t1 il valore 5
	 sgt $t2, $t0, $t1          #$t2 = 1 if t0>5, altrimenti t2=0               
	 beq $t2, $t3, input        #if t2=1 richiama input
     
     move $v0, $t0              #salvo in s0 la n(inserita precedentemente in t0)	
	 jr $ra
	
inserimenti:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
	sw $s3, 8($sp)
    add $t0, $zero, $a0        # nuovo n in $a0
    add $t1, $zero, $a1        # vecchio n in $a1
	la $a0, message7           #carica in a0 l'indirizzo del message7
    li $v0, 4                  #carica in v0 la procedura per stampare la stringa
    syscall
	beq $t0, $t1, changeValues
	
	mul $a0, $t0, $t0          #calcolo n*n e lo metto in a0
    sll $a0, $a0, 2            #per ragioni di economia, faccio 2^2
    li $v0,9                   #chiama procedura per sbrk
    syscall
    move $a0, $v0              #save array address in $a0
	add $a2, $zero, $t0        #in a2 c'e' il nuovo n
	add $s1, $zero, $a0        #salvo in $s1 l'indirizzo di A
	jal createMatrix
	
	la $a0, message8           #carica in a0 l'indirizzo del message8
    li $v0, 4                  #carica in v0 la procedura per stampare la stringa
    syscall
	
	mul $a0, $t0, $t0          #calcolo n*n e lo metto in a0
    sll $a0, $a0, 2            #per ragioni di economia, faccio 2^2
    li $v0,9                   #chiama procedura per sbrk
    syscall
    move $a0, $v0              #save array address in $a0
	add $a2, $zero, $t0
	add $s2, $zero, $a0        #salvo in $s2 l'indirizzo di B
	jal createMatrix
	j exitFunction
			
changeValues:
	add $a0, $zero, $a2       #in a0 c'e' indirizzo di A
	add $a2, $zero, $t0       #in a2 c'e' il nuovo n
	add $s1, $zero, $a0        #salvo in $s1 l'indirizzo di A
	jal createMatrix
	la $a0, message8           #carica in a0 l'indirizzo del message8
    li $v0, 4                  #carica in v0 la procedura per stampare la stringa
    syscall
	add $a0, $zero, $a3       #in a0 c'e' indirizzo di B
	add $a2, $zero, $t0       #in a2 c'e' il nuovo n
	add $s2, $zero, $a0        #salvo in $s2 l'indirizzo di B
	jal createMatrix
	 
	
exitFunction:
    add $v0, $zero, $s1
	add $v1, $zero, $s2
    lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s3, 8($sp)
	addi $sp, $sp, 12
	jr $ra
    	

createMatrix:
    add $t7,$zero,$a0
read_Row:
    addi $t3, $zero, 0             #indice i del primo for
outer_loop:                             
    slt $t6, $t3, $a2
	beq $t6, 0, read_outer_loop_end
    addi $t4, $zero, 0             #indice j del secondo for
inner_loop:
    slt $t6, $t4, $a2
	beq $t6, 0, read_inner_loop_end
        
    mul $t5, $t3, $a2              #t5 = n*i
    add $t5, $t5, $t4              #t5 = (n*i)+j
    sll $t5, $t5, 2                #t5 = 2^2*(n*i+j)
    add $t5, $t7, $t5              #t5 = baseAddress + (2^2*(n*i+j))
        
    li $v0, 4                      #carico la procedura per stampare una stringa
    la $a0, message9               
    syscall
        
    li $v0, 5                      #carico la procedura per leggere un intero
    syscall
        
    sw $v0, 0($t5)                 #mette il numero preso in input nell'array
    addiu $t4, $t4, 1              #incremento la j
    j inner_loop
        
read_inner_loop_end:
    addiu $t3, $t3, 1   #incremento la i
    j outer_loop        

read_outer_loop_end:
    jr $ra	
	
	
controllo_operazione:
    add $t8, $zero,$a0
readRow:
    addi $t3, $zero, 0             #indice i del primo for
outerLoop:                             
    slt $t6, $t3, $s3
	beq $t6, 0, readOuterLoopEnd
    addi $t4, $zero, 0             #indice j del secondo for
innerLoop:
    slt $t6, $t4, $s3
	beq $t6, 0, readInnerLoopEnd
        
    mul $t5, $t3, $s3              #t5 = j*n
    add $t5, $t5, $t4              #t5 = (j*n)+i
    sll $t7, $t5, 2                #t5 = 2^2*(n*j+i)
    add $t5, $s1, $t7              #t5 = baseAddressA + (2^2*(n*i+j))
	add $t6, $s2, $t7
        
    lw $t0, 0($t5)                 #prendo il valore dell'indice calcolato di A
	lw $t1, 0($t6)                 #prendo il valore dell'indice calcolato di B
	li $t2, 'b'
	beq $t8, $t2, somma
  	subu $a0, $t0, $t1
	j procedi
somma:
	add $a0, $t0, $t1
procedi:	
	li $v0, 1
	syscall
	
	li	$v0, 4
	la	$a0, tab				   # printf("\t")
	syscall
	
    addiu $t4, $t4, 1              #incremento la j
    j innerLoop
        
readInnerLoopEnd:
    li	$v0, 4
	la	$a0, endl
	syscall
    addiu $t3, $t3, 1              #incremento la i
    j outerLoop        

readOuterLoopEnd:
    jr $ra		

	
prodotto:

    addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t8, $zero, $zero
readRow1:
    addi $t3, $zero, 0             #indice i del primo for
outerLoop1:                             
    slt $t6, $t3, $s3
	beq $t6, 0, readOuterLoopEnd1
    addi $t4, $zero, 0             #indice j del secondo for
innerLoop1:
    slt $t6, $t4, $s3
	beq $t6, 0, readInnerLoopEnd1

    addi $t1, $zero, 0	          #indice k del terzo for
innerLoopRigaColonna:
    slt $t6, $t1, $s3
	beq $t6, 0, innerLoopRigaColonnaEnd
	add $a0, $zero, $t3
	add $a1, $zero, $t4
	add $a2, $zero, $t1
	
	jal prodottoSemplice
	add $t8, $t8, $v0
    addiu $t1,$t1, 1
    j innerLoopRigaColonna
	
innerLoopRigaColonnaEnd:
    li $v0, 1
    add $a0, $zero, $t8
    syscall
	
	add $t8, $zero, $zero
	
	li $v0, 4
	la $a0, tab
	syscall
   	
    addiu $t4, $t4, 1              #incremento la j
    j innerLoop1
        
readInnerLoopEnd1:
    li	$v0, 4
	la	$a0, endl
	syscall
    addiu $t3, $t3, 1              #incremento la i
    j outerLoop1       

readOuterLoopEnd1:
    lw $ra, 0($sp)
	addi $sp, $sp, 4
    jr $ra			
	
prodottoSemplice:
    add $sp, $sp, -16
	sw $t3, 0($sp)
	sw $t4, 4($sp)
	sw $t1, 8($sp)
	sw $t8, 12($sp)
    
    mul $t5, $a0, $s3              #t5 = i*n
    add $t5, $t5, $a2              #t5 = (i*n)+k
    sll $t7, $t5, 2                #t7 = 2^2*(n*i+k)
    add $t5, $s1, $t7              #t5 = baseAddressA + (2^2*(n*i+k))	
    
    mul $t6, $a2, $s3              #t6 = k*n
    add $t6, $t6, $a1              #t6 = (k*n)+j
    sll $t7, $t6, 2                #t7 = 2^2*(k*n+j)
    add $t6, $s2, $t7              #t6 = baseAddressB + (2^2*(n*i+j)) 
    
	lw $t5, 0($t5)
	lw $t6, 0($t6)
    mul $v0, $t5, $t6
	lw $t3, 0($sp)
	lw $t4, 4($sp)
	lw $t1, 8($sp) 
	lw $t8, 12($sp)
	addi $sp, $sp, 16
	jr $ra
exit:
     li $v0, 10
	 syscall		