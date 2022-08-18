#                                           ICS 51, Lab #1
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################
#                           Data Section
.data
# 


new_line: .asciiz "\n"
space: .asciiz " "
double_range_lbl: .asciiz "\nDouble range (Decimal Values) \nExpected output:\n1200 -690 104\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n75757575 FD5775DF 064B9A83\nObtained output:\n"
count_bits_lbl: .asciiz "\nCount bits \nExpected output:\n20 24 13\nObtained output:\n"

swap_bits_test_data:  .word 0xBABABABA, 0xFEABBAEF, 0x09876543
swap_bits_expected_data:  .word 0x75757575, 0xFD5775DF, 0x064B9A83

double_range_test_data: .word 945, -345, 0, -3, 55
double_range_expected_data: .word 1200, -690, 104

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
count_bits:
move $t0, $a0 
############################## Part 1: your code begins here ###
move $t1, $t0
li $t0, 0
while:
beq  $t1, 0, end
and $t2, $t1, 1
srl $t1, $t1,1
add $t0,$t0,$t2
j while
end:

############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
#                            PART 2 (Swap Bits)
# 
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ###
move $t1, $t0
sll $t2, $t1,1
srl $t3, $t1,1
andi $t3, $t3, 0x55555555
andi $t2, $t2, 0xAAAAAAAA
or $t0, $t2,$t3




############################## Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by two and return it.
# 
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.

double_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ##
bge $t0,$t1,check1
b right
check1:
bge $t0,$t2, check2
b add3
check2:
bge $t1,$t2, add1
b add2

right:
bge $t1,$t2, check4
b add1
check4:
bge $t0,$t2, add3
b add2


add1:
add $t5, $t0,$t2
b result
add2:
add $t5, $t0,$t1
b result
add3:
add $t5, $t1,$t2
b result

result:
mul $t0, $t5, 2



       
############################### Part 3: your code ends here  ##
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function 
main:

li $v0, 4
la $a0, new_line
syscall
la $a0, count_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_bits

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, double_range_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, double_range_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal double_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

