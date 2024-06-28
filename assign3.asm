Print1: .string "Unsorted array:\n"
Print2: .string "v[%d] = %d\n"
Print3: .string "\nSorted array:\n"

SIZE = 100 
i_size = 4
j_size = 4
gap_size = 4
temp_size = 4
v_size = SIZE * 4 

i_off = 16
j_off = i_off + i_size
gap_off = j_off + j_size
temp_off = gap_off + gap_size
v_off = temp_off + temp_size		// Calculate the offsets

alloc = -(i_size + j_size + gap_size + temp_size + v_size +16) & -16
dealloc = -alloc

define(i, w19) 				// Define the registers
define(j, w20) 
define(gap, w21) 
define(temp, w22)
define(base, x23)
define(ran_num, w24)
define(Size_r, w25)
define(v_j, w26)
define(v_j_gap, w27)
define(j_gap, w28)

fp .req x29
lr .req x30

   .balign 4
   .global main

main:

    stp   fp, lr, [sp, alloc]!  	// Save frame pointer (fp) and link register (lr) to the stack
    mov   fp, sp  			        // Set fp to the top of the stack
    mov   w0, 0  			        // x0 is the register in which the random number will be stored
    bl    time  			        // Set the time value time_t value which vary every time
    bl    srand  			        // Set seed for rand
    str   wzr, [fp, i_off]		    // Store the value of index with an offset of 16

First_loop_test:

    ldr i, [fp , i_off]                 // Load the value of i 
    cmp i, SIZE	                        // Compare i with SIZE
    b.ge Print_array                    // If i >= SIZE, go to "print_array"

    bl  rand                            // Call the rand() function to generate a random number
    mov ran_num, w0                     // Store the random number in w0 into ran_num
    and ran_num, ran_num, 0x1FF         // Mod the random positive integers by 512

    add base, fp, v_off                 // Calculate the array base
    str ran_num, [base, i, SXTW 2]      // Assign ran_num to v[i]
    ldr i, [fp, i_off]                  // Load the value of i
    add i, i, 1                         // Increment
    str i, [fp, i_off]                  // Store the value of i

    b   First_loop_test                 // Go back to the loop test


Print_array:

    ldr w0, =Print1
    bl  printf                          // Print the statement
   
    str wzr, [fp, i_off]		        // Store the value of index with an offset of 16

Print_array_test:
    ldr i, [fp , i_off]                 // Load the value of i 
    cmp i, SIZE                         // Compare i with SIZE
    b.ge Shell_sort_1                   // If i >= SIZE, go to "Shell_sort_1"

    ldr w0, =Print2                     // Print the statement
    ldr w1, [fp, i_off]                 // Load the value of i
    ldr w2, [base, w1, SXTW 2]          // Load the array
    bl printf

    ldr i, [fp, i_off]                  // Load the value of i
    add i, i, 1                         // Increment
    str i, [fp, i_off]                  // Store the value of i

    b   Print_array_test                // Go back to the loop test


Shell_sort_1:
    mov Size_r, SIZE                     // Move SIZE into Size_r                       
    lsr gap, Size_r, 1                   // Gap = Size_r/2
    str gap, [fp, gap_off]               // Store the value of gap  

Shell_sort_1_test:
    ldr gap, [fp, gap_off]               // Load the value of gap
    cmp gap, 0                           // Compare gap with 0
    b.le Print_sorted_array              // If gap <= 0, go to Print_sorted_array

Shell_sort_2:
    ldr gap, [fp, gap_off]               // Load the value of gap
    str gap, [fp, i_off]                 // Store the value of gap into i

Shell_sort_2_test:
    ldr i, [fp, i_off]                   // Load the value of i
    cmp i, SIZE                          // Compare i with SIZE
    b.ge Shell_sort_1_gap_change         // If i >= SIZE, go back to Shell_sort_1_gap_change

Shell_sort_3:
    ldr i, [fp, i_off]                   // Load the value of i
    ldr gap, [fp, gap_off]               // Load the value of gap
    sub j, i, gap                        // j = i - gap
    str j, [fp, j_off]                   // Store the value of j

Shell_sort_3_test1:
    ldr j, [fp, j_off]                   // Load the value of j
    cmp j, 0                             // Compare j with 0
    b.lt Shell_sort_2_i_change            // If j < 0, go back to Shell_sort_2_i_change
Shell_sort_3_test2:
    ldr gap, [fp, gap_off]               // Load the value of gap
    add base, fp, v_off                  // Calculate the array base
    ldr v_j, [base, j, SXTW 2]           // Load the value of v[j]
    add j_gap, j, gap                    // j_gap = j + gap
    ldr v_j_gap, [base, j_gap, SXTW 2]   // Load the value of v[j+gap]
    cmp v_j, v_j_gap                     // Compare v_j with v_j_gap
    b.ge Shell_sort_2_i_change           // If v_j >= v_j_gap, go back to Shell_sort_2_i_change

Shell_sort_exchange:
    str v_j, [fp, temp_off]              // Store the value of v_j into temp
    str v_j_gap, [base, j, SXTW 2]       // Stroe the value of v_j_gap into v_j
    ldr temp, [fp, temp_off]             // Load the value of temp
    str temp, [base, j_gap, SXTW 2]      // Stroe the value of temp into v_j_gap

Shell_sort_3_j_change:
    ldr j, [fp, j_off]                   // Load the value of j
    sub j, j, gap                        // j = j - gap
    str j, [fp, j_off]                   // Store the value of j
    b Shell_sort_3_test1                 // Go back to Shell_sort_3_test1

Shell_sort_2_i_change:
    ldr i, [fp, i_off]                   // Load the value of i
    add i, i, 1                          // i = i + 1
    str i, [fp, i_off]                   // Increment
    b Shell_sort_2_test                  // Go back to Shell_sort_2_test

Shell_sort_1_gap_change:
    ldr gap, [fp, gap_off]               // Load the value of gap
    lsr gap, gap, 1                      // Gap = gap/2
    str gap, [fp, gap_off]               // Store the value of gap
    b   Shell_sort_1_test                // Go back to Shell_sort_1_test


Print_sorted_array:

    ldr w0, =Print3
    bl  printf                          // Print the statement
   
    str wzr, [fp, i_off]		        // Store the value of index with an offset of 16

Print_sorted_array_test:
    ldr i, [fp , i_off]                 // Load the value of i 
    cmp i, SIZE                         // Compare i with SIZE
    b.ge done                           // If i >= SIZE, go to "done"

    ldr w0, =Print2                     // Print the statement
    ldr w1, [fp, i_off]                 // Load the value of i
    ldr w2, [base, w1, SXTW 2]          // Load the array
    bl printf

    ldr i, [fp, i_off]                  // Load the value of i
    add i, i, 1                         // Increment
    str i, [fp, i_off]                  // Store the value of i

    b   Print_sorted_array_test         // Go back to the loop test


done:

    ldp x29, x30, [sp], dealloc         // Deallocate the stack memory
    mov x0, 0                           // Return code is 0 (no errors)
    ret

