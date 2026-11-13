import Argon2
import Testing

@Test func rfc9106Argon2idVector() throws {
  let tag = try Argon2id.deriveKey(
    password: [UInt8](repeating: 1, count: 32),
    salt: [UInt8](repeating: 2, count: 16),
    memoryKiB: 32, iterations: 3, parallelism: 4, outputByteCount: 32,
    secret: [UInt8](repeating: 3, count: 8),
    associatedData: [UInt8](repeating: 4, count: 12))
  #expect(hex(tag) == "0d640df58d78766c08c037a34a8b53c9d01ef0452d75b65eb52520e96b01e659")
}

@Test func juiceboxStandard2019Vector() throws {
  let salt =
    [0, 0, 0, 16] + [UInt8](repeating: 5, count: 16)
    + [0, 0, 0, 7] + Array("artemis".utf8)
  let tag = try Argon2id.deriveKey(
    password: Array("1234".utf8), salt: salt,
    memoryKiB: 16 * 1024, iterations: 32, parallelism: 1, outputByteCount: 64)
  let accessKey = "2935da84c97423b37f3457231b877ce6ac2093501d7255dbee1deb09a5d8821b"
  let seed = "87c8c9b5d3ea9fea83b6ac6a64e25b97c4722ca4e40bea2523efea262125e22a"
  #expect(hex(tag) == accessKey + seed)
}

@Test func rejectsShortSalt() {
  #expect(throws: Argon2Error.invalidLength) {
    try Argon2id.deriveKey(
      password: [], salt: [1, 2, 3], memoryKiB: 32, iterations: 1,
      parallelism: 1, outputByteCount: 32)
  }
}

private func hex(_ bytes: [UInt8]) -> String {
  bytes.map { String($0 >> 4, radix: 16) + String($0 & 15, radix: 16) }.joined()
}
