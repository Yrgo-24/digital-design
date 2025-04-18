/*******************************************************************************
 * @brief Test bench for the display module. Each combination 0000 - 1111 of
 *        the number to display is tested during 10 ns, hence the simulation
 *        time is 160 ns.
 *
 *        The correlation between the input number and the binary code
 *        displayed on the corrected hex display is shown below:
 *
 *        -------------------
 *        | input |  code   |
 *        |-----------------|
 *        | 0000  | 1000000 |
 *        | 0001  | 1111001 |
 *        | 0010  | 0100100 |
 *        | 0011  | 0110000 |
 *        | 0100  | 0011001 |
 *        | 0101  | 0010010 |
 *        | 0110  | 0000010 |
 *        | 0111  | 1111000 |
 *        | 1000  | 0000000 |
 *        | 1001  | 0010000 |
 *        | 1010  | 0001000 |
 *        | 1011  | 0000011 |
 *        | 1100  | 1000110 |
 *        | 1101  | 0100001 |
 *        | 1110  | 0000110 |
 *        | 1111  | 0001110 |
 *        | other | 0000000 |
 *        -------------------
 ******************************************************************************/
module display_tb();

    /*******************************************************************************
     * @brief Signals used to test the display module.    
     ******************************************************************************/
     logic[3:0] number = 4'b0;
     logic[6:0] hex    = 7'b0;
     
     /*******************************************************************************
      * @brief Creates an instance of the display module and connects signals with
      *        the same name as the corresponding ports for simulation.
      ******************************************************************************/
     display sim_instance(number, hex);
     
     /*******************************************************************************
      * @brief Tests each combination of the inputs during 10 ns each.   
      ******************************************************************************/
     initial
     begin: sim_process
         for (int i = 0; i < 16; ++i)
         begin
             number = i;
             #10ns;
         end
     end
     
endmodule 