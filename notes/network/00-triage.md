# NETWORK / PCAP — Triage

`[HT]` = HackTricks · `[W]` = ctf-wiki

> La rete in CTF è quasi sempre **analisi di un .pcap/.pcapng**: capisci che protocollo c'è,
> segui lo stream giusto, estrai file/credenziali/dati nascosti.

## Primo colpo d'occhio (sempre, in ordine)
```bash
capinfos cap.pcap                      # durata, n. pacchetti, endpoint
tshark -r cap.pcap -q -z io,phs        # GERARCHIA PROTOCOLLI: cosa c'è davvero dentro
tshark -r cap.pcap -q -z conv,tcp      # conversazioni TCP (chi parla con chi, quanti dati)
tshark -r cap.pcap -q -z conv,udp
strings cap.pcap | grep -iE 'flag|CCIT\{|pass|user|login'
```
La gerarchia protocolli decide dove guardare. Poi segui lo stream più "pesante"/sospetto.

## "Se vedi X → cerca Y → comando"
| Protocollo | Dove nascondersi | Comando chiave |
|---|---|---|
| HTTP | file scaricati, POST, header, cookie | `--export-objects http,./out` ; `-Y http.request` |
| FTP / Telnet | credenziali e comandi in chiaro | `-Y "ftp or telnet"` |
| DNS (molte query strane) | exfiltration nei sottodomini (hex/b64/b32) | `-Y dns -T fields -e dns.qry.name` |
| ICMP (payload grossi) | exfiltration nel data | `-Y icmp -T fields -e data` |
| USB (`usb.capdata`) | keystroke HID (cosa è stato digitato) | vedi "USB HID" sotto |
| TLS | serve la chiave fornita (.key / sslkeylog) | Preferences > TLS > keylog file |
| 802.11 WiFi | handshake WPA da craccare | `aircrack-ng cap.pcap -w rockyou` |
| SMB/TFTP | file trasferiti | `--export-objects smb,./out` |
| Industriale (Modbus/S7...) | valori nei registri | filtro per protocollo |

## Seguire uno stream (spesso il flag è lì)
```bash
# GUI Wireshark: tasto destro > Follow > TCP/HTTP/UDP Stream (il modo più veloce)
tshark -r cap.pcap -z follow,tcp,ascii,0      # stream numero 0 da CLI
```

## Estrarre file
```bash
tshark -r cap.pcap --export-objects http,./out_http
tshark -r cap.pcap --export-objects smb,./out_smb
# poi trattali come forensics: file ./out/* ; strings ; binwalk ; exiftool
```

## Credenziali / dati in chiaro
```bash
tshark -r cap.pcap -Y "http.request.method==POST" -T fields -e http.file_data
tshark -r cap.pcap -Y ftp -T fields -e ftp.request.command -e ftp.request.arg
```

## DNS exfiltration (molto frequente)
```bash
tshark -r cap.pcap -Y dns -T fields -e dns.qry.name | sort -u
# prendi la parte variabile dei sottodomini, concatena, poi CyberChef "Magic" per il decode
```

## USB HID (tastiera)
```bash
tshark -r cap.pcap -Y "usb.capdata" -T fields -e usb.capdata > hid.txt
# gli scancode HID vanno mappati a caratteri con uno script:
./search.sh "usb keystroke"     # trova la mappa/scheda in vendor/
```

## Strumenti
`tshark/wireshark`, `capinfos`, `tcpdump`, `aircrack-ng`, `scapy` (python, per crafting/parsing custom),
`NetworkMiner` (GUI, estrae file/credenziali in automatico, comodissimo se disponibile).

## Dove approfondire
`./search.sh "pcap"`, `./search.sh "dns exfil"`, `./search.sh "wpa handshake"`.
`vendor/hacktricks/` (network pentesting), `vendor/ctf-wiki/` (traffic/forensics),
writeup: `vendor/olicyber-writeups/` (cerca "pcap"/"network").
