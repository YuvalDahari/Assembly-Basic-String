#Yuval Dahari 209125939

.section .rodata
    error:  .string "invalid input!\n"   # format for invalid input

	########
.section .text

.globl	pstrlen
.type	pstrlen, @function	             # The function returns the length of pstring.
# char pstrlen(Pstrin* pstr)
# pstr in %rdi
pstrlen:
    xorq        %rax, %rax               # char size = 0
    movb        (%dil), %al              # size = pstr->size
    ret                                  # return size

.globl	replaceChar
.type	pstrlen, @function	             # The function return pointer to pstring after changing all the
                                         # the oldChar to the newChar.
# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
# pstr in %rdi, oldChar in %sil, newChar in %dl
pstrlen:
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %rbx                     # rbx is a callee save

    leaq        1(%rdi), %rbx            # char* temp = pstr->string
    xorq        %rax, %rax               # char size = 0
    call        pstrlen                  # size = pstr->size
    pushq       %r12                     # r12 is a callee save
    xorq        %r12, %r12               # clear r13, because 'size' is only one byte
    movq        %rax, %r12               # r12 = size;

    xorq        %rcx, %rcx               # int i = 0
    movq        $1, %rcx                 # i = 1

  .WhileLoop:
    cmpq        %rcx, %r12               # while(i <= size)
    jg          .EndLoop

  .IfEqual:
    cmpb        (%rbx), %sil             # if (temp[i] == oldChar)
    jg          .Swap

  .Swap:
    movb        %dl, (%rbx)              # temp[i] = newChar
    addq        $1, (%rcx)               # i++
    leaq        1(%rbx), %rbx            # move to the next char
    jmp         .WhileLoop

  .EndLoop:
    movq        %rdi, %rax               # updating return value

    # Releasing and restoring the stack and rgisters memory
    movq        -8(%rbp), %rbx           # restore rbx
    movq        -16(%rbp), %r12          # restore r12
    pop         %r12                     # restore rbx
    pop         %rbx                     # restore r12
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer

    ret                                  # return the updated pstr

.globl	pstrijcpy
.type	pstrlen, @function	             # The function gets two pointers to Pstring, copys the substring
                                         # src[i:j] (including) into dst[i:j] (including) and returns the
                                         # pointer to dst.
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
# dst in %rdi, src in %rsi, i in %dl, j in %cl
pstrijcpy:




