#include "Argon2Bridge.h"
#include "argon2.h"
#include <stddef.h>

int swift_argon2id(
    const uint8_t *password, uint32_t password_length,
    const uint8_t *salt, uint32_t salt_length,
    const uint8_t *secret, uint32_t secret_length,
    const uint8_t *associated_data, uint32_t associated_data_length,
    uint32_t memory_kib, uint32_t iterations, uint32_t parallelism,
    uint8_t *output, uint32_t output_length) {
    // The reference API only writes to password and secret when the clear
    // flags are set. Swift owns these buffers, so leave those flags disabled.
    argon2_context context = {
        .out = output, .outlen = output_length,
        .pwd = (uint8_t *)password, .pwdlen = password_length,
        .salt = (uint8_t *)salt, .saltlen = salt_length,
        .secret = (uint8_t *)secret, .secretlen = secret_length,
        .ad = (uint8_t *)associated_data, .adlen = associated_data_length,
        .t_cost = iterations, .m_cost = memory_kib,
        .lanes = parallelism, .threads = parallelism,
        .version = ARGON2_VERSION_13,
        .allocate_cbk = NULL, .free_cbk = NULL,
        .flags = ARGON2_DEFAULT_FLAGS,
    };
    return argon2id_ctx(&context);
}

const char *swift_argon2_error_message(int status) {
    return argon2_error_message(status);
}
