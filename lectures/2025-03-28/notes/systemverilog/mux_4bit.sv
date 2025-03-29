/**
 * @brief Design of a 4-bit (more commonly known as '4-to-1') multiplexer.
 *
 * @param abcd Multiplexer inputs connected to SW[3:0].
 * @param sel  Selector bits connected to SW[5:4].
 * @param x    Multiplexer output connected to LEDR[0].
 *
 * @note The multiplexer operates as follows:
 *            - x = d if sel = 00
 *            - x = c if sel = 01
 *            - x = b if sel = 10
 *            - x = a if sel = 11
 *            - x = 0 if something goes wrong.
 */
module mux_4bit(input logic[3:0] abcd, input logic[1:0] sel, output logic x);

    /**
     * @brief Update the multiplexer output in accordance with the functional
     *        description above whenever the inputs 'abcd' and/or the selector
     *        signals 'sel' change.
     */
    always_comb
    begin
        case (sel)
            0      : x <= abcd[0];
            1      : x <= abcd[1];
            2      : x <= abcd[2];
            3      : x <= abcd[3];
            default: x <= 0;
        endcase
    end
    
    /** @note The process above is used to demonstrate the case statement in SystemVerilog.
     *        Due to the simplicity of the circuit, the entire process can be replaced 
     *        with a simple assignment:
     *
     *        x <= abcd[sel];
     */
    
endmodule 