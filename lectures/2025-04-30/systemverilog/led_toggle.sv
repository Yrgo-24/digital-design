/*******************************************************************************
 * @brief Design for toggling a LED whenever a button is pressed.
 *        A reset signal is implemented to generate a system reset.
 *
 * @param clock[in]    50 MHz system clock.
 * @param reset_n[in]  Inverting reset connected to a push button.
 * @param button_n[in] Inverting button used to toggle the LED.
 * @param led[out]     The LED to toggle whenever button_n is pressed.
 ******************************************************************************/
module led_toggle(input logic clock, reset_n, button_n,
                  output logic led);

    
    /*******************************************************************************
     * @brief Signals used internally for the button and LED.
     *
     * @param button_s1_n    The previous value of button_n.
     * @param button_pressed Signal indicating pressdown of button_n (falling edge).
     * @param led_s          Internal representation of the LED value.
     ******************************************************************************/
     logic button_s1_n    = 1;
     logic button_pressed = 0;
     logic led_s          = 0;
     
     /*******************************************************************************
      * @brief Updates the button signals on rising clock edge and system reset.
      *        The button is pressed if the previous value (button_s1_n) is high
      *        while the current value (button_n) is low.
      ******************************************************************************/
      always_ff @ (posedge clock or negedge reset_n)
      begin: BUTTON_PROCESS
          if (!reset_n) begin
              button_s1_n    <= 1;
              button_pressed <= 0;
          end
          else begin
              button_pressed <= !button_n & button_s1_n;
              button_s1_n    <= button_n;
          end
      end
     
     /*******************************************************************************
      * @brief Updates the LED on rising clock edge and system reset. The LED
      *        is toggled whenever the button is pressed. The LED is immediately
      *        disabled on system reset.
      ******************************************************************************/
      always_ff @ (posedge clock or negedge reset_n)
      begin: LED_PROCESS
          if (!reset_n) begin
              led_s <= 0;
          end
          else begin
              if (button_pressed) begin
                  led_s <= !led_s;
              end
          end
      end
      
      /*******************************************************************************
       * @brief Writes the led_s value to the LED.
       ******************************************************************************/
      assign led = led_s;
     
endmodule

