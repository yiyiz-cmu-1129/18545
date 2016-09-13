//This is a hex 3-state inverter buffer seprate 2 bit and 4 bit section
//I used the pin layouts because it would make more sense
//e1_b is pin1 and e2_b is pin15
module ls368a(pin3, pin5, pin7, pin9, pin11, pin13,
            e1_b, pin2, pin4, pin6, pin10, pin12, pin14, e2_b);
    output logic pin3, pin5, pin7, pin9, pin11, pin13;
    input logic e1_b, pin2, pin4, pin6, pin10, pin12, pin14, e2_b;

    assign pin3 = (e1_b) ? 1'bz : ~pin2;
    assign pin5 = (e1_b) ? 1'bz : ~pin4;
    assign pin7 = (e1_b) ? 1'bz : ~pin6;
    assign pin9 = (e1_b) ? 1'bz : ~pin10;
    assign pin11 = (e2_b) ? 1'bz : ~pin12;
    assign pin13 = (e2_b) ? 1'bz : ~pin14;

endmodule

