#!/bin/bash

nasm -f elf64 -g sort.s -o sort.o 
ld sort.o -o sort
