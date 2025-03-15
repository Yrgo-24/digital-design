/**
 * @brief Test bench for the `priority_encoder´ module.
 *
 *        Each combination of inputs {a,b,c,d} is tested one at a time, each combination for 10 ns. 
 *        For this reason, the total simulation time is 160 ns.
 */
module priority_encoder_tb();

    logic[3:0] abcd; // Signal representation of {a,b,c,d}.
    logic[1:0] xy;   // Signal representation of {x,y}.

    /**
     * @brief Create instance of the `priority_encoder` module for testing.
     *       Ports {a,b,c,d} and {x,y} are connected to signals abcd and xy in the test bench.
     *
     * @note Regarding the port map:
     *          - abcd(3) is connected to a.
     *          - abcd(2) is connected to b.
     *          - abcd(1) is connected to c.
     *          - abcd(0) is connected to d.
     *          - xy(1) is connected to x.
     *          - xy(0) is connected to y. 
     */
    priority_encoder priority_encoder1(abcd[3], abcd[2], abcd[1], abcd[0], xy[1], xy[0]);
   
    /**
     * @brief Try each combination {0,0,0,0} - {1,1,1,1} of inputs {a,b,c,d} via the connected 
     *        signal abcd. Each combination is tested during 10 ns. The outputs {x,y} will be 
     *        displayed via connected signal xy.
     */
    initial
    begin: sim_process
        for (int i = 0; i < 16; ++i) // Try each combination 0 - 15.
        begin
            abcd = i;                // Assign current combination to abcd.
            #10ns;                   // Keep combination for 10 ns.
        end
    end
endmodule 