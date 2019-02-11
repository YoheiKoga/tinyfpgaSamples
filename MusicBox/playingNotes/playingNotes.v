// look in pins.pcf for all the pin names on the TinyFPGA BX board
module music (
    input CLK,    // 16MHz clock
    // output USBPU,  // USB pull-up resistor
    output SPEAKER   // use beep, // output PIN_1
);
    // parameter CLKDIVIDER = 16000000/440/2;

    reg[27:0] tone;
    always @(posedge CLK) begin
        tone <= tone+1;
    end

    wire[5:0] fullnote = tone[27:22];

    wire[2:0] octave;
    wire[3:0] note;
    divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

    reg[8:0] clkdivider;
    always @(note) begin
        case(note)
            0: clkdivider = 512-1; //A
            1: clkdivider = 483-1; //A#/Bb
            2: clkdivider = 456-1; //B
            3: clkdivider = 431-1; //C
            4: clkdivider = 406-1; //C#/Db
            5: clkdivider = 384-1; //D
            6: clkdivider = 362-1; //D#/Eb
            7: clkdivider = 342-1; //E
            8: clkdivider = 323-1; //F
            9: clkdivider = 304-1; //F#/Gb
            10: clkdivider = 287-1; //G
            11: clkdivider = 271-1; //G#/Ab
            12: clkdivider = 0; // sould never happen
            13: clkdivider = 0; // sould never happen
            14: clkdivider = 0; // sould never happen
            15: clkdivider = 0; // sould never happen
        endcase
    end

    reg[8:0] counter_note;
    always @(posedge CLK) begin
        if(counter_note==0) begin
            counter_note <= clkdivider;
        end
        else begin
            counter_note <= counter_note-1;
        end
    end

    reg[7:0] counter_octave;
    always @(posedge CLK) begin
        if(counter_note==0) begin
            if(counter_octave==0) begin
                counter_octave <= (octave==0?255 : octave==1?127 : octave==2?63 : octave==3?31 : octave==4?15:7);
            end
            else begin
                counter_octave <= counter_octave-1;
            end
        end
    end

    reg SPEAKER;
    always @(posedge CLK) begin
        if(counter_note==0 && counter_octave==0) begin
            SPEAKER <= ~SPEAKER;
        end
    end
endmodule
