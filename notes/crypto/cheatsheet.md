# CRYPTO — Cheatsheet (comandi e primitive)

## Riconoscimento rapido
```bash
# Encoding/testo: usa CyberChef "Magic" (vendor/cyberchef/)
python3 -c "import base64;print(base64.b64decode('....'))"
echo -n "48656c6c6f" | xxd -r -p          # hex -> bytes
```
- `n`, `e`, `c` → RSA. Blocchi da 16 byte → AES. Chiave+testo stessa lunghezza → XOR/OTP.

## RSA — strumenti
```bash
# RsaCtfTool: prova molti attacchi in automatico
python3 vendor/rsactftool/RsaCtfTool.py --publickey key.pem --uncipher cipher.bin
python3 vendor/rsactftool/RsaCtfTool.py -n <n> -e <e> --uncipher <c> --attack wiener,hastad,...
# Fattorizzazione: factordb (online) o yafu/sympy offline
python3 -c "import sympy; print(sympy.factorint(<n>))"
```
Attacchi mirati (sorgente): `vendor/crypto-attacks/` (jvdsn) ha implementazioni pronte per
Wiener, Håstad, common modulus, Coppersmith, Franklin-Reiter, ecc. → vedi `00-triage.md`.

## AES / cifrari a blocchi
- ECB: blocchi di plaintext uguali → blocchi di ciphertext uguali (riconoscibile a colpo d'occhio).
- Oracolo (il server cifra/decifra per te) → scrivi un client (`templates/nc_client.py`) e automatizza.
- `pycryptodome` per implementare: `from Crypto.Cipher import AES`.

## Hash / password
```bash
hashid '<hash>'                            # che tipo di hash è
john --wordlist=vendor/seclists/Passwords/Leaked-Databases/rockyou.txt hash.txt
hashcat -m <mode> hash.txt vendor/seclists/.../rockyou.txt
```

## Classici / XOR / Vigenère
- CyberChef: XOR Brute Force, Vigenère, frequency analysis.
- XOR single-byte: prova tutte le 256 chiavi, cerca testo stampabile / il flag format.

## Dove approfondire
`vendor/ctf-wiki/` (sezione crypto), `vendor/crypto-attacks/`, `vendor/hacktricks/`.
`./search.sh "wiener"`, `./search.sh "padding oracle"`, `./search.sh "lcg"`.
