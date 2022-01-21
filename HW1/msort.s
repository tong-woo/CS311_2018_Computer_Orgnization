.data




A:	.word 13		43	16	23	9	2	15	19	8	28	
   30	4	48	24	10	18	29	35	6	35

buf:	.word  0		0	0	0	0	0	0	0	0	0
      0	0	0	0	0	0	0	0	0	0	
.text
.globlmain





merge:
          addi $sp, $sp, -36
          sw $ra, 32($sp)
          sw $s7, 28($sp)            #right
          sw $s6, 24($sp)            #mid
          sw $s5, 20($sp)            #left
          sw $s4, 16($sp)            #A
          sw $s3, 12($sp)            #buf
          sw $s2, 8($sp)              #right_i
          sw $s1, 4($sp)              #left_i
          sw $s0, 0($sp)              #i


          move $s4, $a0              #move $a0 to $s4 A[]
          move $s5, $a1              #left
          move $s6, $a2              #mid
          move $s7, $a3              #right
          addi $s0, $s5, $zero      #i=left


for1tst: 
          slt $t0, $s7, $s0	#if right<i then $t0=1
          bne $t0, $zero, exit1	#if $t0 is not 0 then go exit1
          sll $t1, $s0, 2		#i*4
          add $t1, $s3, $t1	#$t1=buf+4*i
          sll $t2, $s0, 2		#i*4
          add $t2, $s4, $t2           #$t2=A+4*i
          lw $t3, 0($t2) 	#$t3=A[i]
          sw $t3, 0($t1)		#buf[i]=A[i]
          addi $s0, $s0, 1	#i++
          j for1tst 		#loop

exit1:
        addi $s0, $s5, $zero	#i=left
        addi $s1, $s5, $zero	#left_i=left
        addi $s2, $s6, 1	#right_i=mid+1


while1:
           slt $t4, $s6, $s1	#if mid<left_i then $t4=1
           bne $t4, $zero, while3  #if $t4=1 then go to while3
           slt $t5, $s7,$s2	#if right<right_i then $t5=1
           bne $t5, $zero, while2	#if $t5=1 then go to while2
           sll $t6, $s1, 2		
           add $t6, $s3, $t6
           lw $t7,0($t6)
           sll $t8, $s2, 2
           add $t8, $s3, $t8
           lw $t9, 0($t8)
           sll $t1, $s0, 2
           add $t1, $s4, $t1
           stl $t0, $t7, $t9
           beq $t0, $zero, exit2
           sw $t7, 0($t1)
           addi $s1, $s1, 1
           addi $s0, $s0, 1
           j while1
exit2:
        sw $t9, 0($t1)
        addi $s2, $s2, 1
        addi $s0, $s0, 1


while2:
           slt $t4, $s6, $s1
           bne $t4, $zero, exit3
           sll $t0, $s0, 2
           add $t0, $s4, $t0
           sll $t1, $s1, 2
           add $t1, $s3, $t1
           lw $t2, 0($t1)
           sw $t2, 0($t0)
           addi $s1, $s1, 1
           addi $s0, $s0, 1
           j while2

while3:
           slt $t5, $s7, $s2
           bne $t5, $zero, exit3
           sll $t0, $s0, 2
           add $t0, $s4, $t0
           sll $t1, $s2, 2
           add $t1, $s3, $t1
           lw $t2, 0($t1)
           sw $t2, 0($t0)
           addi $s2, $s2, 1
           addi $s0, $s0, 1
           j while3

exit3:
         lw $s7, 28($sp)
         lw $s6, 24($sp)
         lw $s5, 20($sp)
         lw $s4, 16($sp)
         lw $s3, 12($sp)
         lw $s2, 8($sp)
         lw $s1, 4($sp)
         lw $s0, 0($sp)
         addi $sp, $sp, 36
         jr $ra

mergesort:
                  addi $sp, $sp, -20
                  sw $ra, 16($sp)
                  sw $s3, 12($sp)
                  sw $s2, 8($sp)
                  sw $s1, 4($sp)
                  sw $s0, 0($sp)
                 
                  move $s2, $a2
                  move $s1, $a1
                  move $s0, $a0
                  slt $t0, $s1, $s2
                  beq $t0, $zero, exit
                  add $s0, $s1, $s2
                  srl $s3, $s3, 1
                  addi $s2, $s3, $zero
                  jal mergesort
                  addi $s1, $s3, 1
                  jal mergesort
                  jal merge


exit:
      lw $s3, 12($sp)
      lw $s2, 8($sp)
      lw $s1, 4($sp)
      lw $s0, 0($sp)
      addi $sp, $sp, 20
      jr $ra
                      
             
           































          