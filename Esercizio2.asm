# AUTORI: 
# Federico Moncini, 5936828, federico.moncini@stud.unifi.it 
# Lorenzo Mungai, 5962693, lorenzo.mungai@stud.unifi.it 
# Tommaso Capecchi, 5943118, tommaso.capecchi@stud.uni.it 
# 
# ---------DATA DI CONSEGNA---------

.data 
     message1: .asciiz "Il programma calcola n secondo le procedure annidate\n\n"
     message2: .asciiz "Inserisci n \n"
     
.text
.globl main

main:

welcome:
     la $a0, message1
     li $v0, 4
     syscall

input:
     la $a0, message2
     li $v0, 4
     syscall
     li $v0, 5
	 syscall
	 
	 add $t0, $v0, $zero
	 li $t1, 1
	 slt $t2, $t0, $t1
	 li $t3, 1       
	 beq $t2, $t3, input
	 li $t1, 8                 #salva in $t1 il valore 8
	 sgt $t2, $t0, $t1         #$t2 = 1 if t0>8, else t2=0               
	 beq $t2, $t3, input       #if t2=1 richiama input
	 add $a0, $v0, $zero
	 jal funzioneG
	 add $a0, $v0, $zero       #sposta in a0 il valore v0
	 li $v0, 1
	 syscall
	 j exit
	 
funzioneG:
     addi $t0, $zero, 0        #salva b in t0, b = 0
	 addi $sp, $sp, -12        #alloca 12 byte (3 parole) nella stack
	 sw $ra, 0($sp)            #salva l'indirizzo di ritorno nello stack frame
     sw $t0, 4($sp)            #salva nella seconda posizione della stack b(t0)	 
	 addi $s0, $zero, 0        #salva k in s0
	 sw $a0, 8($sp)
	 
loop:
     lw $a0, 8($sp)
     bgt $s0, $a0, end
	 addi $t2, $zero, 0        #salva u in t2
	 addi $a0, $s0, 0          #sposta s0 in a0
	 jal funzioneF
	 addi $t2, $v0, 0          #salva in u (t2) il risultato di F(k)
	 lw $t0, 4($sp)            #estrae la b
	 mult $t0, $t0             #moltiplica b con se stesso
	 mflo $t3                  #salva il risultato di mult in t3
	 add $t0, $t3, $t2
	 sw $t0, 4($sp)
	 addi $s0, $s0, 1
	 j loop
	 
end:
     lw $ra, 0($sp)            #carica indirizzo di ritorno in ra
	 lw $v0, 4($sp)            #estrae b finale dalla stack
	 addi $sp, $sp, 12         #dealloca la stack
	 jr $ra                    #ritorna al main
	 
funzioneF:
     addi $sp, $sp, -8        #rialloca la stack
	 sw $ra, 0($sp)            #salva l'indirizzo di ritorno nello stack frame
	 sw $a0, 4($sp)            #salva k nello sf
     beq $zero, $a0, casoUgualea0
	 addi $a0, $a0, -1
	 jal funzioneF
	 addi $t4, $v0, 0          #salva in t4 il valore di F(n-1)
	 li $t1, 2
	 mult $t4, $t1             #moltiplica t4 per 2
	 mflo $t4                  #salva il risultato in t4
	 lw $t0, 4($sp)            #estrae la k dalla stack
	 add $v0, $t4, $t0         #2*F(n-1) + n
	 lw $ra, 0($sp)            #estrae l'indirizzo di ritorno
	 addi $sp, $sp, 8         #dealloca la stack
	 jr $ra
	 
casoUgualea0:
     addi $v0, $zero, 1
	 lw $ra, 0($sp)
	 addi $sp, $sp, 8
	 jr $ra
	 
exit:
     li $v0, 10
	 syscall
	 
