.data
	textHeight: .asciiz "\nInsira o valor do pe direito\n"
	height : .float 0.00
	
	textWidth : .asciiz "\nInsira o valor da largura\n"
	width : .float 0.00
	
	textLength : .asciiz "\nInsira o valor do comprimento\n"
	length : .float 0.00
	
	
	textPosition: .asciiz "\n\nQual a posição do ambiente?\n\t[1]Entre andares;\n\t[2]Sob telhado;\n"
	position: .word 0

	
.text
.globl main

main:

	li $v0, 4
	la $a0, textLength
 	syscall
	
 	li $v0, 6
 	syscall
 	
 	swc1 $f0, length
 	lwc1 $f1, length 	# comprimento em $f1
 	
 	li $v0, 4
	la $a0, textWidth
 	syscall
	
 	li $v0, 6
 	syscall
 	
 	swc1 $f0, width
 	lwc1 $f2, width		# largura em $f2
 	
 	li $v0, 4
	la $a0, textHeight
 	syscall
	
 	li $v0, 6
 	syscall
 	
 	swc1 $f0, height
 	lwc1 $f3, height	# pe direito(altura) em $f3
 	
 	jal getVolume
 	jal printFloat		# printa certo só rodar e testar !!! mudar getVolume pra $f12 !!!
	
	
	li $v0, 4
	la $a0, textPosition
 	syscall
	
	li $v0, 5
	syscall
	
	sw $t1, position   ##### arrumar ######
	
	
	
	
	
 	li $v0, 10
	syscall
	
	

printFloat: 			# jal printFloat funciona, valor float tem que ta em $f12
	li $v0,2
	syscall
	
	jr $ra
	
getVolume:
	
	mul.s $f4, $f1, $f2 # f4 para auxiliar apenas
	mul.s $f1, $f4, $f3 # valor do volume em $f1
	
	jr $ra
	
	