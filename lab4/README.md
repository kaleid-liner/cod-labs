# Lab4 存储器和显示控制器

## 逻辑设计 & 核心代码

### VGA-DCU

首先需要搞清楚 VGA 的信号应该以怎样的标准进行传输。这个通过 ppt 和一些[学习资料](<https://ktln2.org/2018/01/23/implementing-vga-in-verilog/>)可以了解。

VGA 是按行主序一行一行的输送颜色数据，颜色数据的格式为 RGB 的12位数字。特别需要注意的是行同步和列同步信号。在每行的数据输送完后，需要发送行同步信号，同时行同步信号前后应该留下一定的时钟周期数。同样的，所有的列发送完后（即一帧），需要发送列同步信号。这些具体的参数在 ppt 中也有。有了这些信息，写 VGA-DCU 就相对比较容易了：

首先通过 `localparam` 定义一些参数（其中一些也可以定义为 `parameter` 来实现复用。

```verilog
localparam BORDER_TOP = 172,
           BORDER_BOTTOM = 427,
           BORDER_LEFT = 272,
           BORDER_RIGHT = 527;
           
localparam WIDTH = 800,
           HEIGHT = 600;
           
localparam HSPW = 120,
           HBP = 64,
           HFP = 56,
           VSPW = 6,
           VBP = 23,
           VFP = 37;
           
localparam HTICK = 1040,
           VTICK = 666;
```

然后，在 50mhz 的时钟里，递增 `hc` 和 `vc` 的值：

```verilog
always @(posedge clk_50mhz) begin
    if (hc == HTICK - 1) begin
        hc <= 0;
        if (vc == VTICK - 1) begin
            vc <= 0;
        end else begin
            vc <= vc + 1;
        end
    end else begin
        hc <= hc + 1;
    end
end
```

之后，只需要在固定的时间内，分别输送 `hs` 和 `vs` 的值：

```verilog
assign hs = ~((hc >= HSBEG) && (hc < HSEND));
assign vs = ~((vc >= VSBEG) && (vc < VSEND));
```

并且通过当前的 `hc` 和 `vc` 的值，计算应该显示的数据的地址：

```verilog
assign vaddr = hcbeg + vcbeg * 256;
```

最后，在当前的 xy 位置绘制一个十字标记，并且将中心区域以外的部分绘制为全黑色。

```verilog
assign vrgb = ((hcbeg == x) && (vcbeg == y))
           || ((hcbeg == x - 1) && (vcbeg == y))
           || ((hcbeg == x + 1) && (vcbeg == y))
           || ((hcbeg == x) && (vcbeg == y - 1))
           || ((hcbeg == x) && (vcbeg == y + 1))
           || (hc < BORDER_LEFT) || (hc > BORDER_RIGHT)
           || (vc < BORDER_TOP) || (vc > BORDER_BOTTOM)
           ? 0 : vdata;
```

### Drawpad-PCU

之后是实现画板的控制逻辑。

```verilog
always @ (posedge clk_50mhz) begin
    if (rst) begin
        we <= 1;
        paddr <= paddr + 1;
        pdata <= 12'hFFF;
        x <= 127;
        y <= 127;
    end else begin
        we <= draw;
        paddr <= x + y * 256;
        pdata <= rgb;
        x <= x + right - left;
        y <= y + down - up;
    end
end
```

当 reset 时，将指针设定到中央，并且不停的扫描存储器中的所有数据，用来将所有颜色清空为白色，这种 reset 方式就足够了，因为你按下按钮的时间在 50 mhz 的频率下肯定能清空完了。不是在 reset 时，则根据当前的移动信号移动指针，并且根据 xy 计算应该显示数据的地址和颜色。根据 `draw` 设定存储器的 `we`。

之后，则是上下左右的移动逻辑：

```verilog
debouncer btn_dwn (
    .clk_50mhz(clk_50mhz),
    .button(dir[3]),
    .btn_down(down)
);

debouncer btn_up (
    .clk_50mhz(clk_50mhz),
    .button(dir[0]),
    .btn_down(up)
);

debouncer btn_rgt (
    .clk_50mhz(clk_50mhz),
    .button(dir[2]),
    .btn_down(right)
);

debouncer btn_lft (
    .clk_50mhz(clk_50mhz),
    .button(dir[1]),
    .btn_down(left)
);
    
```

`debouncer` 是我写的一个模块，它能将连续的信号转化为不连续的信号，从而避免在频率很高的时钟下指针飞速移动。同时它还能判断当你连续按下一段时间的按钮后，以固定频率产生位移的信号。这样，就能把用户的四个按钮转化为上下左右四个信号，用来移动指针。

### top

之后就是将以上的两个模块加上存储器连接在一起：

```verilog
vga DCU (
    .clk_50mhz(clk_50mhz),
    .vdata(vdata),
    .x(x),
    .y(y),
    .hs(hs),
    .vs(vs),
    .vrgb(vrgb),
    .vaddr(vaddr)
);

dist_mem_gen_0 VRAM (
    .dpra(vaddr),
    .dpo(vdata),
    .clk(clk_50mhz),
    .a(paddr),
    .d(pdata),
    .we(we)
);

drawpad PCU (
    .rgb(rgb),
    .dir(dir),
    .draw(draw),
    .x(x),
    .y(y),
    .clk_50mhz(clk_50mhz),
    .rst(rst),
    .paddr(paddr),
    .pdata(pdata),
    .we(we)
);
```

如上，VRAM 同步写的地址和数据来自于 drawpad ，异步读的地址来自于 vga ，读出的数据输送到 vga ，写使能来自于 drawpad ，vga 的输出信号则直接输送到顶端模块，即板子上的 vga 接口中。

## 完整代码

### top.v

```verilog
module top(
    input clk_100mhz,
    input [11:0] rgb,
    input [3:0] dir,
    input draw,
    input rst,
    output [11:0] vrgb,
    output hs,
    output vs
    );
    
    wire [15:0] vaddr;
    wire [11:0] vdata;
    
    wire [7:0] x, y;
    
    wire we;
    wire [15:0] paddr;
    wire [11:0] pdata;
    
    wire clk_50mhz;
    clk_wiz_0 _clk_wiz_0 (
        .clk_in1(clk_100mhz),
        .clk_out1(clk_50mhz)
    );
    
    vga DCU (
        .clk_50mhz(clk_50mhz),
        .vdata(vdata),
        .x(x),
        .y(y),
        .hs(hs),
        .vs(vs),
        .vrgb(vrgb),
        .vaddr(vaddr)
    );
    
    dist_mem_gen_0 VRAM (
        .dpra(vaddr),
        .dpo(vdata),
        .clk(clk_50mhz),
        .a(paddr),
        .d(pdata),
        .we(we)
    );
    
    drawpad PCU (
        .rgb(rgb),
        .dir(dir),
        .draw(draw),
        .x(x),
        .y(y),
        .clk_50mhz(clk_50mhz),
        .rst(rst),
        .paddr(paddr),
        .pdata(pdata),
        .we(we)
    );
    
endmodule
```

### drawpad.v

```verilog
module drawpad(
    input [11:0] rgb,
    input [3:0] dir,
    input draw,
    input clk_50mhz,
    input rst,
    output reg [15:0] paddr,
    output reg [11:0] pdata,
    output reg we,
    output reg [7:0] x,
    output reg [7:0] y
    );
    
    wire left, right, down, up;
    
    always @ (posedge clk_50mhz) begin
        if (rst) begin
            we <= 1;
            paddr <= paddr + 1;
            pdata <= 12'hFFF;
            x <= 127;
            y <= 127;
        end else begin
            we <= draw;
            paddr <= x + y * 256;
            pdata <= rgb;
            x <= x + right - left;
            y <= y + down - up;
        end
    end

    debouncer btn_dwn (
        .clk_50mhz(clk_50mhz),
        .button(dir[3]),
        .btn_down(down)
    );
    
    debouncer btn_up (
        .clk_50mhz(clk_50mhz),
        .button(dir[0]),
        .btn_down(up)
    );
    
    debouncer btn_rgt (
        .clk_50mhz(clk_50mhz),
        .button(dir[2]),
        .btn_down(right)
    );
    
    debouncer btn_lft (
        .clk_50mhz(clk_50mhz),
        .button(dir[1]),
        .btn_down(left)
    );
        
    
endmodule
```

### vga.v

```verilog
module vga(
    input clk_50mhz,
    input [11:0] vdata,
    input [7:0] x,
    input [7:0] y,
    output [11:0] vrgb,
    output [15:0] vaddr,
    output hs,
    output vs
    );
    
    localparam BORDER_TOP = 172,
               BORDER_BOTTOM = 427,
               BORDER_LEFT = 272,
               BORDER_RIGHT = 527;
               
    localparam WIDTH = 800,
               HEIGHT = 600;
               
    localparam HSPW = 120,
               HBP = 64,
               HFP = 56,
               VSPW = 6,
               VBP = 23,
               VFP = 37;
               
    localparam HTICK = 1040,
               VTICK = 666;
               
    reg [10:0] hc;
    reg [9:0] vc;
            
    always @(posedge clk_50mhz) begin
        if (hc == HTICK - 1) begin
            hc <= 0;
            if (vc == VTICK - 1) begin
                vc <= 0;
            end else begin
                vc <= vc + 1;
            end
        end else begin
            hc <= hc + 1;
        end
    end
    
    localparam HSBEG = WIDTH + HFP,
               HSEND = WIDTH + HFP + HSPW,
               VSBEG = HEIGHT + VFP,
               VSEND = HEIGHT + VFP + VSPW;
    
    assign hs = ~((hc >= HSBEG) && (hc < HSEND));
    assign vs = ~((vc >= VSBEG) && (vc < VSEND));
                      
    wire [15:0] hcbeg = hc - BORDER_LEFT;
    wire [15:0] vcbeg = vc - BORDER_TOP;
    assign vaddr = hcbeg + vcbeg * 256;
    
    assign vrgb = ((hcbeg == x) && (vcbeg == y))
               || ((hcbeg == x - 1) && (vcbeg == y))
               || ((hcbeg == x + 1) && (vcbeg == y))
               || ((hcbeg == x) && (vcbeg == y - 1))
               || ((hcbeg == x) && (vcbeg == y + 1))
               || (hc < BORDER_LEFT) || (hc > BORDER_RIGHT)
               || (vc < BORDER_TOP) || (vc > BORDER_BOTTOM)
               ? 0 : vdata;
    
endmodule
```

### debouncer.v

```verilog
module debouncer(
    input clk_50mhz,
    input button,
    output btn_down
    );
    reg [22:0] count;
    reg [24:0] enter_hold_cnt;
    reg [21:0] hold_cnt;
    
    reg cur_button;
    // is button pressed or released in last cycle
    reg prev_button;
    
    assign btn_down = ((~prev_button) & cur_button) | (button & (hold_cnt == 0));
    
    initial 
    begin
        count = 0;
        prev_button = 0;
        enter_hold_cnt = 0;
        hold_cnt = 0;
    end
    
    always @ (posedge clk_50mhz) begin
        prev_button <= cur_button;
    end
    
    always @ (posedge clk_50mhz) begin
        if (count >= 23'd49999) begin
            count <= 0;
            cur_button <= button;
        end 
        else count <= count + 1;
    end
    
    always @ (posedge clk_50mhz) begin
        if (button) begin
            if (enter_hold_cnt >= 25'd25000000) begin
                hold_cnt <= hold_cnt + 1;
            end else begin
                enter_hold_cnt <= enter_hold_cnt + 1;
            end
        end else begin
            enter_hold_cnt <= 0;
        end
    
    end
    
endmodule
```

## 仿真 & 结果分析

None

## 下载结果

由于手上没有 vga 显示屏，在给助教检查后只留了一张图片：

![1556375927766](assets/1556375927766.png)

看起来有些奇怪，因为刷新频率较低，手机比人眼更强。

虽然只有一张图片，但可以看出我的画面还是很稳定的，同时能够斜向画，指针通过十字标记了出来。所有功能都完成了，详见助教的分数记录。

## 实验总结

通过这次实验，我进一步了解了数据通路，了解了 vga 显示屏的工作原理，学会了如何通过 fpga 控制 vga 显示屏显示数据，并且学会了使用存储器。