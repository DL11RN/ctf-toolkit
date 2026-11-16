# CRYPTO — Triage

`[W]` = ctf-wiki · `[CA]` = jvdsn/crypto-attacks · `[RSA]` = RsaCtfTool

## Ispezione iniziale
- Leggi il sorgente: che primitiva è (RSA, AES, XOR, ECC, hash, PRNG)? Quali parametri ti danno?
- Annota cosa è **noto** e cosa è **controllabile** (puoi scegliere ciphertext/plaintext? hai un oracolo?).
- Valori sospetti: `e` piccolo (3/5), `n` corto, nonce/IV ripetuti, chiavi corte, padding visibile.

## RSA — "se osservi X"
| Osservi | Attacco da provare | Dove |
|---|---|---|
| `e` molto piccolo (es. 3), messaggio corto | Radice e-esima / Håstad (stesso m, più n) | `[CA]` rsa, `[W]` RSA |
| `n` piccolo o prodotto di primi noti | Fattorizzazione (factordb, `yafu`) | `[RSA]`, factordb offline? |
| due `n` condividono un fattore | GCD tra moduli | `[CA]` rsa common factor |
| `d` piccolo | Wiener / Boneh-Durfee | `[CA]`, `[RSA]` |
| stesso `n`, due `e` coprimi | Common modulus | `[CA]` rsa common modulus |
| parte di `p`/`m` nota | Coppersmith | `[CA]` coppersmith |
| messaggi correlati (m, m+1...) | Franklin-Reiter | `[CA]` |
| niente di ovvio | Prova a raffica: `python vendor/rsactftool/RsaCtfTool.py --publickey key.pub --uncipher ...` | `[RSA]` README |

## AES / cifrari a blocchi
| Osservi | Ipotesi | Dove |
|---|---|---|
| ECB (blocchi uguali → ciphertext uguali) | ECB byte-at-a-time / cut&paste | `[W]` block cipher, `[CA]` ecb |
| CBC + messaggio d'errore sul padding | Padding oracle | `[W]`, `[CA]` cbc padding oracle |
| CBC e puoi alterare il ciphertext | Bit flipping | `[CA]` cbc bit flipping |
| CTR/GCM con nonce ripetuto | Nonce reuse (keystream riuso) | `[CA]` ctr nonce reuse |

## Altro
- **XOR / Vigenère**: `[W]` classical; CyberChef (`vendor/cyberchef`) per brute del key length.
- **ECC**: `[CA]` ecc (singular curve, invalid curve, smart's attack...).
- **PRNG / LCG / Mersenne**: `[CA]` prng; MT19937 ricostruibile da 624 output.
- **Hash length extension**: `[W]`; strumento `hashpump` se disponibile.

## Writeup OliCyber
`vendor/olicyber-writeups/` → Crypto. `./search.sh "wiener"`, `./search.sh "padding oracle"`.
