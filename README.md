# Argon2 for Swift

A Swift package for deriving raw Argon2id v1.3 tags using the upstream C
reference implementation. Supports variable-length salts and output sizes.

```swift
.package(url: "https://github.com/zunda-pixel/argon2-swift.git", branch: "main")
```

Add the `Argon2` product to your target.

```swift
import Argon2

let tag = try Argon2id.deriveKey(
  password: passwordBytes,
  salt: randomSalt,
  memoryKiB: 64 * 1024,
  iterations: 3,
  parallelism: 4,
  outputByteCount: 32
)
```

Generate a random salt for new credentials and store it with the parameters.
Use protocol-specific parameters when interoperating with an existing system.
The call is synchronous and does CPU-intensive work. Call it off the UI actor.

## Upstream

The files under `Sources/CArgon2/vendor` are an unmodified subset of
[P-H-C/phc-winner-argon2 at f57e61e](https://github.com/P-H-C/phc-winner-argon2/tree/f57e61e19229e23c4445b85494dbf7c07de721cb).
The package builds the portable reference implementation. For updates, record
the new upstream revision, retain the upstream license, and run the RFC 9106
and Juicebox compatibility vectors.

The Swift wrapper and C bridge are licensed under Apache-2.0. The vendored
sources retain their original license terms in `Sources/CArgon2/vendor/LICENSE`.
