.data
    packed_data:
        .word 0x00000148 # Op:1, Val:'H' -> Save 'H'
        .word 0x0000016F # Op:1, Val:'o' -> Save 'o'
        .word 0x00000202 # Op:2, Val:2 -> Skip 2 words
        .word 0xFFFFFFFF # GARBAGE (Skipped)
        .word 0x12345678 # GARBAGE (Skipped)
        .word 0x00000346 # Op:3, Val:0x46 -> 0x46 XOR 0x2A = 'l' -> Save 'l'
        .word 0x00000161 # Op:1, Val:'a' -> Save 'a'
        .word 0x00000000 # Op:0 -> FIN
    
    # Buffer para guardar el resultado (Salida)
    output_buffer: .space 256
    
.text
.globl main

main:
    la a0, packed_data      # Input pointer
    la a1, output_buffer    # Output pointer
    
    jal ra, decode_message
    
    # Imprimir resultado descifrado
    la a1, output_buffer
    li a0, 4 # print_string
    ecall
    
    li a0, 10
    ecall
    
decode_message: 
loop_decode:
    # exraemos el payload
    lw t0, 0(a0)        # leemos nuestra palabra completa actual
    
    andi t1, t0, 0xFF   # aplicamos mascara para aislar nuestro payload en t1 puesto que solo nos importa el ultimo byte
    
    srli t2, t0, 8      # desplazamos 8 bits a la derecha para bajar nuestro opcode
    andi t2, t2, 0x07   # limpiamos el resto usando la mascara 7 (0111) debido a que el opcode solo usa 3 bits
    
    # simulamos el switch para evaluar el opcode
    li t3, 0        
    beq t2, t3, case_fin   # si es 0 vamos al fin
    
    li t3, 1
    beq t2, t3, case_copy  # si es 1 copiamos el caracter
    
    li t3, 2
    beq t2, t3, case_skip  # si es 2 saltamos palabras
    
    li t3, 3
    beq t2, t3, case_xor   # si es 3 aplicamos el descifrado xor
    
    j next_word            # caso default, saltamos a la sig palabra
    
    # --- ACCIONES ---
case_fin:
    sb zero, 0(a1)      # ponemos un cero al final de nuestro string por seguridad
    ret                 # retornamos al main
    
case_copy:
    sb t1, 0(a1)        # guardamos nuestro caracter en el buffer de salida
    addi a1, a1, 1      # avanzamos nuestro puntero de salida 1 byte
    j next_word         # salimos del switch
    
case_skip:
    slli t3, t1, 2      # multiplicamos el payload por 4 (shift left de 2) 
                        # puesto que cada palabra tiene 4 bytes de memoria
    add a0, a0, t3      # le sumamos este salto a nuestro puntero original
    j next_word
    
case_xor:
    xori t1, t1, 0x2A   # hacemos la operacion logica xor con 0x2A
    sb t1, 0(a1)        # guardamos nuestro resultado descifrado en memoria
    addi a1, a1, 1      # avanzamos nuestro puntero de salida
    j next_word
    
next_word:
    addi a0, a0, 4      # avanzamos nuestro puntero de entrada a la sig palabra
    j loop_decode       # repetimos el ciclo