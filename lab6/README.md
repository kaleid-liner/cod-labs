# Lab6 综合实验

## 逻辑设计 & 核心代码

### CPU 改进

#### `SLL` 指令

我的代码中有一些左移操作，故需要我实现 `SLL` 指令。SLL 既不与 I 类指令一致，也不与 R 类指令一致。所以需要添加新的状态，并修改控制信号。如下是 SLL 指令的格式：

```
Syntax: sll $d, $t, h
Encoding: 0000 00ss ssst tttt dddd dhhh hh00 0000
```

需要增加 `ALUSrca` 的位数，并修改 `alu_srca` MUX 的连接方式：

```verilog
assign alu_srca = (sig_alu_srca == 0) ? pc :
                  (sig_alu_srca == 1) ? rda:
                                        ir[10:6];
```

其中 `ir[10:6]` 为 `h` .

#### 中断和异常

我主要改进 CPU 的地方是实现了中断与异常，并实现了 `syscall` 和 `eret` 指令。利用 `syscall` 来实现软件中断。 

首先实现了硬件中断。通过：

```verilog
int_ctrl _int_ctrl (
    .eint(eint),
    .intr(intr),
    .if_int(if_int),
    .int_vec(int_vec)
);
```

内部实现了 `intr` 的排队及硬件中断向量的输出。

同时 CPU 增加新的状态 `SInt` 。在每次一条指令执行完后，会查询是否有异常或中断，并进入异常处理例程。中断隐指令包括设置 `epc`，即记录异常发生时的 pc 值。并设置 `cause`，表示中断发生的原因。例如外部中断/硬件中断(0)、syscall 引起的软件中断(8)。

`eret` 指令则会将 `pc` 设成 `pc` 的值。通过阅读一个 MIPS 异常实现的文档，我仿照其做法将 `epc` 存在 14 号寄存器，并将 `cause` 存在 13 号寄存器。因此可以通过 `push` 和 `pop` 的软件方法实现异常和中断的嵌套。

另一方面，需要添加 `syscall` 的状态：`SSysMem`, `SSysEx` 以及 `eret` 的状态：`SEEx` 。Syscall 需要 4 个周期的执行，需要读取 `$v0` 的值、设置 syscall 的异常向量、设置 epc 和 cause。eret 需要 3 个周期，只需要将 `pc` 的值设成 `epc` 的值。

根据约定俗成的方法，我将 `$v0` 设为存取异常终端号的寄存器，因此一个常规调用 `syscall` 的代码是这样的：

```assembly
addi, $v0, $zero, 1
syscall
```

并在中断服务例程的最后：

```assembly
eret
```

 在改进了 CPU 后，我的控制信号通过扩展变成了这些（其中一些的位数增加了）：

```verilog
wire [1:0] sig_reg_dst;
wire sig_reg_w;
wire [1:0] sig_alu_srca;
wire [1:0] sig_alu_srcb;
wire [2:0] sig_pc_src;
wire sig_pc_wcond;
wire sig_pc_wncond;
wire sig_pc_w;
wire sig_IorD;
wire sig_mem_r; // perhaps i won't use this
wire sig_mem_w;
wire [1:0] sig_reg_src;
wire sig_ir_w;
wire [`ALU_OP_BITS-1:0] sig_alu_op;
wire sig_eint_w;
wire sig_except_w;
```

### 总线 & 内存映射

对每个设备，通过驱动程序进行抽象，向总线主要提供几个端口：

- `addr`: 地址
- `din`: 写入数据
- `dout`: 读出数据
- `we`: 写使能

对每个设备，通过判断内存是否在某个范围内来设置 `we` 和总线的 `dout`。

```verilog
// memory: 0x000 ~ 0xFFF
// 4096 byts, 1024 double words
wire select_mem;
wire mem_we;
wire [`BITS-1:0] mem_dout;
// vga: 0x10000 ~ 0x13FFF
// x: 0x20000
// y: 0x20001
// each element 12 bits
wire select_vga;
wire vram_we;
wire xy_we;
wire [`BITS-1:0] vga_dout;
// button: 0x1000 ~ 0x1001
// 0x1000: readonly
// 0x1001: one bit flag
wire select_key;
wire key_we;
wire [`BITS-1:0] key_dout;
// rgb: 0x2000
wire select_rgb;
wire [`BITS-1:0] rgb_dout;
```

如上，我有 4 个设备，内存，vga，按键，rgb。并都映射到了某个地址范围内。其中 `select_mem` 等是通过判断内存的是否在范围内来设置的。总线的 `dout` 则是：

```verilog
assign dout = ({`BITS{select_mem}} & mem_dout) 
            | ({`BITS{select_key}} & key_dout)
            | ({`BITS{select_vga}} & vga_dout)
            | ({`BITS{select_rgb}} & rgb_dout);
```

通过总线和内存映射之后，通过 cpu 的 `lw` 和 `sw` 指令能和外围设备通信。例如需要在 vga 上显示数据时，在 vga 对应的内存地址通过：

```assembly
sw $t0, ($t1)
```

设置其值即可。其中，`$t0` 存 rgb 值，`$t1` 指向对应 vram 的地址。

## CPU 应用：画图程序

此程序会根据你连续两次定下的点，以此两点为顶点，在屏幕中描绘一个矩形，此矩形的颜色通过 switch 输入。

### 输入中断服务程序

首先，我写了一个输入的服务程序，进入点放在内存中地址为 4 的地方。

```assembly
j _syscall_0
```

此例程的作用是从键盘读取一个值：

```assembly
_syscall_0:
# key data
_key_poll:
lw $v0, 0x1001($zero)
beq $v0, $zero, _key_poll
lw $v0, 0x1000($zero)
sw $zero, 0x1001($zero)
eret
```

它通过轮询的方式，判断键盘的 ready bit 是否就绪，如果就绪，就从数据地址处读取上一次输入的值的编码，并将 ready bit 置为 0 表示已经处理完了该此输入。之后通过 eret 返回。

### 输入处理

通过上面的中断服务例程，从键盘中读取一个值的代码就为：

```assembly
addi $s1, $zero, 1 # up
addi $s2, $zero, 2 # down
addi $s3, $zero, 3 # left
addi $s4, $zero, 4 # right
addi $s5, $zero, 5 # enter

addi $v0, $zero, 1
syscall
bne $v0, $s1, key_down
lw $a0, ($t2)
addi $a0, $a0, -1
sw $a0, ($t2)
j key_end
```

将 v0 设成 1，调用 1 号系统调用（即为上面的例程），通过 v0 返回，之后判断输入的是哪个值，并据此执行代码。例如移动指针或顶下端点。第一此按下 enter 箭，会存下当前这个点的 x、y 坐标，并设置一个 flag 表示已经按下一个点了。如果再确定下一个点，那么就会在这两个点之间画出矩形。

### 画图

定出两个顶点之后，首先对两个顶点的 x、y 进行排序：

```assembly
slt $k0, $a0, $gp
bne $k0, $zero, no_x_swap
addi $k0, $a0, 0
addi $a0, $gp, 0
addi $gp, $k0, 0
no_x_swap:
slt, $k0, $a1, $sp
bne $k0, $zero, no_y_swap
addi $k0, $a1, 0
addi $a1, $sp, 0
addi $sp, $k0, 0
no_y_swap:
```

这样就能确定画矩形的上下左右界。

之后通过一个两层循环绘图：

```assembly
addi $k0, $a0, 0
draw_outer_loop:
addi $k1, $a1, 0
	
draw_inner_loop:

	sll $s7, $k1, 7
	add $s7, $s7, $k0
	add $s7, $s7, $t0
	sw $a2, ($s7)
	
	addi $k1, $k1, 1
	bne $k1, $sp, draw_inner_loop

addi $k0, $k0, 1
bne $k0, $gp, draw_outer_loop
```

遍历整个矩形，将每个地址设成 rgb 的值。

## 下载 & 结果分析

由于在实验室给助教检查的时候没有拍照，并且我自己也没有 vga 显示屏，所以没有可用的下载图片。

## 实验总结

通过这次实验，我通过 cpu 实现了一个高级功能。详细了解了异常和中断，并实现了一个基础的外部中断和软件异常功能。

## 完整代码

完整代码见同一压缩包中的其它文件。或 [Github 仓库](<https://github.com/kaleid-liner/cod-labs/tree/master/lab6>)。