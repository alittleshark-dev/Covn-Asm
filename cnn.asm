;                 File: ./cnn.asm
;        Copyright © alittleshark-dev 2026
;               Licensed under the 
;                   MIT License
;             See for details /LICENSE
section .bss
    feature_map resd OUT_ROWS * OUT_COLS

section .data
    neknel db  1,  1,  1
           db  0,  0,  0
           db -1, -1, -1
    nek_len equ $ - neknel

    ; 一根横线
    A db 0, 0, 0, 0
      db 1, 1, 1, 1
      db 0, 0, 0, 0
      db 0, 0, 0, 0
    A_len equ $ - A
    A_ROWS equ 4
    A_COLS equ 4
    OUT_ROWS equ A_ROWS - 3 + 1
    OUT_COLS equ A_COLS - 3 + 1

section .text
    global _start

_start:
    ; 滑动窗口
    mov r15, 0 ; x, 滑动行
    mov rdx, 0 ; y, 滑动列

    call window

    mov rax, 60
    syscall

window:
    ; 滑动起来
    ; 如果r15 > OUT_ROS就
    cmp r15, OUT_ROWS
    jge initr15
    
    cmp rdx, OUT_COLS
    jge win_done

    ; 调用 conv 来实现矩阵乘法
    mov r13, 0 ; x, 行
    mov r14, 0 ; y, 列
    mov r12, 0 ; r12 返回值
    call conv
    ; 力竭写索引了所以复制了
    ; [r15][rdx] = r15 * 3 + rdx
    ; rax = r15 * 3
    mov rax, r15
    mov rcx, OUT_COLS
    imul rax, rcx

    ; rax = r13 + r14
    add rax, rdx
    ; ecx = feature_map[rax]
    mov [feature_map + rax * 4], r12d
    inc r15
    jmp window

win_done:
    ret

initr15:
    mov r15, 0
    inc rdx
    jmp window

conv:
    ; if r13 >= 3? return 0; : r13++
    cmp r13, 3
    jge conv_done

    ; if r14 >= 3? r14++; conv()
    cmp r14, 3
    jge initr14

    ; r12 += neknel[r13][r14] * A[r13 + r15][r14 + rdx]
    ; [r13][r14] = r13 * 3 + r14
    ; rax = r13 * 3
    mov rax, r13
    mov rcx, 3
    imul rax, rcx
    ; rax = r13 + r14
    add rax, r14
    ; ecx = neknel[rax]
    movsx r9d, byte [neknel + rax]

    ; 处理A[r13 + r15][r14 + rdx]
    ; 展开得到(r13 + r15) * 3 + (r14 + rdx)
    ; rax = r13 + r15
    ; rax前面被覆盖这里再次写入
    mov rax, r13
    add rax, r15
    
    ; rcx = r14 + rdx
    mov rcx, r14
    add rcx, rdx

    ; rax * 3 + rcx
    ; rax = rax * 3
    mov r8, A_COLS
    imul rax, r8

    ; rax = rax + rcx
    add rax, rcx
    ; A[rax]
    movzx r10d, byte [A + rax]

    imul r9d, r10d

    add r12d, r9d

    inc r14

    ; 跳回开头
    jmp conv

conv_done:
    ret

initr14:
    mov r14, 0
    inc r13
    jmp conv
