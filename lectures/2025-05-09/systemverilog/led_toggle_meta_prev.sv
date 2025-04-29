/*******************************************************************************
 * @brief Design for toggling a LED whenever a button is pressed.
 *        A reset signal is implemented to generate a system reset.
 *        Metastability prevention is implemented via D flip flops.
 *
 * @param clock[in]    50 MHz system clock.
 * @param reset_n[in]  Inverting reset connected to a push button.
 * @param button_n[in] Inverting button used to toggle the LED.
 * @param led[out]     The LED to toggle whenever button_n is pressed.
 ******************************************************************************/
module led_toggle_meta_prev(input logic clock, reset_n, button_n,
                            output logic led);

    /*******************************************************************************
     * @brief Signals used internally for the button and LED.
     *
     * @param reset_s2_n        Synchronized inverting reset signal.
     * @param button_pressed_s2 Synchronized signal indicating pressdown of 
     *                          button_n (falling edge).
     * @param led_s             Internal representation of the LED value.
     ******************************************************************************/
     logic reset_s2_n = 1, button_pressed_s2 = 0, led_s = 0;
     
    /*******************************************************************************
     * @brief Implements meta stability prevention via synchronized input signals.
     ******************************************************************************/
     meta_prev meta_prev1(clock, reset_n, button_n, reset_s2_n, button_pressed_s2);
     
    /*******************************************************************************
     * @brief Updates the LED signal on rising clock edge and system reset. The LED
     *        is toggled whenever the button is pressed. The LED is immediately
     *        disabled on system reset.
     ******************************************************************************/
     always_ff @ (posedge clock or negedge reset_s2_n)
     begin: LED_PROCESS
         if (!reset_s2_n) begin
             led_s <= 0;
         end
         else begin
             if (button_pressed_s2) begin
                 led_s <= !led_s;
             end
         end
     end
     
    /*******************************************************************************
     * @brief Writes the led_s value to the LED.
     ******************************************************************************/
     assign led = led_s;

endmodule
