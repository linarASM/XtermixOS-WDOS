for compile use NASM
The code is almost from  habr.com
CMDS:
nasm -f bin core.asm -o xcore.btx
nasm -f bin coreru.asm -o xcoreru.btx



qemu-system-i386 xcore.btx -monitor stdio
