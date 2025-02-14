/**
 * @brief Bit utility functions.
 */
#ifndef BIT_UTILS_DEFINED
#define BIT_UTILS_DEFINED

#include <stdint.h>

/**
 * @brief Print 8-bit value in unsigned, signed, binary and hexadecimal form.
 * 
 * @param value The value to print.
 */
void print_8bit(const uint8_t value);

/**
 * @brief Print 4-bit value in unsigned, signed, binary and hexadecimal form.
 * 
 * @param value The value to print.
 */
void print_4bit(const uint8_t value);

#endif /* BIT_UTILS_DEFINED */