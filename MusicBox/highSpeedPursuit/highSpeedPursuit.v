// look in pins.pcf for all the pin names on the TinyFPGA BX board
module music (
    input CLK,    // 16MHz clock
    output USBPU,  // USB pull-up resistor
    output SPEAKER   // use beep, // output PIN_1
);
    // parameter CLKDIVIDER = 16000000/440/2;

    reg[27:0] tone;
    always @(posedge CLK) begin
        tone <= tone+1;
    end

    wire[6:0] fastsweep = (tone[22] ? tone[21:15] : ~tone[21:15]);
    wire[6:0] slowsweep = (tone[25] ? tone[24:18] : ~tone[24:18]);
    wire[14:0] clkdivider = {2'b01, (tone[27] ? slowsweep : fastsweep), 6'b000000};

    reg[14:0] counter;
    always @(posedge CLK) begin
        if(counter==0) begin
            counter <= clkdivider;
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
