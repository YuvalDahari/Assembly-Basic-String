# Pstring Library Functions in Assembly
This project implements a set of library functions in assembly language to handle Pstring structures, representing strings along with their lengths, similar to C's string.h functions.

## Features
- Implements various string manipulation functions for Pstring.
- Menu-driven program to perform different operations on Pstring structures.
- Error handling for invalid inputs.

## Files Included
### run_main.s
Contains the run_main function:
- Receives two strings and their lengths from the user.
- Constructs two Pstring structures.
- Sends the strings and a menu option to func_run.
### s.pstring.s
Contains implementations of the following library functions:
- **pstrlen**: Calculates the length of a Pstring.
- **replaceChar**: Replaces occurrences of a character with another character in a Pstring.
- **pstrijcpy**: Copies a substring from one Pstring to another based on given indices.
- **swapCase**: Converts uppercase English letters to lowercase and vice versa in a Pstring.
- **pstrijcmp**: Compares substrings of two Pstrings lexicographically.
### s.select_func.s
Contains the implementation of func_run:
- Reads the menu option received as an argument.
- Uses a case-switch (table jump) to call the appropriate library function.

## Additional Files
### h.pstring
Contains the declarations of the necessary functions.
### makefile
Creates a runtime executable for the program.
### c.main.c
Implementation of the main function in C, which calls run_main.
### c.test-main_run.c 
Implementation of the run_main function in C for testing purposes.
### test-makefile
A makefile that compiles the program with test cases.

## Implementation Details:
- **Memory Layout**: Each Pstring is stored in the stack frame of main_run. The length precedes the character array, ensuring easy access and manipulation.
- **Input Handling**: User inputs strings' lengths and characters, ensuring no null characters are received and terminating strings correctly.
- **Input Handling**: User inputs strings' lengths and characters, ensuring no null characters are received and terminating strings correctly.
- **Functionality**: Functions handle operations such as length calculation, character replacement, substring copying, case conversion, and lexicographical comparison.
- **Error Handling**: Functions validate input indices and provide appropriate error messages if indices exceed string bounds.

## Usage
To compile and run the program, use the provided makefile:
```shell
make
./run_main
```
Ensure all assembly files are properly linked and compiled before execution. The program interacts with the user to perform operations on Pstring structures based on selected menu options.
