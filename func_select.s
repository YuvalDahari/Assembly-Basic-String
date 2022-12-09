#Yuval Dahari 209125939

.section .data
n1:              .int                 # int length

.section .rodata
strFormat:      .string "%s"
numFormat:      .string "%d"


	########
	.text	#the beginnig of the code
.globl	func_select	#the label "main" is used to state the initial point of this program
	.type	main, @function	# the label "main" representing the beginning of a function
func_select:
    movq        %rsp, %rbp              # create the new frame pointer
    pushq       %rbp                    # save the old frame pointer
    movq        %rsp, %rbp              # create the new frame pointer

    subq        $528, %rsp

    movq        $numFormat, %rdi        # load format for int
    leaq        (%rsp), %rsi            # set storage to address of n1
    xorq        %rax, %rax              # clear rax
    call scanf
    movb        %sil, (%rsp)            # put n1 in the stack (n1 < 255 so it's requires only one byte)

    xorq        %rdi, %rdi              # clear rdi
    xorq        %rsi, %rsi              # clear rsi
    movq        $strFormat, %rdi        # load format for string
    leaq        1(%rsp), %rsi           # set storage to address of str1
    xorq        %rax, %rax              # clear rax
    call scanf
    movq        %rsi, 1(%rsp)           # set storage to address of str1

    movq        $numFormat, %rdi        # load format string
    xorq        %rsi, %rsi              # clear rsi
    movb        (%rsp), %sil            # set storage to address of n1
    xorq        %rax, %rax              # clear rax
    call printf

    xorq        %rdi, %rdi              # clear rdi
    movq        $strFormat, %rdi
    xorq        %rsi, %rsi
    leaq        1(%rsp), %rsi
    movq        (%rsi), %rsi
    xorq        %rax, %rax
    call printf

    movq	 $0, %rax                # return value is zero
    movq	 %rbp, %rsp              # restore the old stack pointer - release all used memory.
    popq	 %rbp                    # restore old frame pointer
    ret             		          # return
