
define(month_i_r, w19)                  // w19 = the index of month
define(month_base_r, x20)               // w20 = the base of month
define(season_i_r, w21)                 // w21 = the index of season
define(season_base_r, x22)              // w22 = the base of season
define(argv_r, x23)
define(month, x24)                      // x24 = month
define(day, x25)                        // x25 = day
define(i_r, w26)
define(month_num, w27)
define(day_num, w28)

        .text
print1: .string "%s %dth is %s."        // print statements
print2: .string "%s %dst is %s."
print3: .string "%s %dnd is %s."
print4: .string "%s %drd is %s."

win_m: .string "Winter"                 // Season
spr_m: .string "Spring"
sum_m: .string "Summer"
fal_m: .string "Fall"

jan_m: .string "January"                // Month
feb_m: .string "February"
mar_m: .string "March"
apr_m: .string "April"
may_m: .string "May"
jun_m: .string "June"
jul_m: .string "July"
aug_m: .string "August"
sep_m: .string "September"
oct_m: .string "October"
nov_m: .string "November"
dec_m: .string "December"

        .data
        .balign 8
season_m: .dword    win_m, spr_m, sum_m, fal_m      
month_m:  .dword    jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m

        .text
        .balign 4
        .global main
main:
    stp x29, x30, [sp, -16]!                    // Save frame pointer (fp) and link register (lr) to the stack
    mov x29, sp                                 // Set fp to the top of the stack

    mov argv_r, x1                              // Copy argv

    ldr month, [argv_r, 1 * 8]                  // Get the first input

    mov i_r, 2
    ldr day, [argv_r, i_r, SXTW 3]              // Get the second input 

    mov x0, month                               // Convert string "month" to number
    bl atoi
    mov month_num, w0                           // Get the number of month
    sub i_r, month_num, 1

    mov x0, day                                 // Convert string "day" to number
    bl atoi
    mov day_num, w0                             // Get the number of day
    mov w2, day_num                             // Get the second var day(number)


    adrp month_base_r, month_m                  // Calculate month array base address
    add  month_base_r, month_base_r, :lo12:month_m
    ldr x1, [month_base_r, i_r, SXTW 3]         // Get the first var month(string)

    cmp day_num, 1
    b.eq print_print2                           // If the day is 1,21, or 31, print print2
    cmp day_num, 21
    b.eq print_print2
    cmp day_num, 31
    b.eq print_print2

    cmp day_num, 2                              // If the day is 2 or 22, print print3
    b.eq print_print3
    cmp day_num, 22
    b.eq print_print3

    cmp day_num, 3                              // If the day is 3 or 23, print print4
    b.eq print_print4
    cmp day_num, 23
    b.eq print_print4




print_print1:                                   // Set up the print statement print1 
    
    adrp x0, print1
    add x0, x0, :lo12:print1
    b season_decide

print_print2:                                   // Set up the print statement print2

    adrp x0, print2
    add x0, x0, :lo12:print2
    b season_decide

print_print3:                                   // Set up the print statement print3

    adrp x0, print3
    add x0, x0, :lo12:print3
    b season_decide

print_print4:                                   // Set up the print statement print4

    adrp x0, print4
    add x0, x0, :lo12:print4
    b season_decide

season_decide:

    adrp season_base_r, season_m                // Calculate the season array base address
    add season_base_r, season_base_r, :lo12: season_m
    b march

march:                                          
    cmp month_num, 3
    b.gt june                                   // month_num > 3,go to june
    b.eq march_day_decide
    b.lt winter1                                // January and February -- winter

march_day_decide:
    cmp day_num, 20
    b.le winter1                                // 3.1 - 3.20 -- winter
    b.gt spring1                                // 3.21 - 3.31 -- spring

june:
    cmp month_num, 6
    b.lt spring1                                // April and May -- spring
    b.eq june_day_decide
    b.gt september

june_day_decide:                    
    cmp day_num, 20
    b.le spring1                                // 6.1 - 6.20 -- spring
    b.gt summer1                                // 6.21 - 6.30 -- summer

september:
    cmp month_num, 9
    b.lt summer1                                // July and August -- summer
    b.eq september_day_decide
    b.gt december

september_day_decide:
    cmp day_num,20
    b.le summer1                                // 9.1 - 9.20 -- summer
    b.gt fall1                                  // 9.21 - 9.30 -- fall

december:
    cmp month_num, 12
    b.lt fall1                                  // October and November -- fall
    b.eq december_day_decide

december_day_decide:
    cmp day_num, 20
    b.le fall1                                  // 12.1 - 12.20 -- fall
    b.gt winter1                                // 12.21 - 12.31 -- winter

spring1:

    mov i_r, 1                                  // Get the third var season(string)
    ldr x3, [season_base_r, i_r, SXTW 3]
    b end

summer1:

    mov i_r, 2                                  // Get the third var season(string)
    ldr x3, [season_base_r, i_r, SXTW 3]
    b end

fall1:
    mov i_r, 3                                  // Get the third var season(string)
    ldr x3, [season_base_r, i_r, SXTW 3]
    b end

winter1:
    mov i_r, 0                                  // Get the third var season(string)
    ldr x3, [season_base_r, i_r, SXTW 3]
    b end

end:
    ldr x3, [season_base_r, i_r, SXTW 3]
    bl printf 
    
    ldp x29, x30, [sp], 16 
    ret



