# covn-asm
> 卷积运算 汇编版
这是一个汇编写的卷积运算，是的他就只做卷积运算，不会有任何输出
只能用gdb来查看内存来看输出

# 怎么用?

```bash
git clone https://www.github.com/alittleshark-dev/Covn-Asm.git
cd Covn-Asm
nasm -f elf64 cnn.asm -o cnn.o
ld cnn.o -o cnn
gdb cnn
```

```gdb
b window
run
c
x/4dw &feature_map
```

*Copyright © 2026 alittleshark-dev*
