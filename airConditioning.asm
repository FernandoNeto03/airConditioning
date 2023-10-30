.data
	#Recinto
	inputHeight: .asciiz "\nInsira o pe direito do ambiente\n"
	inputWidth : .asciiz "\nInsira a largura do ambiente\n"
	inputLength : .asciiz "\nInsira o comprimento do ambiente\n"
	inputPosition: .asciiz "\n\nQual a posição do ambiente?\n\t[1]Entre andares;\n\t[2]Sob telhado;\n"

	roomOutput: .asciiz "\nkcal/h ambiente:"
	roomVolume: .float 0.0
	roomKcal : .float 0.0
	
	floors: .float 16.0
	roof: .float 22.3
	
	#Janelas
	windowLengthInput: .asciiz "\nQual o comprimento das janelas?\n"
	windowWidthInput: .asciiz "\nQual a largura das janelas?\n"
	windowNumberInput: .asciiz "\nQuantas janelas tem no ambiente?\n"
	windowSituationInput: .asciiz "\nQual a situacao das janelas?\n\t[1]Sol manha com cortina\t\t[2]Sol tarde com cortina\n\t[3]Sol manha sem cortina\t\t[4]Sol tarde sem cortina\n\t\t\t\t[5]Vidros na sombra\n"
	windowArea: .float 0.0
	windowKCal: .float 0.0
	
	#Valores das situacoes das janelas
	varSituation1: .float 160.0
	varSituation2: .float 212.0
	varSituation3: .float 222.0
	varSituation4: .float 410.0
	varSituation5: .float 37.0
	
	#Portas
	doorLengthInput: .asciiz "\nQual o comprimento das portas?\n"
	doorWidthInput: .asciiz "\nQual a largura das portas?\n"
	doorNumberInput: .asciiz "\nQuantas portas tem no ambiente?\n"
	doorArea: .float 0.0
	doorKCalHour: .float 125.0
	
	#Pessoas
	pplAmmountInput: .asciiz "\nQuantas pessoas trabalham no ambiente?\n"
	pplKcalHour: .float 125.0

	#Aparelhos
	watt: .float 0.9
	eletDevicesInput: .asciiz "\nQual o total da potencia em W que os aparelhos consomem no ambiente?\n"
	eletDevicesKcalHour: .float 0.0
	
	#BTU
	Kcal: .float 3.92 #1 KcalHora --> 3,92 BTU
	btuInput: .asciiz "\nValor total do ambiente em BTU: "
	thermalLoad: .float 0.0
	
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
	
	#Posicao recinto
	printS(inputPosition)
	li $v0, 5
	syscall
	move $t0, $v0

	beq $t0, 1, entreAndares
	bgt $t0, 1, sobTelhado

	
returnHere1:
	printS(roomOutput)
	printF()
	
	#Janelas	
	printS(windowLengthInput)
	scanF()
	mov.s $f2, $f0 #windowLength
	
	printS(windowWidthInput)
	scanF()
	mov.s $f4, $f0 #windowWidth
	
	printS(windowNumberInput)
	scanF()
	mov.s $f6, $f0 #numeros de janelas em $f6
	
	printS(windowSituationInput)
	li $v0, 5
	syscall
	
	move $t0, $v0 #situacao da janela em $t0
	
	jal getArea #area das janelas
	swc1 $f12, windowArea

	beq $t0, 1, situWindow1
	beq $t0, 2, situWindow2
	beq $t0, 3, situWindow3
	beq $t0, 4, situWindow4
	beq $t0, 5, situWindow5
	
returnHere2:
	printS(doorLengthInput)
	scanF()
	mov.s $f2, $f0 #door length
	
	printS(doorWidthInput)
	scanF()
	mov.s $f4, $f0 #door width
	
	printS(doorNumberInput)
	scanF()
	mov.s $f6, $f0
	
	jal getArea
	swc1 $f12, doorArea
	#load para kcal/hora da porta
	lwc1 $f2, doorKCalHour
	mul.s $f12, $f12, $f2
	swc1 $f12, doorKCalHour
	
	printS(pplAmmountInput)
	scanF() #Numero de pessoas
	
	lwc1 $f2, pplKcalHour
	mul.s $f12, $f0, $f2
	swc1 $f12, pplKcalHour
	
	printS(eletDevicesInput)
	scanF()
	
	lwc1 $f2, watt #Carregando o valor de Watt para a conversao
	mul.s $f12, $f2, $f0 #Valor de Watt total da sala em Kcal/Hora
	swc1 $f12, eletDevicesKcalHour
	
	j kcalToBTU
	
returnHere3:
	printS(btuInput)
	swc1 $f12, thermalLoad #Storage no valor total para a memoria
	printF()
	
	li $v0, 10
	syscall
	
	
	
getVolume:
	
	mul.s $f2, $f2, $f4 # f4 para auxiliar apenas
	mul.s $f12, $f2, $f6 # valor do volume em $f12
	
	jr $ra
	
getArea:
	
	mul.s $f12, $f2, $f4
	mul.s $f12, $f12 $f6
	
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
	
situWindow1:
	
	lwc1 $f2, varSituation1
	mul.s $f12, $f12, $f2
	swc1 $f12, windowKCal
	
	j returnHere2

situWindow2:

	lwc1 $f2, varSituation2
	mul.s $f12, $f12, $f2
	swc1 $f12, windowKCal
	
	j returnHere2
	
situWindow3:

	lwc1 $f2, varSituation3
	mul.s $f12, $f12, $f2
	swc1 $f12, windowKCal
	
	j returnHere2
	
situWindow4:

	lwc1 $f2, varSituation4
	mul.s $f12, $f12, $f2
	swc1 $f12, windowKCal
	
	j returnHere2
	
situWindow5:

	lwc1 $f2, varSituation5
	mul.s $f12, $f12, $f2
	swc1 $f12, windowKCal
	
	j returnHere2

kcalToBTU:
	lwc1 $f0, thermalLoad #valor total da carga termica
	lwc1 $f2, roomKcal#
	lwc1 $f4, windowKCal #
	lwc1 $f6, doorKCalHour#
	lwc1 $f8, pplKcalHour#
	lwc1 $f10, eletDevicesKcalHour#
	lwc1 $f14, watt #valor para converter W para BTU
	
	#Soma total carga termica
	add.s $f0, $f2, $f4
	add.s $f0, $f0, $f6
	add.s $f8, $f8, $f10
	add.s $f0, $f0, $f8 #Soma total em $f0
	
	#Conversao
	mul.s $f12, $f0, $f14
	
	j returnHere3
	

	