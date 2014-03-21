module top (
);

    logic [1:0] a;
    logic [1:0] b;
    logic sel;
    logic [1:0] x;
 
    mux m0(
        .a(a0),
        .b(b0),
        .sel,
        .x(x0)
    );

    mux m1(
        .a(a1),
        .b(b1),
        .sel,
        .x(x1)
    );

endmodule

module mux(
    input [1:0] a,
    input b,
    input sel,
    output x,
);

    logic a_term;
    logic b_term;

    assign a_term =  sel && a;
    assign b_term = ~sel && b;

    assign x = a_term || b_term;

endmodule
