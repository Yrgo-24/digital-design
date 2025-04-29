/*******************************************************************************
 * @brief Module for synchronizing input signals to prevent metatability.
 *        Each input signal (expect the system clock) is synchronized via
 *        two flip flops. Event detection is implemented for the connected
 *        button in order to detect pressdown (falling down).
 *
 * @param clock[in]              50 MHz system clock.
 * @param reset_n[in]            Inverting reset connected to a push button.
 * @param button_n[in]           Inverting push button.
 * @param reset_s2_n[out]        Synchronized inverting reset signal.
 * @param button_pressed_s2[out] Synchronized signal indicating pressdown
 *                               of button_n (falling edge).
 ******************************************************************************/
module meta_prev(input logic clock, reset_n, button_n,
                 output logic reset_s2_n, button_pressed_s2);

    /*******************************************************************************
     * @brief Signals used to generate flip flops for the input signals.
     ******************************************************************************/
    logic reset_s1_n = 1;
    logic button_s1_n = 1, button_s2_n = 1, button_s3_n = 1;
     
    /*******************************************************************************
     * @brief Synchronizes the reset signals at rising edge of the system clock.
     *        All reset signals are immediately cleared upon system reset.
     ******************************************************************************/
    always_ff @ (posedge clock or negedge reset_n)
    begin: RESET_PROCESS
        if (!reset_n) begin
            reset_s1_n <= 0;
            reset_s2_n <= 0;
        end
        else begin
            reset_s1_n <= 1;
            reset_s2_n <= reset_s1_n;
        end
    end
     
    /*******************************************************************************
     * @brief Synchronizes the button signals at rising edge of the system clock.
     *       All button signals are immediately set upon system reset.
     ******************************************************************************/
    always_ff @ (posedge clock or negedge reset_s2_n)
    begin: BUTTON_PROCESS
        if (!reset_s2_n) begin
            button_s1_n <= 1;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end
        else begin
            button_s1_n <= button_n;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end
    end
    
    /*******************************************************************************
     * @brief Assigns the outputs.
     *
     * @note button_n is pressed if button_s2_n_s (the "current" input) is 0 and
     *       button_s3_n_s (the "previous" input) is 1.
     ******************************************************************************/
    assign button_pressed_s2 = !button_s2_n & button_s3_n;

endmodule 