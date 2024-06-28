fmt: .string "original: 0x%08X  reversed: 0x%08X\n" 
// Print out the original and reversed variable and x and y

.balign 4
.global main

main:
    stp x29, x30, [sp, -16]! // Allocate the stack memory
    mov x29, sp   

    define(x, w19) // Define the registers
    define(y, w20)
    define(t1, w21)
    define(t2, w22)
    define(t3, w23)
    define(t4, w24)
    define(b, w25) // Load logical operation result
    define(d, w26) // Load other shift result

    // Step1
    mov x, 0x07FC07FC // Initialize x with 0x07FC07FC
    and b, x, 0x55555555
    // Logical instruction AND with source x and 0x55555555, 
    // Load the result in b
    lsl t1, b, 1 // Left Shift b with 1 shift count
    lsr d, x, 1 // Right Shift x with 1 shift count
    and t2, d, 0x55555555
    // Logical instruction AND with source d and 0x55555555
    // Load the result in t2 
    orr y, t1, t2 
    // Logical instruction Inclusive OR with source t1 and t2
    // Load the result in y

    // Step2
    and b, y, 0x33333333
    // Logical instruction AND with source y and 0x33333333
    // Load the result in b
    lsl t1, b, 2 // Left Shift b with 2 shift count
    lsr d, y, 2 // Right Shift y with 2 shift count
    and t2, d, 0x33333333 
    // Logical instruction AND with source d and 0x33333333
    // Load the result in t2 

    orr y, t1, t2 
    // Logical instruction Inclusive OR with source t1 and t2
    // Load the result in y

    // Step3
    and b, y, 0x0F0F0F0F
    // Logical instruction AND with source y and a
    // Load the result in b
    lsl t1, b, 4 // Left Shift b with 4 shift count
    lsr d, y, 4 // Right Shift y with 4 shift count
    and t2, d, 0x0F0F0F0F
    // Logical instruction AND with source d and 0x0F0F0F0F
    // Load the result in t2 
    orr y, t1, t2 
    // Logical instruction Inclusive OR with source t1 and t2
    // Load the result in y

    // Step4
    lsl t1, y, 24 // Left Shift y with 24 shift count
    and b, y, 0xFF00
    // Logical instruction AND with source y and 0xFF00
    // Load the result in b
    lsl t2, b, 8 // Left Shift b with 8 shift count
    lsr d, y, 8 // Right Shift y with 8 shift count
    and t3, d, 0xFF00
    // Logical instruction AND with source d and 0xFF00
    // Load the result in t3
    lsr t4, y, 24 // Right Shift y with 24 shift count
    orr y, t1, t2
    orr y, y, t3
    orr y, y, t4

b1: // Make a breakpoint
    // Logical instruction Inclusive OR with source t1, t2, t3, t4
    // Load the result in y

    adrp x0, fmt
          add w0, w0, :lo12:fmt
          mov w0, w0
          mov w1, w19
          mov w2, w20
          bl printf


    ldp x29, x30, [sp], 16 // Deallocate the stack memory
    ret
     