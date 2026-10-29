.data
    lower_str: .string "hola mundo riscv"
    
.text
.globl main

main:
    la a0, lower_str
    jal ra, capitalize_string
    
    # Imprimir string modificado
    la a1, lower_str # Cargar dirección para print_string
    li a0, 4 # syscall 4: print_string
    ecall
    
    li a0, 10 # syscall 10: exit
    ecall
    
    to_upper:
        li t0, 'a'
        li t1, 'z'
        blt a0, t0, is_not_lower # Si es menor que 'a', no hacer nada
        bgt a0, t1, is_not_lower # Si es mayor que 'z', no hacer nada
        addi a0, a0, -32 # Convertir a mayúscula (ASCII offset)
        is_not_lower:
        ret
        
    capitalize_string:
    addi sp, sp, -8     # bajamos nuestra pila 8 bytes para hacer espacio
    sw ra, 4(sp)        # guardamos ra puesto que llamaremos a otra funcion (no es hoja)
    sw s0, 0(sp)        # guardamos s0 por convencion
    
    mv s0, a0           # pasamos nuestra direccion a s0 para no perderla en el ciclo debido a que to_upper va a usar a0 y lo va a sobreescribir

loop_cap:
    # cliclo
    lbu a0, 0(s0)       # cargamos nuestro caracter directo en a0 (listo como argumento)
    beq a0, x0, end_cap # si es el terminador nulo, rompemos el ciclo
    
    jal ra, to_upper    # llamamos a to_upper (nos devuelve el caracter en a0)
    sb a0, 0(s0)        # sobreescribimos el caracter modificado de vuelta en memoria
    
    addi s0, s0, 1      # avanzamos nuestro puntero al sig byte
    j loop_cap          # repetimos
    
end_cap:
    lw s0, 0(sp)        # restauramos nuestro s0 original de la pila
    lw ra, 4(sp)        # recuperamos nuestra direccion de retorno
    addi sp, sp, 8      # devolvemos el espacio a la pila
    ret