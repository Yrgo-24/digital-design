/**
 * @brief Implementation of a counter with a selectable max count value.
 *
 * @tparam MAX_COUNT The max count value of the counter.
 *
 * @param clock      50 MHz system clock.
 * @param reset_s2_n Asynchronous active-low reset signal.
 * @param enable     Enable signal for the counter ('1' = enabled).
 * @param elapsed    Indicates that the timer has elapsed.
 */
module counter 
    #(int unsigned MAX_COUNT)
    (input logic clock, reset_s2_n, enable,
     output logic elapsed);

    /** Counter bit width. */
    localparam COUNTER_WIDTH = $clog2(MAX_COUNT);

    /** Counter value. */
    logic [COUNTER_WIDTH-1:0] count = 0;

    /**
     * @brief Increment the counter on rising edge of the system clock, provided that the counter
     *        is enabled. Clear the timer on system reset. Set elapsed to '1' when the counter
     *        has reached MAX_COUNT, then wrap around the counter.
     */
    always_ff @ (posedge clock or negedge reset_s2_n)
    begin
        if (!reset_s2_n) begin
            count   <= 0;
            elapsed <= 0; 
        end 
        else begin
            if (enable) begin
                if ((MAX_COUNT - 1) == count) begin
                    count   <= 0;
                    elapsed <= 1;
                end 
                else begin
                    count   <= count + 1;
                    elapsed <= 0;
                end
            end
            else begin 
                elapsed <= 0; 
            end
        end
    end
endmodule
