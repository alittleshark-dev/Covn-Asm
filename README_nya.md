# Fool-Covn (Asm Edition)Moew~

这是一个只会卷积的笨蛋喵
连激活函数都没有喵
也不可以学习捏

# 这样用喵

```cat_bash
git clone https://github.com/alittleshark-dev/Covn-Asm.git
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

*Copyright © 2026 alittleshark-dev, Nya*
