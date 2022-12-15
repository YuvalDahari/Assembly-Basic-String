#Yuval Dahari 209125939

.section .rodata
    pstrlenCase:       .string "first pstring length: %d, second pstring length: %d\n"                  #31
    replaceCharCase:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"      #32 & 33
    swapCaseCase:      .string "length: %d, string: %s\n"                                               #35 & 36
    pstrijcmpCase:     .string "compare result: %d\n"                                                   #37
    defaultCase:       .string "invalid option!\n"                                                      #default

    scanfChar:         .string "%c"
    scanfInt:          .string "%d"
    scanfString:       .string "%s"

    .align 16          # Align address to multiple of 16

     .L10:
        .quad .case31           # case 31
        .quad .case32           # case 32
        .quad .case33           # case 33
        .quad .case34           # default
        .quad .case35           # case 35
        .quad .case36           # case 36
        .quad .case37           # case 37
        .quad .caseDefualt      # default

	########
.section .text

.globl	run_func
	.type	run_func, @function
# void run_func(Pstring* pstr1, Pstring* pstr2, int choice)
# pstr1 in %rdi, pstr2 in %rsi, choice in %rdx
run_func:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %r12                     # r12 is a callee save
    pushq       %r13                     # r13 is a callee save

    leaq        (%rdi), %r12             # Pstr* temp = src->str
    leaq        (%rsi), %r13             # Pstr* temp = dst->str

    leaq        -30(%rdx),  %r8          # Compute c = choice - 30
    cmpq
    # switch case (choice):
    cmpq        $31, %rdx                # case (31)
    je          .case31

  .case31:                               # pstrlen
    xorq        %rax, %rax               # char size1 = 0
    call        pstrlen                  # size1 = pstr1->size
    movq        %rax, %r8                # r8 = size1

    movq        %rsi, %rdi               # rdi = &pstr2
    xorq        %rax, %rax               # char size2 = 0
    call        pstrlen                  # size2 = pstr2->size
    movq        %rax, %r9                # r9 = size2

    movq        $pstrlenCase, %rdi       # load format for print
    movq        %r8, %rsi                # first variable - size1
    movq        %r9, %rdx                # second variable - size2
    xorq        %rax, %rax               # clear rax
    call        printf

    jmp .End                             # break

  .case32:                               # replaceChar
    movq        $scanfChar, %rdi         # load format for scanf
    leaq        (%r10), %rsi             # set storage to address the old char
    xorq        %rax, %rax               # clear rax
    call        scanf

    movq        $scanfChar, %rdi         # load format for scanf
    leaq        (%r9), %rsi              # set storage to address the new char
    xorq        %rax, %rax               # clear rax
    call        scanf

    leaq        (%r12), %rdi             # first variable - pstr1
    xorq        %rsi, %rsi               # clear rsi
    leaq        (%r10), %rsi             # second variable - old char
    xorq        %rdx, %rdx               # clear rdx
    leaq        (%r9), %rdx              # third variable - new char
    call        replaceChar
    movq        %rax, %r12               # put the update pstr1 in r12

    leaq        (%r13), %rdi             # first variable - pstr2
    xorq        %rsi, %rsi               # clear rsi
    leaq        (%r10), %rsi             # second variable - old char
    xorq        %rdx, %rdx               # clear rdx
    leaq        (%r9), %rdx              # third variable - new char
    call        replaceChar
    movq        %rax, %r13               # put the update pstr2 in r13

    movq        $replaceCharCase, %rdi   # load format for printf
    xorq        %rsi, %rsi               # clear rsi
    leaq        (%r10), %rsi             # first variable - old char
    xorq        %rdx, %rdx               # clear rdx
    leaq        (%r9), %rdx              # second variable - new char
    leaq        1(%r12), %rcx            # third variable - pstr1->str
    leaq        1(%r13), %r8             # forth variable - pstr2->str
    xorq        %rax, %rax               # clear rax
    call        printf

    jmp         .End                     # break

  .case33:                               # replaceChar
    jmp         .case32

  .case35:                               # pstrijcpy
    movq        $scanfInt, %rdi          # load format for scanf
    leaq        (%r10), %rsi             # set storage to address the start's index i
    xorq        %rax, %rax               # clear rax
    call        scanf

    movq        $scanfInt, %rdi          # load format for scanf
    leaq        (%r9), %rsi              # set storage to address the finish's index j
    xorq        %rax, %rax               # clear rax
    call        scanf

    leaq        (%r12), %rdi             # first variable - pstr1
    leaq        (%r13), %rsi             # second variable - pstr2
    leaq        (%r10), %rdx             # third variable - index i
    leaq        (%r9), %rcx              # forth variable - index j

    call        pstrijcpy



