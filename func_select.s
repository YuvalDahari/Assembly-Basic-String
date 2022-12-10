#Yuval Dahari 209125939

.section .rodata
    pstrlenCase:       .string "first pstring length: %d, second pstring length: %d\n"                  #31
    replaceCharCase:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"      #32 & 33
    swapCaseCase:      .string "length: %d, string: %s\n"                                               #35 & 36
    pstrijcmpCase:     .string "compare result: %d\n"                                                   #37
    defaultCase:       .string "invalid option!\n"                                                      #default

    scanjChar:         .string "%c"
    scanfInt:          .string "%d"
    scanfString:       .string "%s"

    .align 16          # Align address to multiple of 16

     .L10:
        .quad .L31           # case 31
        .quad .L32           # case 32
        .quad .L33           # case 33
        .quad .L35           # case 35
        .quad .L36           # case 36
        .quad .L37           # case 37
        .quad .LDefault      # default case
	########
.section .text

.globl	run_func
	.type	run_func, @function
# void run_func(Pstring* pstr1, Pstring* pstr2, int choice)
# pstr1 in %rdi, pstr2 in %rsi, choice in %rdx
run_func:
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer