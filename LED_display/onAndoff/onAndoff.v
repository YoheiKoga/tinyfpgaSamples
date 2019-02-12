// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    // create a binary counter
    reg[31:0] cnt;
    always @(posedge CLK) cnt <= cnt+1;

    // blink the LED at a few Hz (using the 23th bit of the counter, use a different bit to modify the blinking rate)
    assign LED = cnt[23];
endmodule
