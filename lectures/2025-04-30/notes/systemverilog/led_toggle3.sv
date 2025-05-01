/*******************************************************************************
 * @brief Describe a digital system consisting of a clock, a reset button, 
 *        three push buttons, and three LEDs. 
 * 
 *        Toggle a given LED when the corresponding button is pressed. 
 *        Turn off all LEDs immediately during a system reset.
 *
 * @param clock         50 MHz system clock.
 * @param reset_n       Active-low reset signal for generating system reset.
 * @param button_n[2:0] Active-low push buttons for toggling the LEDs.
 * @param led[2:0]      LEDs that toggle when the corresponding push button 
 *                      is pressed.
 *******************************************************************************/
module led_toggle3(input logic clock, reset_n,
                   input logic[2:0] button_n,
                   output logic[2:0] led);

    /*******************************************************************************
     * @brief Define preset values for the push buttons. Use '1' as the default state 
     *        for active-low signals to indicate that the buttons aren't pressed.
     *******************************************************************************/
    const logic[2:0] PRESET = 3'b111;
     
    /*******************************************************************************
     * @brief Define a constant to turn off all LEDs.
     *******************************************************************************/
    const logic[2:0] LEDS_OFF = 3'b000;
    
    /*******************************************************************************
     * @brief Store the values of button_n[2:0] during the previous clock cycle.
     *        Keep these values one clock cycle old and update them on the rising 
     *        edge of the system clock.
     *******************************************************************************/
    logic[2:0] button_prev;
     
    /*******************************************************************************
     * @brief Detect a falling edge of button_n[2:0]. Set button_edge[i] when the 
     *        corresponding button is currently pressed (button_n[i] = '0') but 
     *        wasn't pressed during the previous clock cycle (button_prev[i] = '1').
     *******************************************************************************/
    logic[2:0] button_edge;
    
    /*******************************************************************************
     * @brief Update button_prev during a system reset or on the rising edge of 
     *        the system clock.
     *
     *        Set button_prev to its preset value "111" during a system reset.
     *        Update button_prev with the current value of button_n on the rising 
     *        edge of the system clock.
     *******************************************************************************/
    always_ff @ (posedge clock or negedge reset_n)
    begin
        if (!reset_n) button_prev <= PRESET;
        else button_prev <= button_n;
    end
    
    /*******************************************************************************
     * @brief Update led during a system reset or on the rising edge of the 
     *        system clock.
     *
     *        Set led to its default value of "000" during a system reset.
     *        Toggle led[i] on the rising edge of the system clock when a falling 
     *        edge of button_n[i] is detected (i.e., when button_edge[i] = '1').
     *******************************************************************************/
    always_ff @ (posedge clock or negedge reset_n)
    begin
        if (!reset_n) led <= LEDS_OFF;
        else begin
            for (int i = 0; i < 3; ++i) begin
                if (button_edge[i]) led[i] <= !led[i];
            end
        end
    end
    
    /*******************************************************************************
     * @brief Derive button_edge by detecting a falling edge of button_n.
     *        A falling edge is identified when button_n[i] transitions from '1' 
     *        (not pressed) to '0' (pressed), while button_prev[i] still holds '1'.
     *******************************************************************************/
    always_comb 
    begin
        for (int i = 0; i < 3; ++i) begin
            button_edge[i] = !button_n[i] & button_prev[i];
        end
    end

endmodule 