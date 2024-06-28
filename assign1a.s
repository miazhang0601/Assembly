fmt: .string "The minimum y for now is %d\n" // Print the minimum value 

.balign 4
.global main

main:
    stp x29, x30, [sp, -16]! // Allocate the stack memory
    mov x29, sp   

    mov x20, -10 // Initialize x20 with -10
    
    mov x28, 10000 // Give a big number as the first minimum value of y
    mul x28, x28, x28
    mul x28, x28, x28

    test:
     cmp x20,10 // Compare the x20 with 10
     b.gt done // If x20 is greater than 10, then the loop ends


       mov x19, 5 // Initialize x19 with 5
       mul x21, x20, x20 // Create the square x20
       mul x22, x21, x21 // Create the x^4
       mul x23, x19, x22 // Create the 5x^4
       mov x24, 448 // Initialize x24 with 448
       mul x25, x24, x21 // Create the 448x^2
       sub x26, x23, x25 // Create the 5x^4-448x^2
       mov x27, 63 // Initialize x27 with 63
       mul x27, x20, x27 // Create the 63x
       sub x26, x26, x27 // Create the 5x^4-448x^2-63x
       add x26, x26, 10 // Create the whole function and store it in y
       add x20, x20, 1 // Increment
       
       cmp x26, x28 // Find the minimum value of x26
       b.ge next // If x26 is greater than or equal to the x28,then move to next part.
       mov x28, x26 // If x26 is less than x28, move the minimum value of y into ymin

       next:
          adrp x0, fmt
          add x0, x0, :lo12:fmt
          mov x1, x28
          bl printf // Print the value
          b test // Go back to test

    
    done:

        ldp x29, x30, [sp], 16 // Deallocate the stack memory
        ret
     