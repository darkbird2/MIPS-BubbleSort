# Zeke Wood
# this program takes a hard coded array and sorts it, it uses the buble sort algorithm to do the soring
# it is a smart bubble sort in that it will end early if not swaps are made in a run through
# this would indicate that the array is already sorted.

.data

efficiency:	.asciiz	"\nRun throughs: "
arr1: 		.word	8,3,7,2,5
arr1size: 	.word 	5

.text

main:

lw	$t1, arr1size($0)	# $t1 is the array size
li	$t0,1			# set to 1 so it starts as the second array element
beq	$t1,$t0,end		# as the great programmer Dr. Tindall once said "An array of 1 is already sorted"
				# this is a node to that, it is designed to end the program as fast as possible in that case
move	$s5,$t1			# $t5 holds array size, but is the version that changes though out program
li	$t0,1			# set to 1 so it starts as the second array element
li 	$t2,0			# set to 0 so it starts as the first array element
li	$t5,0			# initiated to 0
li	$t6,0			# initiated to 0



loop:

addi 	$sp, $sp, -4		# make room on stack
sw	$ra, 0($sp)		# push current $ra to stack
move	$a0, $t2		# put $t2 (value) into $a0
move	$a1, $t0		# put $t0 (choice) into $a1
jal	compare			# call the subroutine
lw	$ra, 0($sp)		# restore $ra from stack
addi 	$sp, $sp, 4		# restore stack
move	$t3, $v0		# copy return ($v0) over value ($t3)
li	$t4,1			# set $t4 to 1 so it can be used to compare in next line
beq	$t3,$t4,swapify		# if $t4 is 1 then a swap is needed and we jump to that part of the code

	
				# if we do not need to swap we can skip that step and move on
back:				

addi	$t0,$t0,1		# increments the counter so that the next piece of the array can be compared
addi	$t2,$t2,1		# increments the counter so that the next piece of the array can be compared
beq	$t0,$s5,Next		# at this time we are garenteed (by the algorithm) that the highest value has 
				# been brought up to the top of the unsorted part of the array
j	loop			# otherwise we go thorugh another iteration of the loop

swapify:

addi 	$sp, $sp, -4		# make room on stack
sw	$ra, 0($sp)		# push current $ra to stack
move	$a0, $t2		# put $t2 (value) into $a0
move	$a1, $t0		# put $t1 (choice) into $a1
jal	swap			# call the subroutine
lw	$ra, 0($sp)		# restore $ra from stack
addi 	$sp, $sp, 4		# restore stack
move	$t6, $v0		# copy return ($v0) over value ($t6)
j	back			# retuns us back to where we would of gone directly if a swap was not needed

Next:

beq	$t6,$0,end		# by this time if $t6 is not 42 (The Answer to the Ultimate Question of Life,
				# The Universe, and Everything) that means that no swaps have occured on
				# this run through and the array is sorted, ending the program	
li	$t6,0			# returning the value to 0 to start again for next loop
li	$t0,1			# set to 1 so it starts as the second array element
li 	$t2,0			# set to 0 so it starts as the first array element
addi	$s5,$s5,-1		# due to the fact that the at the end of each run through the highest number
				# has made its way up to the top we do not need to go to the top of the array again
addi	$t5,$t5,1		# keeps track of how many times we have gone through aray and at N times program ends
beq	$t5,$t1,end		# due to the fact we are garenteed to have 1 more right answer per run thorugh
				# after as many run throughs as we have elements must result in a correct answer
j 	loop


end:

li	$s1,0			# sets $s1 to 0 so we can print the first array element
sll	$s3,$t1,2		# we need to take $t1*4 to convert it to word form addressing

print:

li	$v0,1			# code for print integer
lw 	$t9, arr1($s1) 		# set $t9 to arr1[iterator]
move 	$a0, $t9		# puts $t9 into $a0 for system call
syscall				# prints the integer
addi 	$s1,$s1,4		# moves onto the next instance in the array
beq	$s1,$s3,done		# goes until the end of the array is hit

j	print

done:

li	$v0,4			# code for print string
la	$a0,efficiency		# point $a0 to string
syscall				# print the string

				# I added this because there is no way to really prove it is smart
				# unless you can show that it is having less than array size run throughs
li	 $v0,1			# code for print integer
move 	$a0, $t5		# puts the amount of run through occured into $a0
syscall				# prints intiger


li 	$v0,10			# code for exit
syscall				# exits program


compare:

mul 	$a0,$a0,4		# multiplies by 4 to convert for word addressing
mul	$a1,$a1,4		# multiplies by 4 to convert for word addressing
lw	$a2,arr1($a0)		# loads the one of the array elements so it can be compared
lw	$a3,arr1($a1)		# loads the one of the array elements so it can be compared
slt	$s0,$a3,$a2		# compares to see if they need so be swaped or not
move	$v0,$s0			# $s0 will be set to 1 if a swap is needed
jr	$ra			


swap:

mul 	$a0,$a0,4		# multiplies by 4 to convert for word addressing
mul	$a1,$a1,4		# multiplies by 4 to convert for word addressing
lw	$a2,arr1($a0)		# loads the one of the array elements
lw	$a3,arr1($a1)		# loads the one of the array elements
sw	$a3,arr1($a0)		# saves the value into the other array spot
sw	$a2,arr1($a1)		# saves the value into the other array spot
li	$v0,42			# tells the program that a swap has occured and that more runs need to be made though the array
jr	$ra