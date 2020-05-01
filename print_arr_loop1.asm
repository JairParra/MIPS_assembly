### MIPS program to initialize an array and print its contents ### 

#####################
### Daata Section ###
##################### 

	.data		## Data declaration section 
	
list: 	.word 	2, 3, 5, 7, 11, 12, 17, 19, 23, 29
size: 	.word	10 					# size of the array 
space:	.ascii " " 	# string to print a space  


####################
### Text section ###
####################  

	.text 
	
main: 				# Start of code section 

	lw $s0, size 		# load the size limit 
	la $t1, list 		# get array address
	li $t2, 0 		# set loop 
	la $t3, space		# get space address
	
print_loop: 
	beq $t2, $s0 , exit	# check for array end 
	lw  $a0, ($t1) 		# print value at the array pointer 
	li  $v0, 1 		# call code to print int 
	syscall 
	
	li $v0, 4 		# call code to print a string 
	la $a0, space		# load the space label into $a0
	syscall 
	
	addi $t2, $t2, 1	# advance loop counter 
	addi $t1, $t1, 4 	# advance array pointer (4 bytes?) 
	j    print_loop		# repeat the loop 
	
exit:  

	li $v0, 10 		## terminate program 	
	syscall 


	
