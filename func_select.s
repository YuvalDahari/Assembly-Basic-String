# Yuval Dahari 209125939

.section .rodata
    pstrlenCase:       .string "first pstring length: %d, second pstring length: %d\n"                  #31
    replaceCharCase:   .string "old char: %s, new char: %s, first string: %s, second string: %s\n"      #32 & 33
    pstrijcpyCase:     .string "length: %d, string: %s\n"                                               #35
    swapCaseCase:      .string "length: %d, string: %s\n"                                               #36
    pstrijcmpCase:     .string "compare result: %d\n"                                                   #37
    defaultCase:       .string "invalid option!\n"                                                      #default

    scanfChar:         .string "%s"
    scanfInt:          .string "%d"
    scanfString:       .string "%s"

    .align 8                    # Align address to multiple of 8

    .switchCase:
        .quad .case31           # case 31
        .quad .case32           # case 32
        .quad .case33           # case 33
        .quad .case34           # default
        .quad .case35           # case 35
        .quad .case36           # case 36
        .quad .case37           # case 37
        .quad .caseDefault      # default

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

    cmpq        $37, %rdx                # if (chice > 37)
    ja          .caseDefault             # go to default case, the chice is invalid

    cmpq        $31, %rdx                # if (chice < 31)
    jb          .caseDefault             # go to default case, the chice is invalid

    leaq        -31(%rdx),  %r8          # Compute c = choice - 31, for fitiing the jump table
    jmp         *.switchCase(, %r8, 8)   # else switchCase[choice]

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
    subq        $32, %rsp                # allocate memory for two scanf

    movq        $scanfChar, %rdi         # load format for scanf
    leaq        (%rsp), %rsi             # set storage to address the old char
    xorq        %rax, %rax               # clear rax
    call        scanf

    movq        $scanfChar, %rdi         # load format for scanf
    leaq        16(%rsp), %rsi           # set storage to address the new char
    xorq        %rax, %rax               # clear rax
    call        scanf

    leaq        (%r12), %rdi             # first variable - pstr1
    xorq        %rsi, %rsi               # clear rsi
    movq        (%rsp), %rsi             # second variable - old char
    xorq        %rdx, %rdx               # clear rdx
    movq        16(%rsp), %rdx           # third variable - new char
    call        replaceChar
    movq        %rax, %r12               # put the update pstr1 in r12

    leaq        (%r13), %rdi             # first variable - pstr2
    xorq        %rsi, %rsi               # clear rsi
    movq        (%rsp), %rsi             # second variable - old char
    xorq        %rdx, %rdx               # clear rdx
    movq        16(%rsp), %rdx           # third variable - new char
    call        replaceChar
    movq        %rax, %r13               # put the update pstr2 in r13

    movq        $replaceCharCase, %rdi   # load format for printf
    leaq        (%rsp), %rsi             # first variable - old char
    leaq        16(%rsp), %rdx           # second variable - new char
    leaq        1(%r12), %rcx            # third variable - pstr1->str
    leaq        1(%r13), %r8             # forth variable - pstr2->str
    xorq        %rax, %rax               # clear rax
    call        printf

    addq        $32, %rsp                # dislocate memory
    jmp         .End                     # break

  .case33:                               # replaceChar
    jmp         .case32

  .case34:                               # default
    jmp         .caseDefault

  .case35:                               # pstrijcpy
    subq        $32, %rsp                # allocate memory for two scanf

    movq        $scanfInt, %rdi          # load format for scanf
    leaq        (%rsp), %rsi             # set storage to address the start's index i
    xorq        %rax, %rax               # clear rax
    call        scanf

    movq        $scanfInt, %rdi          # load format for scanf
    leaq        16(%rsp), %rsi           # set storage to address the finish's index j
    xorq        %rax, %rax               # clear rax
    call        scanf

    leaq        (%r12), %rdi             # first variable - pstr1
    leaq        (%r13), %rsi             # second variable - pstr2
    movb        (%rsp), %dl              # third variable - index i
    movb        16(%rsp), %cl            # forth variable - index j

    call        pstrijcpy
    leaq        (%rax), %rdi             # rdi = (updated)
    pushq       %rdi                     # save rdi

    xorq        %rax, %rax               # char size1 = 0
    call        pstrlen                  # size1 = pstr1->size
    movq        %rax, %rdx               # second variable - pstr1->size

    popq        %rdi                     # restore rdi
    leaq        1(%rdi), %rsi            # first variable - pstr1->str
    movq        $pstrijcpyCase, %rdi     # load format for printf
    xorq        %rax, %rax               # clear rax
    call        printf

    addq        $32, %rsp                # dislocate memory
    jmp         .End                     # break

  .case36:                               # swapCase
    call        swapCase
    movq        %rax, %rdi               # making rdi as pointer to the updating pstr1
    xorq        %rax, %rax               # char size1 = 0
    call        pstrlen                  # size1 = pstr1->size
    movq        %rax, %rsi               # first variable - pstr1->size
    leaq        1(%rdi), %rdx            # second variable - pstr1->str
    xorq        %rax, %rax               # clear rax
    movq        $swapCaseCase, %rdi      # load format for printf
    call        printf

    leaq        (%r13), %rdi             # rdi = pstr2
    call        swapCase
    movq        %rax, %rdi               # making rdi as pointer to the updating pstr2
    xorq        %rax, %rax               # char size2 = 0
    call        pstrlen                  # size2 = pstr2->size
    movq        %rax, %rsi               # first variable - pstr2->size
    leaq        1(%rdi), %rdx            # second variable - pstr2->str
    xorq        %rax, %rax               # clear rax
    movq        $swapCaseCase, %rdi      # load format for printf
    call        printf

    jmp         .End                     # break

  .case37:                               # pstrijcpy
    subq        $32, %rsp                # allocate memory for two scanf

    movq        $scanfInt, %rdi          # load format for scanf
    leaq        (%rsp), %rsi             # set storage to address the start's index i
    xorq        %rax, %rax               # clear rax
    call        scanf

    movq        $scanfInt, %rdi          # load format for scanf
    leaq        16(%rsp), %rsi           # set storage to address the finish's index j
    xorq        %rax, %rax               # clear rax
    call        scanf

    leaq        (%r12), %rdi             # first variable - pstr1
    leaq        (%r13), %rsi             # second variable - pstr2
    movq        (%rsp), %rdx             # third variable - index i
    movq        16(%rsp), %rcx           # forth variable - index j

    call        pstrijcmp                # int compare = 0
    movq        %rax, %rsi               # first variable - compare
    movq        $pstrijcmpCase, %rdi     # load format for printf
    xorq        %rax, %rax               # clear rax
    call        printf

    addq        $32, %rsp                # dislocate memory
    jmp         .End                     # break

  .caseDefault:
    movq        $defaultCase, %rdi       # load format for printf
    xorq        %rax, %rax               # clear rax
    call        printf

  .End:
    popq        %r13                     # restore r13
    popq        %r12                     # restore r12

    movq	    $0, %rax                 # return value is zero
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer
    ret             		             # return



