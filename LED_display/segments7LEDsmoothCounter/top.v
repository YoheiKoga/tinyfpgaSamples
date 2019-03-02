// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    // output LED,   // User/boot LED next to power LED
    // output USBPU  // USB pull-up resistor
    output segA,
    output segB, 
    output segC, 
    output segD, 
    output segE, 
    output segF, 
    output segG, 
    output segDP
);

    // cnt is used as a prescalar
    reg[23:0] cnt;
    always @(posedge CLK) cnt <= cnt+24'h1;
    wire cntovf = &cnt;

    // BCD is a counter that counts from 0 to 9
    reg [3:0] BCD_new, BCD_old;
    always @(posedge CLK) if(cntovf) BCD_new <= (BCD_new==4'h9 ? 4'h0 : BCD_new + 4'h1);
    always @(posedge CLK) if(cntovf) BCD_old <= BCD_new;

    reg[4:0] PWM;
    wire[3:0] PWM_input = cnt[22:19];
    always @(posedge CLK) PWM <= PWM[3:0] + PWM_input;
    wire [3:0] BCD = (cnt[23] | PWM[4]) ? BCD_new : BCD_old;



    reg[7:0] SevenSeg;
    always @(*) begin
        case(BCD) 
            4'h0: SevenSeg = 8'b11111100;
            4'h1: SevenSeg = 8'b01100000;
            4'h2: SevenSeg = 8'b11011010;
            4'h3: SevenSeg = 8'b11110010;
            4'h4: SevenSeg = 8'b01100110;
            4'h5: SevenSeg = 8'b10110110;
            4'h6: SevenSeg = 8'b10111110;
            4'h7: SevenSeg = 8'b11100000;
            4'h8: SevenSeg = 8'b11111110;
            4'h9: SevenSeg = 8'b11110110;
            default: SevenSeg = 8'b00000000;
        endcase
    end

    assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;

endmodule
