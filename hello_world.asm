### MIPS program to write Hello World ### 

####################
### Data Section ###
#################### 

	.data		## Data declaration section 
	
## String to be printed: 
out_string: 	.asciiz		"\nHello, World!\n" 


####################
### Text section ###
####################  

	.text 		## Assembly language instructions go into text segment 
	
main: 			## Start of code section 
	li $v0, 4 		## system call code for printing string = 4 
	la $a0, out_string	## load address of string to be printed into $a0 
	syscall			## call operating system to perform operation 
				## 	specified in $v0
				
	li $v0, 10 		## terminate program 	
	syscall 
	
	
	
