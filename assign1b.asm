fmt: .string "The minimum y for now is %d\n" // Print the minimum value

.balign 4
.global main

main:
    stp x29, x30, [sp, -16]! // Allocate the stack memory
    mov x29, sp   

    define(a, x19)
    define(x, x20)
    define(c, x21)
    define(d, x22)
    define(e, x23)
    define(f, x24)
    define(g, x25)
    define(y, x26)
    define(i, x27)
    define(ymin, x28) // define the registers

    mov x, -10 // Initialize x with -10
    
    mov x28, 10000 // Give a big number as the first minimum value of y
    mul x28, x28, x28
    mul x28, x28, x28
    b test 

    top: 

       mov a, 5 // Initialize a with 5
       mul c, x, x // Create the square x
       mul d, c, c // Create the x^4
       mul e, a, d // Create the 5x^4
       mov f, 448 // Initialize f with 448
       mul g, f, c // Create the 448x^2
       sub y, e, g // Create the 5x^4-448x^2
       mov i, 63 // Initialize i with 63
       mul i, x, i // Create the 63x
       sub y, y, i // Create the 5x^4-448x^2-63x
       add y, y, 10 // Create the whole function and store it in y
       add x, x, 1 // Increment
       
       cmp y, ymin // Find the minimum value of y
       b.ge next // If y is greater than or equal to the ymin,then move to next part.
       mov ymin, y // If y is less than ymin, move y into ymin

       next:
          adrp x0, fmt
          add x0, x0, :lo12:fmt
          mov x1, ymin 
          bl printf // Print the minimum value
    
    test:
     cmp x,10 // Compare x with 10
     b.gt done // If x is greater than 10, then the loop ends
     b.le top // If x is less or equal to 10, then the loop continues
    
    done:

        ldp x29, x30, [sp], 16 // Deallocate the stack memory
        ret
     