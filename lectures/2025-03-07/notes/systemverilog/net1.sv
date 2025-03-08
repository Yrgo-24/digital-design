/**
 * @brief Design of a small circuit consisting of inputs {a, b, c, d} and 
 *        outputs {x, y, z}.
 *
 *        Equations:
 *            * x = a ^ b
 *            * y = d
 *            * z = cd + b'd'
 *
 * @param {a, b, c, d} One-bit inputs.
 * @param {x, y, z}    One-bit outputs.
 */
module net1(input logic a, b, c, d, output logic x, y, z);      
    assign b_n = !b;                  // b_n = b'
    assign d_n = !d;                  // d_n = d'
    
    assign x = a ^ b;                 // x = a ^ b
    assign y = d;                     // y = d
    assign z = (c & d) | (b_n & d_n); // z = cd + b'd'
endmodule 