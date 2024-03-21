`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ECSIOT LAB Master
// Engineer: 王俊雄
// 
// Create Date: 2024/03/20 21:58:12
// Design Name: 
// Module Name: S_LED_TOP
// Project Name: 
// Target Devices: XC7A35T-lCPG236C (BASYS-3 Board)
// Tool Versions:v1.0 
// Description: 
// 此為十位數 0~99 七段顯示器電路
// Revision:
// Revision v1.0  - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S_LED_TOP
(
    input  wire clk,
    input  wire rst,
    output reg [3:0] LED_ON_OFF,
    output reg [7:0] LED);

wire rst_n = ~rst;
//計時1秒 1/10ns = 100000000 clock = 50000000 ~clk_1s;
reg clk_1s;
reg clk_LEDHz;
reg [26:0] COUNT_1S;
reg [24:0] COUNT_LEDHZ;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        COUNT_1S   <=  'd0;
        COUNT_LEDHZ <=  'd0;
        clk_1s   <= 1'b0;
        clk_LEDHz <= 1'b0;
    end
    else
    begin
        COUNT_1S    <= (COUNT_1S    == 'd50000000)  ? 'd0 : COUNT_1S + 1'b1;
        COUNT_LEDHZ <= (COUNT_LEDHZ == 'd500000)   ? 'd0 : COUNT_LEDHZ + 1'b1;
        clk_1s      <= (COUNT_1S    == 'd50000000)  ? ~clk_1s : clk_1s;
        clk_LEDHz   <= (COUNT_LEDHZ == 'd500000)   ? ~clk_LEDHz : clk_LEDHz;
    end
end
//狀態機，用於刷新兩顆七段顯示器的開關。
localparam LED0 = 1'b0;
localparam LED1 = 1'b1;
reg LED_STA;
//定義個別的LED要顯示的數字
//                   abcdefgh  
localparam NUM0 = 8'b00000011; 
localparam NUM1 = 8'b10011111; 
localparam NUM2 = 8'b00100101;
localparam NUM3 = 8'b00001101;
localparam NUM4 = 8'b10011001;
localparam NUM5 = 8'b01001001;
localparam NUM6 = 8'b01000001;
localparam NUM7 = 8'b00011011;
localparam NUM8 = 8'b00000001;
localparam NUM9 = 8'b00001001;
always @(posedge clk_LEDHz or negedge rst_n)
begin
    if(!rst_n)
    begin
        LED_STA <= LED0;
        LED     <= 8'b11111111;
        LED_ON_OFF <= 4'b1111;
    end
    else
    begin
    case (LED_STA)
    LED0 :
    begin
        LED_ON_OFF <= 4'b1110;
        LED  <= (LED_COUNT0 == 'd0) ? NUM0 :
                (LED_COUNT0 == 'd1) ? NUM1 :
                (LED_COUNT0 == 'd2) ? NUM2 :
                (LED_COUNT0 == 'd3) ? NUM3 :
                (LED_COUNT0 == 'd4) ? NUM4 :
                (LED_COUNT0 == 'd5) ? NUM5 :
                (LED_COUNT0 == 'd6) ? NUM6 :
                (LED_COUNT0 == 'd7) ? NUM7 :
                (LED_COUNT0 == 'd8) ? NUM8 :
                (LED_COUNT0 == 'd9) ? NUM9 : 'd0;
        LED_STA <= LED1;
    end
    LED1 :
    begin
        LED_ON_OFF <= 4'b1101;
        LED  <= (LED_COUNT1 == 'd0) ? NUM0 :
                (LED_COUNT1 == 'd1) ? NUM1 :
                (LED_COUNT1 == 'd2) ? NUM2 :
                (LED_COUNT1 == 'd3) ? NUM3 :
                (LED_COUNT1 == 'd4) ? NUM4 :
                (LED_COUNT1 == 'd5) ? NUM5 :
                (LED_COUNT1 == 'd6) ? NUM6 :
                (LED_COUNT1 == 'd7) ? NUM7 :
                (LED_COUNT1 == 'd8) ? NUM8 :
                (LED_COUNT1 == 'd9) ? NUM9 : 'd0;
        LED_STA <= LED0;
    end
    default:
    begin
        LED_STA <= LED0;
        LED     <= 8'b11111111;
        LED_ON_OFF <= 4'b1111;
    end
    endcase
    end

end
//十進制
reg [3:0] LED_COUNT0; //個位數
reg [3:0] LED_COUNT1; //十位數
always @(posedge clk_1s or negedge rst_n)
begin
    if(!rst_n)
    begin
        LED_COUNT0 <= 'd0;
        LED_COUNT1 <= 'd0;
    end
    else
    begin
        LED_COUNT0 <= (LED_COUNT0 == 'd9) ? 'd0 : LED_COUNT0 + 1'b1;
        LED_COUNT1 <= (LED_COUNT0 == 'd9 && LED_COUNT1 == 'd9) ? 'd0 : (LED_COUNT0 == 'd9) ? LED_COUNT1 + 1'b1 : LED_COUNT1;
    end
end

endmodule
