/**
 * @brief Test bench for the 'full_adder' module.
 *
 *        Each combination {0,0,0} - {1,1,1} of inputs {A,B,Cin} is tested, 
 *        each for 10 ns. Hence the total simulation time is 80 ns. 
 */
module full_adder_tb();

    /**
     * @brief Signals used for the simulation. These signals represent the ports
     *        of the 'full_adder' module and will be displayed in ModelSim.
     */
    logic[2:0] inputs;
    logic[1:0] outputs;

    /**
     * @brief Create a full adder named 'full_adder1'. The signals above are 
     *        connected to the associated ports via port mapping.
     */
    full_adder full_adder1(inputs, outputs);
        
    /**
     * @brief Run each combination {0,0,0} - {1,1,1} of inputs {A,B,Cin} via a loop.
     *        Each combination is tested for 10 ns. 
     */
    initial
    begin
        for (int i = 0; i < 8; ++i)
        begin
            inputs <= i;
            #10ns;
        end
    end

endmodule
