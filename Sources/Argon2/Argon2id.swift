import CArgon2

public enum Argon2Error: Error, Equatable, Sendable {
  case invalidLength
  case derivationFailed(code: Int32, message: String)
}

public enum Argon2id {
  /// Derives a raw Argon2id v1.3 tag. Memory is specified in KiB.
  ///
  /// Supply parameters from a trusted configuration because they control CPU
  /// time and memory allocation.
  public static func deriveKey(
    password: [UInt8],
    salt: [UInt8],
    memoryKiB: UInt32,
    iterations: UInt32,
    parallelism: UInt32,
    outputByteCount: Int,
    secret: [UInt8] = [],
    associatedData: [UInt8] = []
  ) throws -> [UInt8] {
    guard let passwordLength = UInt32(exactly: password.count),
      let saltLength = UInt32(exactly: salt.count), saltLength >= 8,
      let secretLength = UInt32(exactly: secret.count),
      let associatedDataLength = UInt32(exactly: associatedData.count),
      let outputLength = UInt32(exactly: outputByteCount), outputLength >= 4
    else { throw Argon2Error.invalidLength }

    var output = [UInt8](repeating: 0, count: outputByteCount)
    // The C call borrows these buffers only for the duration of the call.
    let status = password.withUnsafeBufferPointer { password in
      salt.withUnsafeBufferPointer { salt in
        secret.withUnsafeBufferPointer { secret in
          associatedData.withUnsafeBufferPointer { associatedData in
            output.withUnsafeMutableBufferPointer { output in
              unsafe swift_argon2id(
                password.baseAddress, passwordLength,
                salt.baseAddress, saltLength,
                secret.baseAddress, secretLength,
                associatedData.baseAddress, associatedDataLength,
                memoryKiB, iterations, parallelism,
                output.baseAddress, outputLength)
            }
          }
        }
      }
    }
    guard status == 0 else {
      // The reference implementation returns a static NUL-terminated string.
      let message = unsafe String(cString: swift_argon2_error_message(status))
      throw Argon2Error.derivationFailed(code: status, message: message)
    }
    return output
  }
}
