# Yuval Dahari 209125939

.section .rodata
    error:  .string "invalid input!\n"   # format for invalid input

	########
.section .text

.globl	pstrlen
.type	pstrlen, @function	             # The function returns the length of pstring.
# char pstrlen(Pstring* pstr)
# pstr in %rdi
pstrlen:
    xorq        %rax, %rax               # char size = 0
    movb        (%rdi), %al              # size = pstr->size
    ret                                  # return size

.globl	replaceChar
.type	replaceChar, @function	         # The function return pointer to pstring after changing all the
                                         # the oldChar to the newChar.
# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
# pstr in %rdi, oldChar in %sil, newChar in %dl
replaceChar:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %rbx                     # rbx is a callee save

    leaq        (%rdi), %rbx             # char* temp = pstr->str
    xorq        %rax, %rax               # char size = 0
    call        pstrlen                  # size = pstr->size

    xorq        %rcx, %rcx               # int i = 0

  .ReaplaceLoop:
    incq        %rcx                     # i++
    incq        %rbx                     # move to the next char
    cmpq        %rcx, %rax               # while(i <= size)
    jb          .EndReaplaceLoop         # break

  .IfEqual:
    cmpb        (%rbx), %sil             # if (temp[i] == oldChar)
    jne         .ReaplaceLoop

  .Reaplace:
    movb        %dl, (%rbx)              # temp[i] = newChar
    jmp         .ReaplaceLoop            # continue

  .EndReaplaceLoop:
    movq        %rdi, %rax               # updating return value

    # Releasing and restoring the stack and rgisters memory
    popq        %rbx                     # restore rbx
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer

    ret                                  # return the updated pstr

.globl	pstrijcpy
.type	pstrijcpy, @function	         # The function gets two pointers to Pstring, copys the substring
                                         # src[i:j] (including) into dst[i:j] (including) and returns the
                                         # pointer to dst.
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
# dst in %rdi, src in %rsi, i in %dl, j in %cl
pstrijcpy:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %r12                     # r12 is a callee save
    pushq       %r13                     # r13 is a callee save
    pushq       %r14                     # register for the swap
    xorq        %r14, %r14               # clear r14
    pushq       %r15                     # register for the return value
    pushq       %rsi                     # saving rsi in the stack for restoring in case of prinf
    pushq       %rdi                     # saving rdi in the stack for restoring in case of prinf

    leaq        1(%rdi), %r12            # char* temp1 = src->str
    leaq        1(%rsi), %r13            # char* temp2 = dst->str

    # Varify input
    cmpb        %cl, %dl                 # if (i > j)
    ja          .CopyFail                # print("invalid input!\n")
    cmpb        $0, %dl                  # if (i < 0)
    jb          .CopyFail                # print("invalid input!\n")

    # Checking the boundaries
    xorq        %rax, %rax               # char dstSize = 0
    call        pstrlen                  # dstSize = dst->size
    cmpb        %cl, %al                 # if (j > dstSize)
    jle         .CopyFail                # print("invalid input!\n")

    pushq       %rdi                     # save rdi
    xorq        %rax, %rax               # char srcSize = 0
    movq        %rsi, %rdi               # initialize rsi to rdi, for implements pstrlen()
    call        pstrlen                  # srcSize = src->size
    cmpb        %cl, %al                 # if (j > srcSize)
    popq        %rdi                     # restore rdi
    jle        .CopyFail                 # print("invalid input!\n")

    xorq        %r8, %r8                 # int k = 0

  .InitializeForCpy:
    cmpb        %dl, %r8b                # if (k < i)
    je          .CopyLoop                # break
    incb        %r8b                     # k++
    incq        %r12
    incq        %r13
    jmp         .InitializeForCpy        # continue

  .CopyLoop:
    cmpb        %cl, %dl                 # if (i != j)
    je          .EndCopyLoop             # break

  .Copy:
    movb        (%r13), %r14b            # temp = src[i]
    movb        %r14b, (%r12)            # dst[i] = temp

    incb        %dl                      # i++
    incq        %r12
    incq        %r13
    jmp         .CopyLoop                # continue

  .EndCopyLoop:
    movq        %rdi, %r15               # put the updating dst in r15
    popq        %rdi                     # restore rdi
    popq        %rsi                     # restore rsi
    jmp         .EndCopy

  .CopyFail:
    movq        $error, %rdi             # load format string
    xorq        %rax, %rax               # clear rax
    call        printf
    xorq        %rax, %rax               # clear rax
    popq        %rdi                     # restore rdi
    popq        %rsi                     # restore rsi
    movq        %rdi, %r15               # making rax (the return value) as pointer to the dst
    jmp         .EndCpyFunction          # done

  .EndCopy:
    movb        (%r13), %r14b            # temp = src[i]
    movb        %r14b, (%r12)            # dst[i] = temp

  .EndCpyFunction:
    movq        %r15, %rax               # making rax (the return value) as pointer to the updating dst
    popq        %r15                     # restore r15
    popq        %r14                     # restore r14
    popq        %r13                     # restore r12
    popq        %r12                     # restore r13
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer

    ret                                  # return the updated dst

.globl	swapCase
.type	swapCase, @function	             # The function gets a pointer and changing any upper case to lower case
                                         # and changing any lower case to upper case' the function doesn't
                                         # effects special characters.
# Pstring* swapCase(Pstring* pstr)
# pstr in %rdi
swapCase:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %rbx                     # rbx is a callee save

    leaq        1(%rdi), %rbx            # char* temp = pstr->str
    xorq        %rax, %rax               # char size = 0
    call        pstrlen                  # size = pstr->size
    pushq       %r12                     # r12 is a callee save
    xorq        %r12, %r12               # clear r12, because 'size' is only one byte
    movq        %rax, %r12               # r12 = size

    xorq        %rcx, %rcx               # int i = 0
    movq        $1, %rcx                 # i = 1

  .SwapLoop:
    cmpq        %rcx, %r12               # while(i <= size)
    jb          .EndSwapLoop             # break

  .UpperCase:
    cmpb        $90, (%rbx)              # if (pstr->str[i - 1] > 90)
    ja          .LowerCase               # go to lower case checking
    cmpb        $65, (%rbx)              # if (pstr->str[i - 1] < 65)
    jb          .Continue                # special character

    addq        $32, (%rbx)              # change to lower case
    jmp         .Continue

  .LowerCase:
    # if we got here so - pstr->str[i - 1] > 90

    cmpb        $122, (%rbx)             # if (pstr->str[i - 1] > 122)
    ja          .Continue                # special character
    cmpb        $97, (%rbx)              # if (pstr->str[i - 1] < 97)
    jb          .Continue                # special character

    subq        $32, (%rbx)              # change to upper case
    jmp         .Continue

  .Continue:
    incq        %rcx                     # i++
    incq        %rbx
    jmp         .SwapLoop                # continue

  .EndSwapLoop:
    movq        %rdi, %rax               # making rax (the return value) as pointer to the updating dst
    popq        %rbx                     # restore rbx
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer

    ret                                  # return the updated pstr

.globl	pstrijcmp
.type	pstrijcmp, @function	         # The function gets two pointers to Pstring, and compers lexicographic
                                         # pstr2->str1[i:j] and pstr2->str[i:j].
                                         # The function returns:
                                         # if pstr2->str1[i:j] > pstr2->str[i:j] =>  1
                                         # if pstr2->str1[i:j] < pstr2->str[i:j] => -1
                                         # if pstr2->str1[i:j] = pstr2->str[i:j] =>  0
                                         # if i or j are invalid                 => -2
# int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)
# pstr1 in %rdi, pstr2 in %rsi, i in %dl, j in %cl
pstrijcmp:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %r12                     # r12 is a callee save
    pushq       %r13                     # r13 is a callee save
    xorq        %r8, %r8                 # clear r8, register for the compare

    leaq        1(%rdi), %r12            # char* temp1 = src->str
    leaq        1(%rsi), %r13            # char* temp2 = dst->str

    # Varify input
    cmpb        %cl, %dl                 # if (i >= j)
    ja          .ComperFail              # print("invalid input!\n") & return -2
    cmpb        $0, %dl                  # if (i < 0)
    jb          .ComperFail              # print("invalid input!\n") & return -2

    # Checking the boundaries
    xorq        %rax, %rax               # char size1 = 0
    call        pstrlen                  # size1 = pstr1->size
    cmpb        %cl, %al                 # if (size1 < j)
    jle         .ComperFail              # print("invalid input!\n") & return -2

    pushq       %rdi                     # save rdi
    xorq        %rax, %rax               # char size2 = 0
    movq        %rsi, %rdi               # initialize rsi to rdi, for implements pstrlen()
    call        pstrlen                  # size2 = pstr2->size
    cmpb        %cl, %al                 # if (size2 < j)
    popq        %rdi                     # restore rdi
    jle        .ComperFail               # print("invalid input!\n") & return -2

    xorq        %r8, %r8                 # int k = 0

  .InitializeForCmp:
    cmpb        %dl, %r8b                # if (k < i)
    je          .ComperLoop              # break
    incb        %r8b                     # k++
    incq        %r12
    incq        %r13
    jmp         .InitializeForCmp        # continue

  .ComperLoop:
    cmpb        %cl, %dl                 # if (i != j)
    je          .EndComperLoop           # break

  .Comper:
    movb        (%r12), %r14b            # temp = dst[i]
    cmpb        %r14b, (%r13)            # comper (temp (dst[i]) & src[i])

    ja          .MINUS1                  # src[i] > dst[i]
    jb          .PLUS1                   # src[i] < dst[i]

    incb        %dl                      # i++
    incq        %r12
    incq        %r13

    jmp         .ComperLoop              # continue

  .MINUS1:
    movq        $-1, %rax                # set compare value as -1
    jmp         .EndComper

  .PLUS1:
    movq        $1, %rax                 # set compare value as 1
    jmp         .EndComper

  .EndComperLoop:
    movb        (%r12), %r14b            # temp = dst[i]
    cmpb        %r14b, (%r13)            # comper (temp (dst[i]) & src[i])

    ja          .MINUS1                  # src[i] > dst[i]
    jb          .PLUS1                   # src[i] < dst[i]
    movq        $0, %rax                 # set compare value as 0
    jmp         .EndComper

  .ComperFail:
    movq        $error, %rdi             # load format string
    xorq        %rax, %rax               # clear rax
    call        printf

    movq        $-2, %rax                # set compare value as -2

  .EndComper:
    popq        %r13                     # restore r13
    popq        %r12                     # restore r12
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer

    ret                                  # return compare's value








