//This is a 4 bit counter
//q is the count
//p is the number to insert
//cp is the clock
module ls163a(q, tc, p, sr_b, pe_b, cet, cep, cp);
output logic [3:0] q;
output logic tc;
input logic [3:0] p;
input logic sr_b, pe_b, cet, cep, cp;
    
    logic [3:0] count;
    logic count_en;
    assign count_en = cep & cet & ~pe_b;
    assign tc = cet & count[3] & count[2] & count[1] & count[0];
    assign q = count;
    always_ff @(posedge cp) begin
        if(sr_b) count <= 4'b0000;
        else if(pe_b) count <= p;
        else if(count_en) count <= count + 4'b0001;
        else count <= count;
    end


endmodule

