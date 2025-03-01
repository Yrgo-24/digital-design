/**
 * @brief Test bench for the 'or_gate' module.
 */
module or_gate_tb();

    // Signals used for simulation.
    logic a = 0, b = 0, x = 0; 

    // Create an instance of the 'or_gate' module for simulation.
    // Signals a, b, and x are connected to the ports of the same name.
    or_gate or_gate1(a, b, x);
    
    // Try each combination {00 - 11} of inputs {a, b}, each for 10 ns.
    initial 
    begin : simulation
        for (int i = 0; i < 4; ++i) 
        begin
            {a, b} = i; // Assign current combination to {a, b}.
            #10ns;      // Keep current combination for 10 ns.
        end
    end
endmodule
