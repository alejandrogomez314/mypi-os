._section ".text.boot"

.global_start // execution starts here

_start:
    mrs x1,mpidr_el1  // put core processor id into a special system register
    and x1, x1, #3    // check if it equals #3
    cbz x1, 2f        // if comparison is true, goto 2f

1:  wfe               // otherwise, hang in an infinite loop
    b   1b            

// we're on main core
2:  ldr x1, =_start   // load into x1 register value of =_start
    mov sp1, x1       // set stack pointer
   
// clear section
    ldr x1, =__bss_start 
    ldr w2, =__bss_size

3:  cbz w2, 4f        // quit loop if non-zero
    str xzr,[x1], #8
    sub w2, w2, #1
    cbnz w2, 3b       // loop if non-zero
4:  bl  main          // jump to main() routine
    b   1b            // if it does not return, halt master core
