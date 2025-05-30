module decryptable::decryptable;

use sui::hash::blake2b256;

//=== Enums ===

public enum Decryptable has copy, drop, store {
    Encrypted { ciphertext: vector<u8>, hash: vector<u8>, nonce: vector<u8> },
    Decrypted { data: vector<u8> },
}

//=== Errors ===

const EHashMismatch: u64 = 0;
const EInvalidHashLength: u64 = 1;
const EInvalidNonceLength: u64 = 2;
const ENotDecrypted: u64 = 3;
const ENotEncrypted: u64 = 4;

//=== Public Functions ===

public fun new(ciphertext: vector<u8>, hash: vector<u8>, nonce: vector<u8>): Decryptable {
    assert!(hash.length() == 32, EInvalidHashLength);
    assert!(nonce.length() == 32, EInvalidNonceLength);

    let decryptable = Decryptable::Encrypted { ciphertext, hash, nonce };

    decryptable
}

public fun decrypt(self: &mut Decryptable, mut data: vector<u8>) {
    match (self) {
        Decryptable::Encrypted { hash, nonce, .. } => {
            data.append(*nonce);
            assert!(blake2b256(&data) == *hash, EHashMismatch);
            *self = Decryptable::Decrypted { data };
        },
        Decryptable::Decrypted { .. } => abort ENotEncrypted,
    };
}

//=== View Functions ===

public fun ciphertext(self: &Decryptable): &vector<u8> {
    match (self) {
        Decryptable::Encrypted { ciphertext, .. } => ciphertext,
        Decryptable::Decrypted { .. } => abort ENotEncrypted,
    }
}

public fun data(self: &Decryptable): &vector<u8> {
    match (self) {
        Decryptable::Encrypted { .. } => abort ENotDecrypted,
        Decryptable::Decrypted { data } => data,
    }
}

public fun hash(self: &Decryptable): &vector<u8> {
    match (self) {
        Decryptable::Encrypted { hash, .. } => hash,
        Decryptable::Decrypted { .. } => abort ENotEncrypted,
    }
}

public fun nonce(self: &Decryptable): &vector<u8> {
    match (self) {
        Decryptable::Encrypted { nonce, .. } => nonce,
        Decryptable::Decrypted { .. } => abort ENotEncrypted,
    }
}
