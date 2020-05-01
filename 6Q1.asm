#########################################################
#############################
# Hair Albeiro Parra Barrera 
# ID: 260738619
# ASG6: Question 1
# COMP 273 
#############################
# DESCRIPTION: 
# 	MIPS Driver Subroutine: 
# 		- Does not use runtime stack, but only register conventions for 
# 		  subroutine access. $a0-$a5 for parameter, $v0-$v1 for returning values. 
# 		- Only uses the run-time stack for saving the s registers. 
# 
# 	MIPS Function Subroutine: 
# 		- All parameters, local variables and saving registers are placed on the 
# 		  runtime-stack, and returned are placed into $v0-$v1. 
# 
# Create a driver GETCHAR  , similar to char getchar(void) in MIPS: 
# 		- Interfaces with keyboard's status and data registers. 
# 		  Returns the characters in keyboard buffer to register $v0. 
# 		  Can't use the OS syscall command. 
# 
# Create a driver PURCHAR , similar to void putchar(char c) in MIPS: 
# 		- Interfaces with the screen's(console) status and data registers. 
# 		  The driver assumes $a0 contains the character that needs to be output. 
# 
# 
#########################################################

####################
### Data Section ###
#################### 

	.data
	
prompt_int: 	.asciiz "Welcome to the program. \nPlease input a single character\n" 
BUFFER: 	.space 2048 # memory space  
limit:		.word 2 # limit


####################
### Text Section ###
####################

	.text 
	.globl __main 
	
__main: 		# execution starts here 


 	# Printing out welcome and prompt input 
 	la $a0, prompt_int		# $t1 points to the age_question string 
 	li $v0, 4			# call to print a string 
 	syscall 
 	
 	# This part reads a char, puts it in $v0, and 
 	# then sends it to the screen 
# 	jal GetChar		# get a char and store in $v0 
# 	move $a0, $v0		# move the character to $a0  
# 	jal PutChar		# call the subroutine to output to the screen  
	
	
 	# have to place the parameters in the stack 
  	la $s0, BUFFER		# address to where the thing starts 
 	lw $s1, limit		# load the limit value in #s0
 	
 	# load the parameters on the stack 
 	subi $sp, $sp, 8 	# make 8 bytes of space on the stack 
 	sw $s0, 0($sp)  	# stack[0] = BUFFER.address  
 	sw $s1, 4($sp)		# stack[1] = limit.address 
 	
 	jal gets		# call the gets subroutine 
 				# the BUFFER string is now populated 
 				
 	jal puts 		# call the puts subroutine 
 	
 	addi $sp, $sp, 8	# free the stack memory 
 	
	# Printing the buffer again 
#	la $a0, BUFFER			# $a0 = *endl (\n) 
#	li $v0, 4			# syscall for print stirng 
#	syscall  
			
 	j exit			# finish 
 	
 	
###########
# GETCHAR # 
########### 
# Description: 
# 	- Returns the read char in $v0 

GetChar: 
	lui $a3, 0xffff		# load base address of memory map 
CkReady: 
	lw $t1, 0($a3)		# read form receiver control reg 
	andi $t1, $t1, 0x1	# exctract ready bit 
	beqz $t1, CkReady	# if 1, then load char, else loop 
	lw $v0, 4($a3)		# load character from keyboard  
	jr $ra			# return to place where subroutine was called
	
###########
# PUTCHAR # 
########### 
# Description: 
# 	- assumes the character to be output is in  $a0 

PutChar: 
	lui $a3, 0xffff		# base address of memory map  
XReady: 
	lw $t1, 8($a3)		# read from transmitter control reg 
	andi $t1, $t1, 0x1	# extract ready bit  
	beqz $t1, XReady 	# if 1, then store char, else loop 
	sw $a0, 12($a3)		# send char to display 
	jr $ra 			# return to place where subroutine was called 
	

# Functions Description: 
# 	- GETS reads (PUTS writes) ASCII from the keyboard into a memory space pointed to by BUFFER
# 	  (from BUFFER to the screen for PUTS) 
# 	- It stops reading when the user either pressed enter key (ASCII=10), 
# 	  or when LIMIT characters is reached; 
#	- PUTS stops printing when NULL ('\0') is found. 
# 	- PUTS also returns the number of characters it read 	 

####################################
# 	      GETS		   #  
# int gets(char *buffer, int limit)# 
#################################### 

gets: 
# assumes: 
	# $0(sp) = address to beinning of buffer
	# $4(sp) = adress of the limit of the string 
	
	# load parameters 
	lw $s0, 0($sp) 		# load the base address to the buffer 
	lw $s1, 4($sp)		# load the address to the limit 
	li $s2, 0		# counter = 0 // index 
	li $t2, 10		# ascii code for a jumpline 
	li $t5, 13		# ascii code for a carriage return 
	move $t7, $ra		# save calling address
	
	getsLoop: 
		
		jal GetChar		# $v0 <- get char from stdin
		beq $s2, $s1, endGetsLoop # exit loop if counter = limit 
		move $t3, $v0		# move fetched char into $t3
		# $t3 = fetched char 
		
		beq $t3, $t2, endGetsLoop # exit if \n is encountered 
		beq $t5, $t2, endGetsLoop # exit if carriage return is encountered 
		
		add $t4, $s0, $s2	# $t4 = buffer address = Pointer to Buffer + Counter 
		sb $t3, 0($t4)		# save the read char into the buffer at position $t3  	
		
		addi $s2, $s2, 1	# increment counter 
		j getsLoop		# repeat loop 
		
	endGetsLoop: 
	
	la $t3, ($zero)			# NULL character 
	add $t4, $s0, $s2		# obtain the address to BUFFER
	sb $t3, 0($t4)			# append '\0' to the BUFFER  
	
	jr $t7 			# return to original calling place 
	
	
#########################
# 	  PUTS		#  
# int puts(char *buffer)# 
#########################

puts: 
# assumes: 
	# $0(sp) = address to beinning of buffer
	# will always put the current char in $a0
	# returns number of chars read in $v0
	
	# load parameters 
	lw $s0, 0($sp) 		# load the base address to the buffer 
	li $s2, 0		# $s2 = char_count // counter 
	li $t2, 0		# ascii code for a NULL character
	move $t7, $ra		# save calling address
	
	putsLoop: 
		
		add $t3, $s0, $s2	# BUFFER.addr = base addr + counter
		lb $s3, ($t3)		# load byte from BUFFER 
		beq $s3, $t2, endPutsLoop # end loop if NULL char is found  
		move $a0, $s3		# place current char in $a3 
		
		jal PutChar 		# output char in $a0 to display 
		
		addi $s2, $s2 1		# counter = counter + 1 		
		j putsLoop 		# Repeat until no chars left
		
	endPutsLoop: 
	
	move $v0, $s2 		# return number of characters read in $v0
	jr $t7 			# return to original calling place 

	
 exit: 
 	li $v0,10		# 10 means to exit the program 
	syscall 
