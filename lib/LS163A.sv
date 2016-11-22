//This is a 4 bit counter
//q is the count
//p is the number to insert
//cp is the clock
module ls163a(q, tc, p, sr_b, pe_b, cet, cep, cp);
    output logic [3:0] q;
    output logic tc;
    input logic [3:0] p;
    input logic sr_b, pe_b, cet, cep, cp;
    
    logic count_en;
    assign count_en = cep & cet & pe_b;
    assign tc = cet & q == 4'b1111;
    always_ff @(posedge cp) begin
        if(~sr_b) q <= 4'b0000;
        else if(~pe_b) q <= p;
        else if(count_en) q <= q + 4'b0001;
    end


endmodule

