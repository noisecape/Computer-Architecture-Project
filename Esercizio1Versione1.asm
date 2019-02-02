# AUTORI: 
# Federico Moncini, 5936828, federico.moncini@stud.unifi.it 
# Lorenzo Mungai, 5962693, lorenzo.mungai@stud.unifi.it 
# Tommaso Capecchi, 5943118, tommaso.capecchi@stud.uni.it 
# 
# ---------DATA DI CONSEGNA---------


.data
     message: .asciiz "Insert a string: "
     arrayInput: .space 100
     
.text
.globl main

main:

     li $v0, 4                      # procedura di stampa di message
     la $a0, message
     syscall
     
     li $v0, 8                      # procedura per l'inserimento degli input nell'array
     la $a0, arrayInput
     li $a1, 100
     syscall

	 addi $t0,$zero,0               # inizializzo il contatore  t0 = 0
     
loop:                               # t1 = arrayInput[t0]
	 lb $t1,arrayInput($t0)
	 beq $t1,$zero,exit             
	 li $t2, ' '                    # controllo carattere tramite switch statement
	 beq $t1,$t2, incrementa
	 li $t2, 'u'
	 beq $t1,$t2, case1
	 li $t2, 'd'
	 beq $t1,$t2, case2
	 li $t2, 'n'
	 beq $t1,$t2, case3
	 	 
	 j notFound
	 
	
case1: 
     addi $t0,$t0,1                  # controllo word = 'uno'
     lb $t1, arrayInput($t0)
     li $t2, 'n'
	 bne $t1,$t2, notFound
     addi $t0,$t0,1
     lb $t1, arrayInput($t0)
     li $t2, 'o'
	 bne $t1,$t2, notFound
	 addi $t0,$t0,1
     lb $t1, arrayInput($t0)
	 li $t2, '\n'                    # carattere "invio" che precede il carattere '0', l'ultimo della stringa
	 addi $a0,$zero,1                
	 beq $t1,$t2, exitInvio          
	 li $t2, ' '
	 bne $t1,$t2, notFound
	 li $v0,1
	 syscall
	 j loop

case2:
     addi $t0,$t0,1                  # controllo word = 'due'
     lb $t1, arrayInput($t0)
     li $t2, 'u'
	 bne $t1,$t2, notFound
     addi $t0,$t0,1
     lb $t1, arrayInput($t0)
     li $t2, 'e'
	 bne $t1,$t2, notFound
	 addi $t0,$t0,1
     lb $t1, arrayInput($t0)
	 li $t2, '\n'
	 addi $a0,$zero,2
	 beq $t1,$t2, exitInvio
	 li $t2, ' '
	 bne $t1,$t2, notFound
	 li $v0,1
	 syscall
	 j loop	 

case3:
     addi $t0,$t0,1                 # controllo word = 'nove'
     lb $t1, arrayInput($t0)
     li $t2, 'o'
	 bne $t1,$t2, notFound
     addi $t0,$t0,1
     lb $t1, arrayInput($t0)
     li $t2, 'v'
	 bne $t1,$t2, notFound
	 addi $t0,$t0,1
     lb $t1, arrayInput($t0)
     li $t2, 'e'
	 bne $t1,$t2, notFound
	 addi $t0,$t0,1
     lb $t1, arrayInput($t0)
	 li $t2, '\n'
	 addi $a0,$zero,9
	 beq $t1,$t2, exitInvio
	 li $t2, ' '
	 bne $t1,$t2, notFound
	 li $v0,1
	 syscall
	 j loop		 
	 
incrementa:
	 addi $t0,$t0,1
	 j loop
     
	 
notFound:                               # stampa carattere '?'
     li $v0,11
     li $t2,'?'
     move $a0,$t2
     syscall
	 addi $t0,$t0,-1
     j incrementaFinoASpazio

incrementaFinoASpazio:
     addi $t0,$t0,1
     lb $t1,arrayInput($t0)
     li $t2, ' '
	 beq $t1,$t2, incrementa
	 beq $t1,$zero,exit
     j incrementaFinoASpazio
	 
exitInvio:
     li $v0,1
	 syscall
	 j exit
	 
	 
exit:
     li $v0, 10
     syscall