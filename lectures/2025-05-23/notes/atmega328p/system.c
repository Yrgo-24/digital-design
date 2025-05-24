/**
 * @brief System implementation details.
 */
#include "system.h"

/** Enable the LED. */
#define LED_ON PORTB |= (1U << LED)

/** Disable the LED. */
#define LED_OFF PORTB &= ~(1U << LED)

/** Toggle the LED. */
#define LED_TOGGLE PINB |= (1U << LED)

/** Indicate that NEXT_BUTTON is pressed. */
#define NEXT_BUTTON_IS_PRESSED (PINB & (1U << NEXT_BUTTON))

/** Indicate that PREVIOUS_BUTTON is pressed. */
#define PREVIOUS_BUTTON_IS_PRESSED (PINB & (1U << PREVIOUS_BUTTON))

/** Indicate that RESET_BUTTON is pressed. */
#define RESET_BUTTON_IS_PRESSED (PINB & (1U << RESET_BUTTON))

/** Signal to update the FSM to next state. */
#define NEXT_STATE (NEXT_BUTTON_IS_PRESSED && !PREVIOUS_BUTTON_IS_PRESSED)

/** Signal to update the FSM to previous state. */
#define PREVIOUS_STATE (!NEXT_BUTTON_IS_PRESSED && PREVIOUS_BUTTON_IS_PRESSED)

/** Enable PIN change interrupts on PORTB. */
#define PORTB_PCI_ENABLE  PCICR = (1U << PCIE0)

/** Disable PIN change interrupts on PORTB. */
#define PORTB_PCI_DISABLE PCICR &= ~(1U << PCIE0)

/** Enable Timer 0. */
#define TIMER0_ENABLE  TIMSK0 = (1U << TOIE0)

/** Disable Timer 0. */
#define TIMER0_DISABLE TIMSK0 = 0U

/** Enable Timer 1. */
#define TIMER1_ENABLE  TIMSK1 = (1U << OCIE1A)

/** Disable Timer 1. */
#define TIMER1_DISABLE TIMSK1 = 0U

/** Interrupt count on Timer 0 for a 300 ms duration. */
#define TIMER0_COUNTER_MAX_300MS 18U

/** Interrupt count on Timer 1 for a 100 ms duration. */
#define TIMER1_COUNTER_MAX_100MS 6U

/** Max count value used for Timer 1 in CTC mode. */
#define TIMER1_COUNTER_REG_LIMIT 256U

/**
 * @brief Structure representing timer counters.
 */
typedef struct
{
    /** Number of executed interrupts for Timer 0. */
    volatile uint8_t timer0;

    /** Number of executed interrupts for Timer 1. */
    volatile uint8_t timer1;
} timer_counter_t;

/** Current state of the FSM. */
static state_t state = STATE_OFF;

/** Timer counters. */
static timer_counter_t counter = {0U, 0U};

static void update_state(void);
static int handle_button_event(void);
static int handle_timer0_event(void);
static int handle_timer1_event(void);

// -----------------------------------------------------------------------------
void system_setup(void)
{
    // Set up the PINs.
    DDRB   = (1U << LED);
    PORTB  = ((1U << RESET_BUTTON) | (1U << PREVIOUS_BUTTON) | (1U << NEXT_BUTTON));

    // Enable PIN change interrupts on the button PINs.
    PCICR  = (1U << PCIE0);
    PCMSK0 = ((1U << RESET_BUTTON) | (1U << PREVIOUS_BUTTON) | (1U << NEXT_BUTTON));

    // Initialize the timers.
    TCCR0B = (1U << CS00) | (1U << CS02);
    TCCR1B = (1U << CS10) | (1U << CS12) | (1 << WGM12);
    OCR1A  = TIMER1_COUNTER_REG_LIMIT;
    asm("SEI");
}

// -----------------------------------------------------------------------------
void system_reset(void)
{
    TIMER1_DISABLE;
    LED_OFF;
    state          = STATE_OFF;
    counter.timer1 = 0U;
}

// -----------------------------------------------------------------------------
int system_handle_event(event_t event)
{
    switch (event)
    {
        case EVENT_BUTTON:
            return handle_button_event();
        case EVENT_TIMER0:
            return handle_timer0_event();
        case EVENT_TIMER1:
            return handle_timer1_event();
        default:
            return 0;
    }
}

// -----------------------------------------------------------------------------
static void update_state(void)
{
    // Update the state machine in accordance with current state and the button pressed.
    switch (state)
    {
        case STATE_OFF:
        {
            if (NEXT_STATE)          { state = STATE_BLINK; }
            else if (PREVIOUS_STATE) { state = STATE_ON; }
            break;
        }
        case STATE_BLINK:
        {
            if (NEXT_STATE)          { state = STATE_ON; }
            else if (PREVIOUS_STATE) { state = STATE_OFF; }
            break;
        }
        case STATE_ON:
        {
            if (NEXT_STATE)          { state = STATE_OFF; }
            else if (PREVIOUS_STATE) { state = STATE_BLINK; }
            break;
        }
        default:
        {
            system_reset();
            break;
        }
    }

    // Enable Timer 1 is current state is STATE_BLINK.
    if (state == STATE_BLINK) { TIMER1_ENABLE; }
    else                      { TIMER1_DISABLE; }

    // Disable the LED if current state is STATE_OFF.
    if (state == STATE_OFF)     { LED_OFF; }

    // Enable the LED if current state is STATE_ON.
    else if (state == STATE_ON) { LED_ON; }
}

// -----------------------------------------------------------------------------
static int handle_button_event(void)
{
    // Disable PCI interrupts on PORTB, enable Timer 0 to re-enable PCI interrupts after 300 ms.
    PORTB_PCI_DISABLE;
    TIMER0_ENABLE;

    // Reset the system if RESET_BUTTON is pressed, else update current state.
    if (RESET_BUTTON_IS_PRESSED) { system_reset(); }
    else { update_state(); }

    // Return 0 to indicate that the event was handled.
    return 0;
}

// -----------------------------------------------------------------------------
static int handle_timer0_event(void)
{
    // Enable PCI interrupts on PORTB when 300 ms has elapsed.
    if (TIMER0_COUNTER_MAX_300MS <= ++counter.timer0)
    {
        PORTB_PCI_ENABLE;
        TIMER0_DISABLE;
        counter.timer0 = 0U;
    }
    // Return 0 to indicate that the event was handled.
    return 0;
}

// -----------------------------------------------------------------------------
static int handle_timer1_event(void)
{
    // Toggle the LED when 100 ms has elapsed.
    if (TIMER1_COUNTER_MAX_100MS <= ++counter.timer1)
    {
        LED_TOGGLE;
        counter.timer1 = 0U;
    } 
    // Return 0 to indicate that the event was handled.
    return 0;
}