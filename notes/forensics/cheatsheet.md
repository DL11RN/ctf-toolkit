# FORENSICS — Cheatsheet (comandi e strumenti)

## Strumenti via apt (Debian/Ubuntu)
```bash
sudo apt install binwalk foremost exiftool steghide outguess \
     wireshark tshark john hashcat zbar-tools sqlite3 \
     p7zip-full unzip ruby
# zsteg (ruby): gem install zsteg
# volatility3: pipx install volatility3   (o pip in venv)
```

## Trio di apertura (quasi sempre)
```bash
file f ; exiftool f ; binwalk f
binwalk -e f            # estrai in cartella dedicata
strings -n6 f | less
xxd f | head            # magic bytes
```

## Immagini / stego
```bash
zsteg -a img.png                 # LSB e piani di bit (PNG/BMP)
steghide extract -sf img.jpg     # chiede password (prova vuota, poi rockyou)
exiftool -a -G1 img.*            # tutti i metadati, GPS incluso
# stegsolve.jar per ispezione visiva dei canali
```

## PCAP
```bash
tshark -r cap.pcap -q -z conv,tcp          # conversazioni
tshark -r cap.pcap -Y "http.request"       # filtra
# Wireshark GUI: File > Export Objects (HTTP/SMB), Follow > TCP Stream
```

## Archivi protetti
```bash
zip2john file.zip > h.txt ; john --wordlist=vendor/seclists/.../rockyou.txt h.txt
# analogo: rar2john, 7z2john, pdf2john, ssh2john
```

## Memory dump (Volatility3)
```bash
vol -f dump.raw windows.pslist
vol -f dump.raw windows.cmdline
vol -f dump.raw windows.filescan | grep -i flag
vol -f dump.raw -o ./out windows.dumpfiles --virtaddr 0x...
```

Per lo schema di scelta → `notes/forensics/00-triage.md`.
