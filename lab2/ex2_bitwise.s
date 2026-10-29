.text
.globl main

main:
    li a0, 0x12345678 # Color de prueba (R=12, G=34, B=56, A=78 hex)
    jal ra, get_green
    
    # Imprimir resultado 
    mv a1, a0 # El resultado estaba en a0, lo movemos a a1 para ecall
    li a0, 1 # syscall 1: print_int
    ecall
    
    li a0, 10 # syscall 10: exit
    ecall
# ------------------------------------------------
# FUNCTION: get_green
# Entrada: a0 = color RGBA (32 bits)
# Salida: a0 = valor del canal verde (8 bits)
# ------------------------------------------------
get_green:
    mv t0, a0          # copiamos nuestro color original a t0 para no mutar a0 todavia
    
    srli t1, t0, 16    # desplazamos 16 bits a la derecha y guardamos en t1
    andi t1, t1, 0xFF  # aplicamos una mascara and con 0xFF (11111111 en binario)
    mv a0, t1          # pasamos nuestro resultado final a a0 por convencion
    ret