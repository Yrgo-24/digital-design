/**
 * @brief Implementation of an OR gate consisting of inputs {a, b} and output x.
 *
 * @param a, b Inputs.
 * @param x    Output.
*/
module or_gate(input logic a, b, output logic x);
    assign x = a | b;
endmodule
