/*******************************************************************************
 * @brief Component for displaying a hexadecimal digit 0 - F on a hex display.
 *
 * @param number The number to display (in 4-bit binary form).
 * @param hex    Hex display used for displaying the corresponding digit.
 ******************************************************************************/
module display(input logic[3:0] number,
               output logic[6:0] hex);
               
    /*******************************************************************************
     * @brief Binary codes for displaying digits 0x0 - 0xF on hex displays. 
     ******************************************************************************/
    const logic[6:0] DISPLAY_0   = 7'b1000000;
    const logic[6:0] DISPLAY_1   = 7'b1111001;
    const logic[6:0] DISPLAY_2   = 7'b0100100;
    const logic[6:0] DISPLAY_3   = 7'b0110000;
    const logic[6:0] DISPLAY_4   = 7'b0011001;
    const logic[6:0] DISPLAY_5   = 7'b0010010;
    const logic[6:0] DISPLAY_6   = 7'b0000010;
    const logic[6:0] DISPLAY_7   = 7'b1111000;
    const logic[6:0] DISPLAY_8   = 7'b0000000;
    const logic[6:0] DISPLAY_9   = 7'b0010000;
    const logic[6:0] DISPLAY_A   = 7'b0001000;
    const logic[6:0] DISPLAY_B   = 7'b0000011;
    const logic[6:0] DISPLAY_C   = 7'b1000110;
    const logic[6:0] DISPLAY_D   = 7'b0100001;
    const logic[6:0] DISPLAY_E   = 7'b0000110;
    const logic[6:0] DISPLAY_F   = 7'b0001110;
    const logic[6:0] DISPLAY_OFF = 7'b1111111;
    
    /*******************************************************************************
     * @brief Sets the binary code of the hex display depending on the input number.
     *        This process is run at every change of the input number. 
     ******************************************************************************/
    always_comb
    begin: output_process
        case (number)
            4'b0000: hex <= DISPLAY_0;
            4'b0001: hex <= DISPLAY_1;
            4'b0010: hex <= DISPLAY_2;
            4'b0011: hex <= DISPLAY_3;
            4'b0100: hex <= DISPLAY_4;
            4'b0101: hex <= DISPLAY_5;
            4'b0110: hex <= DISPLAY_6;
            4'b0111: hex <= DISPLAY_7;
            4'b1000: hex <= DISPLAY_8;
            4'b1001: hex <= DISPLAY_9;
            4'b1010: hex <= DISPLAY_A;
            4'b1011: hex <= DISPLAY_B;
            4'b1100: hex <= DISPLAY_C;
            4'b1101: hex <= DISPLAY_D;
            4'b1110: hex <= DISPLAY_E;
            4'b1111: hex <= DISPLAY_F;
            default: hex <= DISPLAY_OFF;
        endcase
    end
endmodule 