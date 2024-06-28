
print1: .string "\nStack overflow! Cannot push value onto stack.\n"
print2: .string "\nStack underflow! Cannot pop an empty stack.\n"
print3: .string "\nEmpty stack\n"
print4: .string "\nCurrent stack contents:\n"
print5: .string " %d"
print6: .string "<-- top of stack"
print7: .string "\n"

STACKSIZE = 5
FALSE = 0
TRUE = 1

        .data                   // Global variables
top:    .word   -1

        .bss
stack:  .skip   STACKSIZE * 4

.text
    fp      .req    x29
    lr      .req    x30
    .balign 4
        .global top
        .global stack

// Function: stackFull
    .global stackFull
stackFull:

    stp fp, lr, [sp, -16]!                     // Save frame pointer (fp) and link register (lr) to the stack
    mov fp, sp                                 // Set fp to the top of the stack

    adrp x9, top                              // Load top
    add x9, x9, :lo12:top                   
    ldr w10, [x9]                             // w20 = top

    mov w11, STACKSIZE - 1

    cmp w10, w11                               // Compare top with STACKSIZE - 1
    b.ne stackFull_else 
    mov w0, TRUE                               // If top = STACKSIZE -1, return TRUE
    b stackFull_end

stackFull_else:                                 // If top != STACKSIZE -1, return FALSE
    mov w0, FALSE

stackFull_end: 
    ldp fp, lr, [sp], 16 
    ret
// Function: stackEmpty
    .global stackEmpty
stackEmpty:
    stp fp, lr, [sp, -16]!                     // Save frame pointer (fp) and link register (lr) to the stack
    mov fp, sp                                 // Set fp to the top of the stack

    adrp x9, top                              // Load top
    add x9, x9, :lo12:top                   
    ldr w10, [x9]                             // w20 = top

    cmp w10, -1                                // Compare top with -1
    b.ne stackEmpty_else                       // If top != -1, go to stackEmpty_else
    mov w0, TRUE                               // If top = -1, returen TRUE
    b stackEmpty_end

stackEmpty_else:
    mov w0, FALSE                               // If top != -1, returen FALSE

stackEmpty_end:
    ldp fp, lr, [sp], 16 
    ret

// Function: push
    .global push
push:
    stp fp, lr, [sp, -16]!                     // Save frame pointer (fp) and link register (lr) to the stack
    mov fp, sp                                 // Set fp to the top of the stack

    mov w23, w0
    bl stackFull                               // Call function stackFull
    mov w20, TRUE                              
    cmp w0, w20                                // Compare w0 with w20
    b.ne push_else
    
    adrp x0, print1                            // If TRUE, print print1
    add x0, x0, :lo12:print1
    bl printf
    b push_end

push_else:
    adrp x19, top                              // Load top
    add x19, x19, :lo12:top                   
    ldr w21, [x19]                             // w21 = top
    add w21, w21, 1
    str w21, [x19]

    adrp x19, stack                            // If FALSE, store the value in array
    add x19, x19, :lo12:stack
    str w23, [x19, w21, SXTW 2]  

push_end:
    ldp fp, lr, [sp], 16 
    ret

// Function: pop
    .global pop
pop:
    stp fp, lr, [sp, -16]!                     // Save frame pointer (fp) and link register (lr) to the stack
    mov fp, sp                                 // Set fp to the top of the stack

    bl stackEmpty                              // Call function stackEmpty
    mov w20, TRUE                              
    cmp w0, w20                                // Compare w0 with w20
    b.ne pop_else

    adrp x0, print2                            // If TRUE, print print2
    add x0, x0, :lo12:print2
    bl printf

    mov w0, -1
    
    b pop_end

pop_else:
    adrp x19, top                              // Load top
    add x19, x19, :lo12:top                   
    ldr w21, [x19]                             // w21 = top

    adrp x20, stack
    add x20, x20, :lo12:stack
    ldr w0, [x20, w21, SXTW 2]                 // w0 = value = stack[top]
    sub w21, w21, 1                            // top = top - 1
    str w21, [x19]

pop_end:
    ldp fp, lr, [sp], 16 
    ret

// Function : display
    .global display
display:

    stp fp, lr, [sp, -16 - 32]!                     // Save frame pointer (fp) and link register (lr) to the stack
    mov fp, sp                                 // Set fp to the top of the stack
    str x19, [sp, 16]
    str x20, [sp, 24]
    str x21, [sp, 32]
    str x22, [sp, 40]
    bl stackEmpty                              // Call function stackEmpty
    mov w20, TRUE                              
    cmp w0, w20                                // Compare w0 with w20
    b.ne display_else                          // If FALSE, go to display_else

    adrp x0, print3                            // If TRUE, print print3
    add x0, x0, :lo12:print3
    bl printf

    b display_end

display_else:
 
    adrp x0, print4                            // Print print4
    add x0, x0, :lo12:print4
    bl printf

    adrp x19, top                              // Load top
    add x19, x19, :lo12:top                   
    ldr w21, [x19]                             // w21 = top
    
    mov w22, w21                               // i = top = w22
    b test
display_else_loop:

    adrp x0, print5                            // Print print5
    add x0, x0, :lo12:print5

    adrp x19, stack
    add x19, x19, :lo12:stack
    ldr w1, [x19, w22, SXTW 2]
    bl printf    

    cmp w22, w21                               // Compare i with top
    b.ne display_else_loop_if                  // If i != top, go to display_else_loop_if

    adrp x0, print6                            // If i = top, print print6
    add x0, x0, :lo12:print6
    bl printf
          
display_else_loop_if:

    adrp x0, print7                            // If i != top, print print7
    add x0, x0, :lo12:print7
    bl printf

    sub w22, w22, 1                            // i = i - 1 

test:
    cmp w22, 0                                 // Compare i with 0
    b.ge display_else_loop

display_end:
    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldr x21, [sp, 32]
    ldr x22, [sp, 40]
    ldp fp, lr, [sp], 16 + 32 
    ret
