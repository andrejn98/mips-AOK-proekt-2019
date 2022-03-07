#173128 Nestorovski Andrej

.data
	niza1: .space 80 		#rezerviranje na 20 zbora po 4 bajti
	niza2: .space 80		#rezerviranje na 20 zbora po 4 bajti
	index: .word 173128		
.text

main:
	addi $t0, $zero, 0		#obicna promenliva za proverka na prvata niza
	addi $t3, $zero, 0		#obicna promenliva za proverka na vtorata niza
		
	li $v0, 5			#vnesuvanje na memoriska lokacija
	syscall
	move $s4,$v0

	li $v0, 5 			#broj na golemina na vektori
	syscall

	mul $s3, $v0, 4			#se mnozi so 4 zaradi beq vo while	
prva:
	beq $t0, $s3, vtora 		#ako stigne do goleminata na vneseniot broj da prekine
	
	li $v0, 5 			#broj od testatura za prva niza
	syscall
	
	move $t2, $v0			#zemi ja cifrata i stavija vo promenliva
	sw $t2, niza1($t0) 		#go stava vneseniot broj vo niza

	addi $t0, $t0, 4		#inkrementiraj za da odis na sleden index
	j prva				#vrati se od pocetok
vtora:
	beq $t3, $s3, procedura		#ako stigne do goleminata na vneseniot broj da prodolzi vo procedura:
	
	li $v0, 5 			#broj od testatura za vtora niza
	syscall
	
	move $t4, $v0			#zemi ja cifrata i stavija vo promenliva
	sw $t4, niza2($t3) 		#go stava vneseniot broj vo niza

	addi $t3, $t3, 4		#inkrementiraj za da odis na sleden index
	j vtora				#vrati se od pocetok
procedura:
	addi $s2, $zero, 0		#obicna promenliva za zemanje na cifrite od nizite
	
	jal sobiranje			#jump and link do sobiranje
	
	addi $s2, $zero, 0		#obicna promenliva za zemanje na cifrite od nizite
	
	jal mnozenje			#jump and link do mnozenje
	
	addi $t5, $zero, 65535		#vnesuvanje na 0000FFFF maska vo t5
	
	la $t6, index			#vnesuvanje na indexot na adresa vo t6
	
	lw $t7, 0($t6)			#citanje i vnesuvanje na indexot vo t7
	
	and $s1, $t7, $t5		#so koristenje na maskata kako 0000FFFF gi zemame poslednite 4 bajti od indexot i gi zacuvuvame vo s1
	
	li $v0, 1 			#go printa izmnozeniot broj
	move $a0, $t8
	syscall
	
	j exit				#jump do exit
sobiranje:
	lw $s5, niza1($s2)		#ja zema cifrata od prvata niza
	lw $s6, niza2($s2)		#ja zema soodvetnata cifra od vtorata niza
		
	add $t4, $s5, $s6		#gi sobira dvete cifri
	
	sw $t4, 0($s4)			#ja zacuvuva cifrata na vnesenata memoriska lokacija
	
	addi $s4, $s4, 4		#ja zgolemuva memoriskata lokacija za slednata cifra
	
	addi $s2, $s2, 4		#se inkrementira za da se zeme narednata cifra od nizite
	
	bne $s2, $s3, sobiranje		#proverka za dali se sobrani site cifri
	
	jr $ra				#skok do poslednata povikana instrukcija
mnozenje:
	lw $s5, niza1($s2)		#ja zema cifrata od prvata niza
	lw $s6, niza2($s2)		#ja zema soodvetnata cifra od vtorata niza
	
	mult $s5, $s6			#gi mnozi dvete cifri
	
	mflo $s7			#go zema proizvodot od lo
	
	add $t8, $t8, $s7		#go zacuvuva vo nova promenliva
	
	addi $s2, $s2, 4		#se inkrementira za da se zeme narednata cifra od nizite
	
	bne $s2, $s3, mnozenje		#proverka za dali se izmnozeni site cifri
	
	jr $ra				#skok do poslednata povikana instrukcija
exit:
	li $v0, 10			#kraj na programata
	syscall
