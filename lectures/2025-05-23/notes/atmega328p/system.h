/**
 * @brief System implementation.
 */
#ifndef SYSTEM_H_
#define SYSTEM_H_

#include <avr/io.h>
#include <avr/interrupt.h>

/** LED controlled by the state machine, connected to PIN 9 (PORTB1). */
#define LED PORTB1

/** Button for generating system reset, connected to PIN 11 (PORTB3). */
#define RESET_BUTTON PORTB3

/** Button for changing the state to previous, connected to PIN 12 (PORTB4). */
#define PREVIOUS_BUTTON PORTB4

/** Button for changing the state to next, connected to PIN 13 (PORTB5). */
#define NEXT_BUTTON PORTB5

/** 
 * @brief Enumeration representing the different states of the state machine.
 */
typedef enum 
{ 
    STATE_OFF,   /** The LED is disabled. */
    STATE_BLINK, /** The LED is blinking every 100 ms. */
    STATE_ON,    /** The LED is enabled. */
} state_t;

/**
 * @brief Enumeration representing events.
 */
typedef enum
{
    EVENT_BUTTON, /* Button event. */
    EVENT_TIMER0, /* Timer 0 event. */
    EVENT_TIMER1, /* Timer 1 event. */
    EVENT_COUNT,  /* Number of supported events. */
} event_t;

/**
 * @brief Initialize the system.
 */
void system_setup(void);

/**
 * @brief Generate system reset.
 * 
 *        Set the FSM state to STATE_OFF and disable the LED.
 *        Also disable Timer 1, and the clear corresponding timer counter.
 */
void system_reset(void);

/**
 * @brief Handle given event.
 * 
 * @param[in] event The event to handle.
 * 
 * @return Success code 0 if the event was handled, otherwise error code 1.
 */
int system_handle_event(event_t event);

#endif /* SYSTEM_H_ */