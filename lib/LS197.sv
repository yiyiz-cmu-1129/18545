//This is a 2 and 8 bit counter
//cp0 and cp1 are clocks
//Q is 4 bit output where bit 0 is the counter mod 2 and 3-1 are mod 8
//P is input

module ls197(Q, P, pl_b, mr_b, cp0_b, cp1_b);
output logic [3:0] Q;
input logic [3:0] P;
input logic pl_b, mr_b, cp0_b, cp1_b;

    logic pl, mr, cp0, cp1, pl_mr;
    logic [3:0] Qc;
    always_comb begin
        pl = ~pl_b;
        mr = ~mr_b;
        cp0 = ~cp0_b;
        cp1 = ~cp1_b;
        pl_mr = pl | mr;
        //async logic;
        if(mr) Q = 4'b0000;
        else if(pl) Q = P;
        else Q = Qc;
        
        
    end
    //This is q0 output
    always_ff @(posedge cp0, posedge mr) begin
        if(mr) Qc[0] <= 1'b0;
        else if(pl) Qc[0] <= P[0];
        else Qc[0] <= ~Q[0];
    end
    //this is q3-1 output
    always_ff @(posedge cp1, posedge mr) begin
        if(mr) Qc[3:1] <= 3'b000;
        else if(pl) Qc[3:1] <= P[3:1];
        else Qc[3:1] <= Q[3:1] + 3'd1;
    end
        
endmodule

