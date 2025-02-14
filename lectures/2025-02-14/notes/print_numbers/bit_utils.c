/**
 * @brief Implementation details of bit utility functions.
 */
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

// -----------------------------------------------------------------------------
static inline bool is_msb_set(const uint8_t value, const uint8_t bit_count)
{
    return value & (1U << (bit_count - 1UL));
}

// -----------------------------------------------------------------------------
static void print_bits(const uint8_t value, const int8_t signed_value)
{
    printf("--------------------------------------------------------------------------------\n");
    printf("Unsigned: %hu\n", value);
    printf("Signed: %hd\n", signed_value);
    printf("Binary: 0b%b\n", value);
    printf("Hex: 0x%x\n", value);
    printf("--------------------------------------------------------------------------------\n\n");
}

// -----------------------------------------------------------------------------
void print_8bit(const uint8_t value)
{
    printf("--------------------------------------------------------------------------------\n");
    printf("Unsigned: %hu\n", value);
    printf("Signed: %hd\n", (int8_t)(value));
    printf("Binary: 0b%b\n", value);
    printf("Hex: 0x%x\n", value);
    printf("--------------------------------------------------------------------------------\n\n");
}

// -----------------------------------------------------------------------------
void print_4bit(uint8_t value)
{
    // Truncate value to four bits by clearing the upper nibble.
    value = value & 0x0FU;

    // Calculate signed value, use two's complement if MSB is set.
    const int8_t signed_value = is_msb_set(value, 4U) ? value - 16U : value;

    // Print bits in the terminal.
    print_bits(value, signed_value);
}
