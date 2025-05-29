# Decryptable

This Sui Move package implements a `Decryptable` enum which stores a decryptable piece of data.

```
public enum Decryptable has copy, drop, store {
    Encrypted { ciphertext: vector<u8>, hash: vector<u8>, nonce: vector<u8> },
    Decrypted { data: vector<u8> },
}
```

To create a `Decryptable`, you must provide three arguments:

1. `ciphertext` - The encrypted payload. We recommend using [Seal](https://github.com/MystenLabs/seal) for encryption.
2. `hash` - A Blake2b256 hash of the decrypted payload.
3. `nonce` - A random 32 byte value.

To create the `ciphertext`, combine the source payload with the nonce (payload + nonce). This helps to ensure that two `Decryptable` objects with the same source payload will have unique `ciphertext` and `hash` values.

To transition a `Decryptable` from `Encrypted` to `Decrypted` status, decrypt the `ciphertext` offchain (again, we recommend using Seal) and call `decrypt()` with the decrypted payload.