/**
 * @brief Test bench for the 'net1' module.
 *
 *        Each combination {0, 0, 0, 0} - {1, 1, 1, 1} of inputs {a, b, c, d}
 *        is tested, each combination for 10 ns. Hence the total simulation 
 *        time is 160 ns.
 */
module net1_tb();

   /**
    * @brief Signals used for the simulation. The signals are connected to ports
    *        {a, b, c, d} and {x, y, z} of the 'net1' module as described below:
    *
    *            * abcd(3) is connected to a.
    *            * abcd(2) is connected to b.
    *            * abcd(1) is connected to c.
    *            * abcd(0) is connected to d.
    *            * xyz(2) is connected to x.
    *            * xyz(1) is connected to y.
    *            * xyz(0) is connected to z.
    */
    logic[3:0] abcd;
    logic[2:0] xyz;

    /**
     * @brief Create an instance of the 'or_gate' module for simulation.
     *        The signals abcd and xyz are connected to ports {a, b, c, d} and
     *        {x, y, z} as described above via ordered port mapping. 
     */
    net1 test(abcd[3], abcd[2], abcd[1], abcd[0], xyz[2], xyz[1], xyz[0]);
        
    /**
     * @brief Try each combination {0, 0, 0, 0} - {1, 1, 1, 1} of inputs {a, b, c, d}, 
     *        each for 10 ns.
     *
     *        A for loop is used, where the number 'i' ranges from 0 - 15. 
     *        This value is assigned to signal abcd, which is connected to the ports 
     *        of the same name in the 'net1' module. After 10 ns, the next combination 
     *        is tested.
     */
    initial
    begin: sim_process
        for (int i = 0; i < 16; ++i) // Try each combination 0 - 15.
        begin
            abcd = i;                // Assign current combination to {a, b, c, d}.
            #10ns;                   // Keep combination for 10 ns.
        end
    end
endmodule 