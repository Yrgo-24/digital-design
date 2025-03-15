/**
 * @brief Design of a 2-bit priority encoder.
 *
 * @param {a,b,c,d} 1-bit inputs.
 * @param {x,y}     1-bit outputs.
 *
 * @note The encoder operates like this:
 *           - a = 1               => {x,y} = {1,1}
 *           - a = 0, b = 1        => {x,y} = {1,0}
 *           - a = 0, b = 0, c = 1 => {x,y} = {0,1}
 *           - a = 0, b = 0, c = 0 => {x,y} = {0,0}
 */
module priority_encoder(input logic a, b, c, d, output logic x, y);
    assign b_n = !b;          // Assign b' = !b.
    assign x = a | b;         // Assign x = a + b.
    assign y = a & (b_n & c); // Assign y = a + b'c.
endmodule 