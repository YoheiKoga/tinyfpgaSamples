// look in pins.pcf for all the pin names on the TinyFPGA BX board
module music (
    input CLK,    // 16MHz clock
    output USBPU,  // USB pull-up resistor
    output SPEAKER   // use beep, // output PIN_1
);
    parameter CLKDIVIDER = 16000000/440/2;

    reg[23:0] tone;
    always @(posedge CLK) begin
        tone <= tone+1;
    end

    reg[14:0] counter;
    always @(posedge CLK) begin
        if(counter==0) begin
            counter <= (tone[23] ? CLKDIVIDER-1 : CLKDIVIDER/2-1);
        end
        else begin
            counter <= counter-1;
        end
    end

    reg SPEAKER;
    always @(posedge CLK) begin
        if(counter==0) begin
            SPEAKER <= ~SPEAKER;
        end
    end 

endmodule
