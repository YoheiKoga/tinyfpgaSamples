// look in pins.pcf for all the pin names on the TinyFPGA BX board
module music (
    input CLK,    // 16MHz clock
    output USBPU,  // USB pull-up resistor
    output SPEAKER   // use beep, // output PIN_1
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    // first create a 16bit binary counter
    reg[15:0] counter;
    always @(posedge CLK) begin
        if(counter==56817) begin
            counter <= 0;
        end
        else begin
            counter <= counter+1;
        end
    end

    // tinyFPGA BX is 16MHz, so build 16MHz clocked 16bit free running counter
    // 16000000/65536 = 244Hz
    // and use the most significant bit(MSB) of the counter to drive the SPEAKER
    assign SPEAKER = counter[15];
endmodule
