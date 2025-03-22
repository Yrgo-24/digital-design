/**
 * @brief Design of a 4-bit comparator.
 *
 * @param {a,b,c,d} 1-bit inputs.
 * @param {x,y,z}     1-bit outputs.
 *
 * @note The comparator operates like this:
 *           - {a,b} > {c,d} => {x,y,z} = {1,0,0}
 *           - {a,b} = {c,d} => {x,y,z} = {0,1,0}
 *           - {a,b} < {c,d} => {x,y,z} = {0,0,1}
 */
module comparator_4bit(input logic a, b, c, d, output logic x, y, z);

    // Assign a', b', c' and d' to the corresponding signals.
    assign a_n = !a, b_n = !b, c_n = !c, d_n = !d;
    
    // Assign x = ac' + bc'd' + abd'.
    assign x = (a & c_n) | (b & c_n & d_n) | (a & b & d_n);
    
    // Assign y = (a ^ c)' * (b ^ d)'.
    assign y = (a ^~ c) & (b ^~ d);
    
    // Assign z = a'c + a'b'd + b'cd.
    assign z = (a_n & c) | (a_n & b_n & d) | (b_n & c & d);

endmodule 