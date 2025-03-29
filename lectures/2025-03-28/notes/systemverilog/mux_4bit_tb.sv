/**
 * @brief Test bench for the 'mux_4bit' module.
 */
module mux_4bit_tb();

   /**
    * @brief Signals used to connect to the ports of the 'mux_4bit' module.
    */
   logic[3:0] abcd;
   logic[1:0] sel;
   logic x;

    /**
     * @brief Create instance of the 'mux_4bit' module for simulation. The signals
     *        declared above are connected to the corresponding ports.
     */
     mux_4bit mux_4bit1(abcd, sel, x);
      
    /**
     * @brief Try each combination {00}-{11} of selector signals 'sel' for each
     *        combination {0000}-{1111} of inputs 'abcd', each for 10 ns.
     *
     * @note Nested for loops are utilized for this test:
     *           - The outer loop is used to assign each combination of 'sel'. 
     *           - The inner loop is used to assign each combination of 'abcd' while 
     *             using the current 'sel' combination (assigned in the outer loop).
     */
     initial
     begin: simulation
         for (int i = 0; i < 4; ++i)
         begin
             sel <= i;
             for (int j = 0; j < 16; ++j)
             begin
                 abcd <= j;
                 #10ns;
             end
         end
     end

endmodule 