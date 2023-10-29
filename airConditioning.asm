.data
	inputHeight: .asciiz "\nInsira o valor do pe direito\n"
	inputWidth : .asciiz "\nInsira o valor da largura\n"
	inputLength : .asciiz "\nInsira o valor do comprimento\n"
	inputPosition: .asciiz "\n\nQual a posição do ambiente?\n\t[1]Entre andares;\n\t[2]Sob telhado;\n"

	roomOutput: .asciiz "\nkcal/h recinto:"
	roomVolume: .float 0.0
	roomKcal : .float 0.0
	
	floors: .float 16.0
	roof: .float 22.3
	
.macro printS(%string)
.text
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro printF()
.text
	li $v0, 2
	syscall
.end_macro

.macro scanF()
.text
	li $v0, 6
	syscall
.end_macro

.text
.globl main

main:
	printS(inputLength)
 	scanF()
 	mov.s $f2, $f0 #length
 	
 	printS(inputWidth)
	scanF()
 	mov.s $f4, $f0
 	
	printS(inputHeight)
	scanF()
 	mov.s $f6, $f0 #height
 	
	jal getVolume
	swc1 $f12, roomVolume
	
	printS(inputPosition)
	li $v0, 5
	syscall
	move $t0, $v0 #position

	beq $t0, 1, entreAndares
	bgt $t0, 1, sobTelhado
	
returnHere1:
	printS(roomOutput)
	printF()
	
	
	li $v0, 10
	syscall
	
getVolume:
	
	mul.s $f2, $f2, $f4 # f4 para auxiliar apenas
	mul.s $f12, $f2, $f6 # valor do volume em $f12
	
	jr $ra

entreAndares:
	
	lwc1 $f0, roomVolume
	lwc1 $f2, floors
	
	mul.s $f12, $f0, $f2
	swc1 $f12, roomKcal
	
	j returnHere1
sobTelhado:
	
	lwc1 $f0, roomVolume
	lwc1 $f2, roof
	
	mul.s $f12, $f0, $f2
	swc1 $f12, roomKcal
	
	j returnHere1
	
