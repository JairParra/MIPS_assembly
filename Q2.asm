#########################################################
#############################
# Hair Albeiro Parra Barrera 
# ID: 260738619
# ASG5: Question 2
# COMP 273 
#############################
# DESCRIPTION: 
# The following program does the following: 
# 	1. In the main() propmpt the user to input an integer number greater than or equal to zero 
#	2. If the user inputs a value less than zero, then terminate the program with the message: 
# 	   "The value you entered is less than zero. This program only works with values greater than, 
# 	    or euql to zero." 
#	3. If the user inputs a value greate than or equal to zero, then call the factorial function 
# 	   given in class. If there are any bugs in the code, fix them. 
#	4. After factorial() returns the answer, from the main print the following messages: 
#		a. "Your input:" and the value they entered from the keyboard. New line. 
# 		b. "The factorial is: " and the value returned by the function factorial. New line. 
#	5. Now, prompt the user to see if they would like to do this again. Tell the user to input a 
# 	  single character 'Y' (capital letter Y) to do it again, all other characters terminate the program. 
# 	  If the user inpits 'Y' then go to step 1. 
#########################################################

####################
### Data Section ###
#################### 

	.data
	
prompt_int: 	.asciiz "Welcome to the factorial program.\nPlease input an integer greater than zero.\n"
your_input: 	.asciiz "Your input: " 
fact_is: 	.asciiz "The factorial is: "
error_msg: 	.asciiz "The value you entered is less than zero.\nThis program only works with values greater than or equal to zero" 
endl:		.asciiz "\n" 
result: 	.word 0 

	

####################
### Text Section ###
####################

	.text 
	.globl __main 			# execution starts here
	
__main: 
# main body of the program 

	## VARS ## 
	# $t0 = user_input 
	## VARS ##
	
 	# Printing out welcome and prompt input 
 	la $a0, prompt_int		# $t1 points to the age_question string 
 	li $v0, 4			# call to print a string 
 	syscall 	
 	
 	# Receive input and store  
 	li $v0, 5			# code for reading an int from input
	syscall				# ask for input 
	move $t0, $v0			# use macro to store in %t0 
					# i.e. $t0 = input int 
					
	# Ceck whether input is negative, if yes, throw an error 
	slt $t1, $t0, $zero		# %t1 <- ($t0 < 0)?  (is usr input < zero ? )
	beq $t1, 1, NegIntException 	# if ur_input is negative, go to NegIntException 
				
	## VARS ## 
	# $t0 = user_input 
	# $t1 = ($t0 < 0)? 
	## VARS ##	

	## *** Print "Your input: user_input \n	 *** ## 

 	# Printing out input for clarity
 	la $a0, your_input		# $t1 points to the your_input string 
 	li $v0, 4			# call to print a string 
 	syscall 
 	
	# Print the user input 
	move $a0, $t0 			# move input int to $v0 
	li $v0, 1			# system call to print int 
	syscall 

	# Printing out a line jump 
	la $a0, endl			# $a0 = *endl (\n) 
	li $v0, 4			# syscall for print stirng 
	syscall  
	
	## *** Factorial function *** ### 
	
							
	# Call the factorial subroutine  
	# $t0 contains the input 
	move $a0, $t0			# $a0 <- $t0 (user_input) 
	jal factorial 			# jump to factorial label 
	move $t2, $v0 			# $t2 <- $v0 ( factorial(n-1)  
	
	la $t7, result			# get address 
	move $t7, $v0			# move answer of factorial into result 
	
	
	## *** Print " The factorial is X \n" *** ##  

	# Print "The factorial is: "
	la $a0, fact_is			# set $a0 to the string fact_is 
 	li $v0, 4			# call to print a string 
 	syscall 	
 
 	# Print result of factorial(n)
	move $a0, $t2			# $v0 <- $a0 <- factorial(n) 
	li $v0, 1			# system call to print int 
	syscall 	

	
	# Print end of line 
	la $a0, endl			# $a0 = *endl (\n) 
	li $v0, 4			# syscall for print stirng 
	syscall  	
	
	# Exit the program 
	j exit 				# exit 
	
 	
 factorial:
 # subroutine that calculates n! 
 #  
 # int fact(int n)  
 # {
 # 	if (n<1) return 1;  	# base case 
 # 	else return n * fact(n-1); 
 # } 
 # 
 #	$a0 = user_input  
 
 	subi $sp, $sp, 8 		# make room for 2 registers 
 	sw $ra, 4($sp) 			# stack[1] <- $ra 
 	sw $a0, 0($sp)			# stack[2] <- $a0 (put n into the stack) 
 	
 	li $t4, 1
	slt $t1, $a0, $t4		# if (n<1) 
	beq $t1, $zero, fact_else	# go to fact_else if n > 1  	
 	
 	addi $v0, $zero, 1		# return 1 
 	addi $sp, $sp, 8		# pop 2 from stack (not restored) 
 	jr $ra 
 	
 	 	
 fact_else: 
 # else statement of the factorial function 
 
 	subi $a0, $a0, 1 		# n := n-1
 	jal factorial 			# recursion 
 	lw $a0, 0($sp)			# when we return back 
 	lw $ra, 4($sp) 			
 	addi $sp, $sp, 8		# pop 2 from the stack 
 	mul $v0, $a0, $v0 		# $v0 = n*fact(n-1) 
 	jr $ra 

 NegIntException: 
 # Simulates an exception when input is negative 
 
 	# Printing out input for clarity
 	la $a0, error_msg	# $t1 points to the your_input string 
 	li $v0, 4		# call to print a string 
 	syscall 	
 	
 	# Break the program 
 	j exit
 
 
 exit: 
 	li $v0,10		# 10 means to exit the program 
	syscall 
 
