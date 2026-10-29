.data
    array: .word 1, 2, 3, 4, 5
    len: .word 5
    
.text
.globl main

main:
    la a0, array
    lw a1, len
    jal ra, sum_array_broken
    
    # Imprimir resultado
    # Debería ser 1+2+3+4+5 = 15
    mv a1, a0
    li a0, 1
    ecall
    
    li a0, 10
    ecall
    
 sum_array_broken:
    # inicializamos
    li t0, 0            # iniciamos nuestro acumulador en 0
    li t3, 2            # constante 2 para comparar puesto que leemos de a pares
    
loop:
    # --- CICLO DESENROLLADO ---
    blt a1, t3, cleanup # si nuestra longitud es menor a 2, rompemos el ciclo debido a que nos saldriamos del arreglo (el bug original)
    
    lw t1, 0(a0)        # leemos nuestro primer elemento
    add t0, t0, t1      # lo sumamos al acumulador
    
    lw t2, 4(a0)        # leemos el segundo elemento (la optimizacion)
    add t0, t0, t2      # lo sumamos tambien
    
    addi a0, a0, 8      # avanzamos nuestro puntero 2 palabras (8 bytes)
    addi a1, a1, -2     # restamos 2 a la longitud
    
    j loop              # repetimos el proceso
    
cleanup:
    beq a1, zero, end   # si ya no quedan elementos, terminamos directo
    lw t1, 0(a0)        # si quedo 1 elemento suelto (impar), lo leemos
    add t0, t0, t1      # lo sumamos a nuestro acumulador final
    
end:
    mv a0, t0           # pasamos nuestro resultado final a a0
    ret