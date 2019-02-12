// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    input[3:0] PWM_input,
    output USBPU  // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    reg[4:0] PWM;
    always @(posedge CLK) PWM <= PWM[3:0] + PWM_input;

    assign LED=PWM[4];
endmodule
