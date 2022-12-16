#Yuval Dahari 209125939

.section .rodata
    strFormat:      .string "%s"         # format for string input & output
    numFormat:      .string "%d"         # format for int input & output

	########
.section .text

.globl	run_main
	.type	main, @function
run_main:
    movq        %rsp, %rbp               # create the new frame pointer
    pushq       %rbp                     # save the old frame pointer
    movq        %rsp, %rbp               # create the new frame pointer
    
    # We should notice, that we will push to the stack two pstring which is 256 bytes for each, and another number for
    # the user choise. Scanf function requires that (%rsp) will be in 16 jumps, so we assign 256*2+16 = 528 bytes.
    subq        $528, %rsp 
    
    # scanf n1
    movq        $numFormat, %rdi         # load format for int
    leaq        (%rsp), %rsi             # set storage to address of n1
    xorq        %rax, %rax               # clear rax
    call        scanf
    xorq        %rax, %rax               # clear rax
    movb        %sil, (%rsp)             # put n1 in the stack (n1 < 255 so it's requires only one byte)
    
    # scanf str1
    xorq        %rdi, %rdi               # clear rdi
    xorq        %rsi, %rsi               # clear rsi
    movq        $strFormat, %rdi         # load format for string
    leaq        1(%rsp), %rsi            # set storage to address of str1
    xorq        %rax, %rax               # clear rax
    call        scanf
    xorq        %rax, %rax               # clear rax
   # movq        %rsi, 1(%rsp)            # set storage to address of str1
    
    # scanf n2
    movq        $numFormat, %rdi         # load format for int
    leaq        256(%rsp), %rsi          # set storage to address of n2
    xorq        %rax, %rax               # clear rax
    call        scanf
    xorq        %rax, %rax               # clear rax
   # movb        %sil, 256(%rsp)          # put n2 in the stack (n2 < 255 so it's requires only one byte)

    # scanf str2
    xorq        %rdi, %rdi               # clear rdi
    xorq        %rsi, %rsi               # clear rsi
    movq        $strFormat, %rdi         # load format for string
    leaq        257(%rsp), %rsi          # set storage to address of str2
    xorq        %rax, %rax               # clear rax
    call        scanf
    xorq        %rax, %rax               # clear rax
   # movq        %rsi, 257(%rsp)          # set storage to address of str2
    
    # scanf choice
    movq        $numFormat, %rdi         # load format for int
    leaq        512(%rsp), %rsi          # set storage to address of choice
    xorq        %rax, %rax               # clear rax
    call        scanf
    xorq        %rax, %rax               # clear rax
   # movq        %rsi, 512(%rsp)          # put choice in the stack
    
    # assigning variables for run_func
    xorq        %rdi, %rdi               # clear rdi
    xorq        %rsi, %rsi               # clear rsi
    xorq        %rdx, %rdx               # clear rdx
    leaq        (%rsp), %rdi             # first variable - &str1
    leaq        256(%rsp), %rsi          # second variable - &str2
    movq        512(%rsp), %rdx          # third variable - choice
    call        run_func

    movq	    $0, %rax                 # return value is zero
    movq	    %rbp, %rsp               # restore the old stack pointer - release all used memory
    popq	    %rbp                     # restore old frame pointer
    ret             		             # return
    
    