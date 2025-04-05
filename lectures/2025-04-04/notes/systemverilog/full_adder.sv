/**
 * @brief Design of a full adder.
 *
 * @param inputs  Full adder inputs {A,B,Cin} as a vector.
 * @param outputs Full adder outputs {Cout,Sum} as a vector.
 *
 * @details The truth table of the full adder is shown below.
 *
 *       {A,B,Cin} {Cout,Sum}
 *          000        00
 *          001        01
 *          010        01
 *          011        10
 *          100        01
 *          101        10
 *          110        10
 *          111        11
 *
 * @note Cin = Carry in, Cout = Carry out.
 */
module full_adder(input logic[2:0] inputs, output logic[1:0] outputs);

    /**
     * @brief Process triggered at change of the input, i.e. change of A, B, or Cin.
     *
     *        The output is updated in accordance with the truth table.
     *        If something goes wrong, the output is cleared.
     */
    always_comb
    begin
        case (inputs)
            3'b000 : outputs <= 2'b00;
            3'b001 : outputs <= 2'b01;
            3'b010 : outputs <= 2'b01;
            3'b011 : outputs <= 2'b10;
            4'b100 : outputs <= 2'b01;
            4'b101 : outputs <= 2'b10;
            4'b110 : outputs <= 2'b10;
            4'b111 : outputs <= 2'b11;
            default: outputs <= 2'b00;
        endcase
    end

endmodule
