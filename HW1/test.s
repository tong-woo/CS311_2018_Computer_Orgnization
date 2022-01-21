#data declaration begins here-------------------------------------------------------------------------------------------------

.data  
#declaration two array buf and A
buf:       .word   13 43 16 23 9 2 15 19 8 28 30 4 48 24 10 18 29 35 6 35      #initial data set for the input of the algorithm
A:       .word       0   0   0  0   0 0  0   0  0 0   0   0 0   0    0   0  0   0   0  0       #  array A
newline:    .asciiz "\n" #used to print a new line
space:   .asciiz " " #used to print a space
info0:       .asciiz "----------------------------initial Array A--------------------------- "  #print this string before the initial array
info1:       .asciiz "----------------------------sorted Array A---------------------------- " #print this array before the sorted array


#functions begins here----------------------------------------------------------------------------------------------------------

.text 
.globl main
#main function------------------------------------------------------------------------------------------------------------------
main:
   addi   $sp, $sp, -4       
   sw   $ra, 0($sp)       
   la   $a1, A    
   la   $a0, buf     
   addi   $a2, $zero, 20   
   and   $a3, $zero, $zero   
   add   $t0, $a0, $zero       
   add  $t3, $a2, $zero      
   #Print message
   li    $v0, 4            
   la   $a1, info0       
   syscall

   #Print newline  
   li    $v0, 4            
   la    $a1, newline       
   syscall
    #Print newline  
   li    $v0, 4            
   la    $a1, newline      
   syscall
   and   $t4, $zero, $zero   
   j   print_unsorted_array       
#print the initial array-------------------------------------------------------------------------------------------------------------
print_unsorted_array:                                         
    
   #While (i < length)
   slt     $t6, $t4, $a2      
   beq   $t6, $zero, prepare_mergesort   

   # Load Array[i] and print it
   sll   $t0, $t4, 2       # i * 4
   add   $t6, $a0, $t0       
   li    $v0, 1            # system call code for print_int
   lw   $a1, 0($t6)       # shift amount array itme
   syscall                # print it

   #Print spaces  
   li    $v0, 4            # system call code for print_str
   la    $a1, space       # address of string to print
   syscall      

   addi   $t4, $t4, 1       # i ++
   j   print_unsorted_array       # loop print for unsorted array
#prepare to merge sort the array-----------------------------------------------------------------------------------------------------------
prepare_mergesort:

   addi   $sp,   $sp,    -16   # make room on the stack
   sw   $ra,   12($sp)       
   sw   $a0,   8($sp)       # save address of buf
   add   $a2, $a2, -1       #$a2=right-1
   sw   $a2,   4($sp)       # save $a2
   sw   $a3,   0($sp)       # left
   jal   mergesort           # merge sort(array, left, right)


#print the sorted array-----------------------------------------------------------------------------------------------------------------------
#print new line before function and call the other function to print

PrintSorted:
    #newline  
   li    $v0, 4           
   la    $a1, newline      
   syscall

   #newline  
   li    $v0, 4            
   la    $a1, newline       
   syscall         

  
   li    $v0, 4           
   la   $a1, info1     
   syscall

   #newline  
   li    $v0, 4            
   la    $a1, newline       
   syscall
    #newline  
   li    $v0, 4            
   la    $a1, newline     
   syscall
   and   $t7, $zero, $zero   # set i to 0
   jal   print_sorted_array        # jump to print the sorted array


print_sorted_array:           
   #While (i< length)       
   slt     $t6, $t7, 20       # if i < the length of the array
   beq   $t6, $zero, Terminate   # if (length <= i) then exit loop

   sll   $t0, $t7, 2       # i * 4
   add   $t6, $a0, $t0       # address of array + offest
   li    $v0, 1            # print_int
   lw   $a1, 0($t6)       # shift amount array itme
   syscall                # print the array[i]

   #Print space  
   li    $v0, 4          
   la    $a1, space     
   syscall

   addi   $t7, $t7, 1       # i ++
   jal   print_sorted_array       # loop print
#end or terminate the algorithm---------------------------------------------------------------------------------------------------------------------------
Terminate:
  
   addi   $sp, $sp, 20      
   li   $v0, 10           
   syscall               
#the merge sort function
mergesort:

   addi$sp, $sp, -20       # make room on the stack
   sw $ra, 16($sp)           #  return address
   sw $s1, 12($sp)           # A address
   sw $s2, 8($sp)           # $s2=right
   sw $s3, 4($sp)           # $s3=left
   sw $s4, 0($sp)           # $s4=mid
   add $s1, $zero, $a0       # $s1 = address of array
   add $s2, $zero, $a2       # $s2 = right
   add $s3, $zero, $a3       # $s3 =left
   slt $t3, $s3, $s2           # if left< right then $t3=1
   beq $t3, $zero, finish       # if $t3 == 0, then completed
   add $s4, $s3, $s2       # $s4=left+right
   div $s4, $s4, 2           # $s4 = (left+right)/2
   add $a2, $zero, $s4       #left
   add $a3, $zero, $s3       # mid
   jal   mergesort          # mergesort(a, left, mid)

   # mergesort (a, mid+1, right)
   addi$t4, $s4, 1           # $t4= mid +1
   add $a3, $zero, $t4       # left= (mid+1)
   add $a2, $zero, $s2       # right
   jal   mergesort           #mergesort(a, mid+1, high)

   add $a0, $zero, $s1       # $a1=array address
   add $a2, $zero, $s2       # $a2=right
   add $a3, $zero, $s3       # $a3=left
   add $a1, $zero, $s4       # $a0=mid
   jal   merge           # go to merge (a, left, mid, right)
#finish the algorithm--------------------------------------------------------------------------------------------------------- 
finish:
          
   lw   $ra,   16($sp)       # load return address
   lw   $s1,   12($sp)       # load arguments array address
   lw   $s2,   8($sp)       # load arguments size of array = high
   lw   $s3,   4($sp)       # low size of array
   lw   $s4,   0($sp)       # register for mid
   addi   $sp,   $sp,    20   # clear room on the stack
   jr $ra               # jump to register

#merge function begin here---------------------------------------------------------------------------------------------------------
merge:  

   addi$sp, $sp, -20       # make room on the stack
   sw $ra, 16($sp)           # save return address
   sw $s1, 12($sp)           # save A
   sw $s2, 8($sp)           # save right
   sw $s3, 4($sp)           # save left
   sw $s4, 0($sp)           # save register for mid
   add $s1, $zero, $a0       # $s1=array address
   add $s2, $zero, $a2       # $s2=right
   add $s3, $zero, $a3       # $s3=left
   add $s4, $zero, $a1       # $s4=mid
   add $t1, $zero, $s3       # left_i=$t1
   add $t2, $zero, $s4       # $t2=mid
   addi $t2, $t2, 1           #right_i= $t2=mid + 1
   add $t3, $zero, $a3       #i

# the first while in the code to judge left_i, mid and right_i and right
while1:               

   slt $t4, $s4, $t1       # if mid<left_i then $t4=1
   bne $t4, $zero, while3  # go to while 3 if left_i > mid
   slt $t5, $s2, $t2       # $t5=1 if right<right_i
   bne $t5, $zero, while2   #  go to while 2 if right_i > right
   sll $t6, $t1, 2       # left_i*4
   add $t6, $s1, $t6   # $t6 = address buf[left_i]
   lw $s5, 0($t6)       # $s5 = f=buf[left_i]
   sll $t7, $t2, 2       # right_i*4
   add $t7, $s1, $t7   # $t7 = address buf[right_i]
   lw $s6, 0($t7)       # $s6 = buf[right_i]
   slt $t4, $s5, $s6       # if buf[left_i] < buf[right_i] then $t4=1
   beq $t4, $zero, exit1   # exit if buf[left_i] >= buf[right_i]
   sll $t8, $t3, 2       # i*4
   la $a1,A        # load address of temporary array (neccasary if using $a0 for print statements)
   add $t8, $a1, $t8   # $t8 = address A[i]
   sw $s5, 0($t8)       # A[i]=buf[left_i++]
   addi $t3, $t3, 1       # i++
   addi $t1, $t1, 1       # left_i++
   j   while1

exit1:

   sll $t8, $t3, 2       # left_i*4
   la $a1, A        # # load address of temporary array (neccasary if using $a0 for print statements)
   add $t8, $a1, $t8   # $t8 = address A[i]
   sw $s6, 0($t8)       # A[i]=buf[right_i++]
   addi $t3, $t3, 1       # i++
   addi $t2, $t2, 1       # right_i++
   j   while1

while2:
   slt $t4, $s4, $t1       # mid < left_i 
   bne $t4, $zero, while3   # go to while3 if left_i>mid
   sll $t6, $t1, 2       # left_i*4
   add $t6, $s1, $t6   # $t6 = address buf[left_i]
   lw $s5, 0($t6)       # $s5 = buf[left_i]
   sll $t8, $t3, 2       # left_i*4
   la $a1, A    # load address of array A
   add $t8, $a1, $t8   # $t8 = address A[i]
   sw $s5, 0($t8)       # A[i++] = buf[left_i++]
   addi $t3, $t3, 1       # i++
   addi $t1, $t1, 1       # left_i++
   j   while2

while3:

   slt $t5, $s2, $t2       # if right < right_i  then $t5=1
   bne $t5, $zero, begin   # go to for loop if right_i >= right
   sll $t7, $t2, 2       # right_i*4
   add $t7, $s1, $t7   # $t7 = address buf[right_i]
   lw $s6, 0($t7)       # $s6 = buf[right_i]
   sll $t8, $t3, 2       # i*4
   la $a1, A        # load address of array A 
   add $t8, $a1, $t8   # $t8 = address A[i]
   sw $s6, 0($t8)       # A[i] = buf[right_i]
   addi $t3, $t3, 1       # i++
   addi $t2, $t2, 1       # right_i++
   j   while3

begin:

   add $t1, $zero, $s3   # left_i =left



# for loop in the code used to copy the number from array A to array buf and make the program
#stop when two conditions in the first while both not met.(left_i >mid , right_i > right)

fortst1:

   slt $t5, $t1, $t3       #  if left_i< i then $t5=1
   beq $t5, $zero, finish   # branch if merging is complete
   sll $t6, $t1, 2       # left_i*4
   add $t6, $s1, $t6   # $t6 = address buf[left_i]
   sll $t8, $t1, 2       # i*4
   la $a0, A     # load address of temporary array (neccasary if using $a0 for print statements)
   add $t8, $a1, $t8       # $t8 = address A[left_i]
   lw $s7, 0($t8)       # $s7 = A[left_i]
   sw $s7, 0($t6)       # buf[left_i]
   addi $t1, $t1, 1       #left_i++
   j   fortst1   #loop for


