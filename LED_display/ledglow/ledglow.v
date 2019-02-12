// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    reg[23:0] cnt;
    always @(posedge CLK) begin
        cnt <= cnt+1;
    end

    wire[3:0] PWM_input = cnt[23] ? cnt[22:19] : ~cnt[22:19];
    reg[4:0] PWM;
    always @(posedge CLK) begin
        PWM <= PWM[3:0] + PWM_input;
    end

    assign LED = PWM[4];
endmodule
