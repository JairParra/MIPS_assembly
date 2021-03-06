## 
## length.a - prints out the length of character string "str"
## 
## 	t0 - holds each byte from string in turn 
## 	t1 - contains count of characters 
## 	t2 - points to the string  

### *** TEXT SEGMENT *** ### 

	.text 
	.globl __start 		# execution starts here
	
__start: 
	la $t2, str 		# t2 points to the string  
	li $t1, 0 		# t1 holds the count 
	
nextCh: 
	lb $t0, ($t2) 		# get a byte from string  
	beqz $t0, strEnd 	# zero means the end of the string 
	add $t1, $t1, 1		# increment count 
	add $t2, $t2, 1		# move pointer one character 
	j nextCh		# go around the loop again 
	
strEnd: 
	la $a0, ans 		# system call to print 
	li $v0, 4 		# out a message (4)
	syscall 
	
	move $a0, $t1 		# system call to print 
	li $v0, 1 		# out the length worked out 
	syscall 
	
	la $a0, endl 		# system call to print 
	li $v0, 4 		# out a new line 
	syscall 
	
	li $v0,10		
	syscall 		# 10 means to exit the program 
	
	
### *** DATA SEGMENT *** ### 

	.data 
str: 	.asciiz "hello world" 
ans: 	.asciiz "Length is " 
endl:	.asciiz "\n" 

## 
## enf of file length.a 
