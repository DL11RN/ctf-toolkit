# FORENSICS — Triage

`[W]` = ctf-wiki (misc/forensics) · `[HT]` = HackTricks

## Ispezione iniziale (qualunque file)
```bash
file sospetto.bin           # cos'e' davvero (non fidarti dell'estensione)
exiftool sospetto.*         # metadati (spesso c'e' il flag o un indizio)
binwalk sospetto.bin        # file annidati / archivi nascosti
binwalk -e sospetto.bin     # estrai (occhio: estrai in cartella dedicata)
strings -n6 sospetto.bin | less
xxd sospetto.bin | head      # magic bytes: controlla/ripara header corrotti
```

## Dal tipo → cosa provare
| Tipo | Controlla | Dove |
|---|---|---|
| Immagine (PNG/JPG/BMP) | LSB, canali/piani di bit, zsteg/stegsolve, dati dopo IEND | `[W]` image, `[HT]` stego |
| Immagine con password | steghide (`steghide extract -sf img.jpg`), outguess | `[HT]` |
| PCAP (traffico di rete) | Wireshark: Follow Stream, Export Objects, filtri; `tshark` | `[W]` traffic |
| Memory dump | Volatility3 (`pslist`, `cmdline`, `filescan`, `dumpfiles`) | `[W]` memory |
| Disco / filesystem | `testdisk`/`photorec`, `foremost`, mount loop | `[HT]` |
| Archivio (zip/rar) protetto | `zip2john`/`rar2john` + john/hashcat con rockyou | `[HT]` |
| Documento Office | `oletools` (olevba), macro sospette | `[HT]` |
| Audio | Spettrogramma (Sonic Visualiser/Audacity), DTMF, SSTV | `[W]` audio |
| QR / barcode | `zbarimg` | — |
| File corrotto | Ripara i magic bytes confrontando con un file sano | `[W]` |

## Regole d'oro
- Lavora **sempre su una copia** e in una **cartella dedicata** (binwalk -e crea tanti file).
- Il flag è spesso in metadati, in coda al file, o in un layer nascosto: non saltare le basi.

## Strumenti da avere (apt, non pip)
`binwalk foremost exiftool steghide zsteg(ruby) wireshark tshark volatility3 john hashcat zbar-tools sonic-visualiser` — vedi `cheatsheet.md`.

## Writeup OliCyber
`vendor/olicyber-writeups/` → Forensics/Misc. `./search.sh "lsb"`, `./search.sh "volatility"`.
