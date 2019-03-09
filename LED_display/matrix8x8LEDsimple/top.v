// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    // output LED,   // User/boot LED next to power LED
    // output USBPU  // USB pull-up resistor
    output PIN_1,
    output PIN_2, 
    output PIN_3, 
    output PIN_4, 
    output PIN_5, 
    output PIN_6, 
    output PIN_7, 
    output PIN_8
);

    // cnt is used as a prescalar
    reg[20:0] cnt;
    always @(posedge CLK) cnt <= cnt+21'h1;
    wire cntovf = &cnt;

    // BCD is a counter that counts from 0 to 9
    reg [3:0] BCD;
    always @(posedge CLK) if(cntovf) BCD <= (BCD==4'h9 ? 4'h0 : BCD+4'h1);

    reg[7:0] MatrixSeg;
    always @(*) begin
        case(BCD) 
            4'h0: MatrixSeg = 8'b10000000;
            4'h1: MatrixSeg = 8'b01000000;
            4'h2: MatrixSeg = 8'b00100000;
            4'h3: MatrixSeg = 8'b00010000;
            4'h4: MatrixSeg = 8'b00001000;
            4'h5: MatrixSeg = 8'b00000100;
            4'h6: MatrixSeg = 8'b00000010;
            4'h7: MatrixSeg = 8'b00000001;
            4'h8: MatrixSeg = 8'b00000000;
            4'h9: MatrixSeg = 8'b11111111;
            default: MatrixSeg = 8'b00000000;
        endcase
    end

    assign {PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8} = MatrixSeg;

endmodule
