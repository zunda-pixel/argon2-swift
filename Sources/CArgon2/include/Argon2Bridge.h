#ifndef ARGON2_BRIDGE_H
#define ARGON2_BRIDGE_H

#include <stdint.h>

int swift_argon2id(
    const uint8_t *password, uint32_t password_length,
    const uint8_t *salt, uint32_t salt_length,
    const uint8_t *secret, uint32_t secret_length,
    const uint8_t *associated_data, uint32_t associated_data_length,
    uint32_t memory_kib, uint32_t iterations, uint32_t parallelism,
    uint8_t *output, uint32_t output_length);

const char *swift_argon2_error_message(int status);

#endif
