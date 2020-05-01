#########################################################
#############################
# Hair Albeiro Parra Barrera 
# ID: 260738619
# ASG5: Question 1 
# COMP 273 
#############################
# DESCRIPTION: 
# The following program does the following: 
#	1. Prompts the user to input their age in years: 
# 	   "How old are you?", using the OS print_string() library. 
# 	2. Read in the value input by the user using the OS read_int() library. 
# 	   Asssume the use always inputs a correct integer value grater than or equal to zero. 
#	3. Assuming no leap years and assuming the user is born on January 1st. 
# 	  , calculate the number of days they have been alive using a for-loop and addition. 
#	4. Print the message: "You have been alive for these many days: ", using the OS 
#	   print_string() library.  
#	5. Print the number of days you calculated using the OR print_int() library. 
# 	6. Your program terminates 
#########################################################

####################
### Data Section ###
#################### 

	.data

age_question:	.asciiz "How old are you? (in years)\n"	
age_display: 	.asciiz "Your input: " 
days_output: 	.asciiz "You have been alive for these many days: "
endl:		.asciiz "\n" 			# jump line 


####################
### Text Section ###
####################

	.text 
	.globl __start 		# execution starts here
	
 __start: 
 	# Printing out the question to the string
 	la $a0, age_question	# $t1 points to the age_question string 
 	li $v0, 4		# call to print a string 
 	syscall 
 	
 	# Asking the input from the user 
 	li $v0, 5		# code for reading an int from input
	syscall			# ask for input 
	move $t0, $v0		# use macro to store in %t0 
				# i.e. $t0 = age
	
 	# Printing out input for clarity
 	la $a0, age_display	# $t1 points to the age_question string 
 	li $v0, 4		# call to print a string 
 	syscall 
	
	# Print the user input 
	move $a0, $t0 		# move input int to $v0 
	li $v0, 1		# system call to print int 
	syscall 

	# Printing out a line jump 
	la $a0, endl		# $a0 = *endl (\n) 
	li $v0, 4		# syscall for print stirng 
	syscall 
		
		
# this part simulates the following loop: 
# for(count=0; count < age; count++) sum += 365; 
# 	$t0 = input age  
# 	$t1 = sum 
# 	$t2 = count
	
	li $t1, 0 		# sum = 0 
	li $t2, 0 		# count = 0 

 loop: 
 	beq $t0, $t2, finish	# exit loop if count == age 
 	addi $t1, $t1, 365	# sum += 365
 	addi $t2, $t2, 1	# count ++  
 	j loop			# next loop iteration 
 	
 
 finish: 
 	# Printing out the query answer string
 	la $a0, days_output	# $t1 points to the age_question string 
 	li $v0, 4		# call to print a string 
 	syscall 
 
 	# Print out calculation result
	move $a0, $t1 		# $a0 <- sum
	li $v0, 1		# system call to print int 
	syscall 	
 		
 exit: 
 	li $v0,10		# 10 means to exit the program 
	syscall 		
 	

