.data
    test_string: .string "Arquitectura 2025"
    
.text
.globl main

main:

    la a0, test_string # Preparar argumento
    jal ra, my_strlen # Llamar a la función
    
    # Imprimir resultado (Entero)
    mv a1, a0 # El resultado estaba en a0, lo movemos a a1 para ecall
    li a0, 1 # syscall 1: print_int
    ecall
    
    # Salir
    li a0, 10 # syscall 10: exit
    ecall
    
    my_strlen:
    # inicializamos
    mv t0, a0          # respaldamos la direccion en t0, este sera nuestro puntero
    li t1, 0           # inicializamos nuestro contador en 0

loop_strlen:
    # ciclo
    lbu t2, 0(t0)      # leemos el byte. Uso lbu (sin signo) para evitar errores con el bit de signo
    
    beq t2, zero, end_strlen  # si llegamos al terminador nulo (0), nos salimos el ciclo
    
    addi t1, t1, 1     # como no es 0, le sumamos 1 a nuestro contador
    addi t0, t0, 1     # avanzamos nuestro puntero 1 byte a la sig letra
    
    j loop_strlen      # repetimos para el proximo byte
    
end_strlen:

    mv a0, t1          # pasamos el resultado a a0 puesto que asi es la convencion
    ret