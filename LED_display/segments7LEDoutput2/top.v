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
    // drive USB pull-up resistor to '0' to disable USB
    // assign USBPU = 0;

    // light the leds to display '2'
    assign {segA, segB, segC, segD, segE, segF, segG, segDP} = 8'b11011010;

endmodule
