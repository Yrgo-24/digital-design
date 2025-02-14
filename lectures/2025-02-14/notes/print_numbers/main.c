/**
 * @brief Program for print signed and unsigned values.
 */
#include <stdint.h>

#include "bit_utils.h"

/**
 * @brief Print 4- and 8-bit values in unsigned, signed, binary and hexadecimal form.
 * 
 * @return Success code 0 upon termination of the program.
 */
int main(void)
{
    // Print 4-bit values in the range 6 - 10.
    for (uint8_t value = 6U; value <= 10U; ++value) { print_4bit(value); }

    // Print 8-bit values in the range 126 - 130.
    for (uint8_t value = 126U; value <= 130U; ++value) { print_8bit(value); }
    return 0;
}