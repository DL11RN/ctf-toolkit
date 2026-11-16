#!/usr/bin/env python3
"""
Utility XOR di base (crypto facile / misc). Adatta input e criterio di 'scoring'.
"""
import itertools, string

PRINTABLE = set(bytes(string.printable, "ascii"))
HINT = b"CCIT{"   # adatta al formato flag / parola attesa

def xor(data: bytes, key: bytes) -> bytes:
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))

def single_byte(data: bytes):
    """Prova tutte le 256 chiavi a 1 byte, stampa i candidati plausibili."""
    for k in range(256):
        out = xor(data, bytes([k]))
        if HINT in out or all(b in PRINTABLE for b in out):
            print(f"key={k:#04x}: {out!r}")

def known_plaintext(cipher: bytes, known: bytes):
    """Se conosci un pezzo di plaintext, recupera il segmento di chiave corrispondente."""
    return xor(cipher[:len(known)], known)

if __name__ == "__main__":
    ct = bytes.fromhex("")   # <-- metti qui il ciphertext (hex)
    if ct:
        single_byte(ct)
    else:
        print("Imposta 'ct' (hex) nel main.")
