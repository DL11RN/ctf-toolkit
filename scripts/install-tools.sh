#!/usr/bin/env bash
# Prepara l'ambiente sul portatile (Debian/Ubuntu). Esegui PRIMA della gara, con rete.
# Non installa nulla di esotico: strumenti standard da CTF.
set -uo pipefail

echo "== Pacchetti di sistema (apt) =="
sudo apt update
sudo apt install -y \
  build-essential gdb git curl wget unzip p7zip-full ripgrep jq \
  python3 python3-venv python3-pip pipx \
  binwalk foremost exiftool steghide outguess sqlite3 \
  wireshark tshark john hashcat hashid zbar-tools \
  nmap netcat-openbsd ffuf gobuster hydra \
  radare2 patchelf file xxd \
  ruby ruby-dev || echo "[!] alcuni pacchetti non installati (nome diverso nella tua distro?)"

echo "== Ruby: zsteg (stego PNG/BMP) =="
sudo gem install zsteg 2>/dev/null || echo "[!] zsteg non installato"

echo "== Python (venv del repo) =="
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate
pip install --upgrade pip
pip install -r tools/requirements.txt || echo "[!] alcuni pip falliti, controlla sopra"

# ---------------------------------------------------------------------------
# Extra consigliati (GUI / installazione manuale)
# Non installabili pulitamente via apt/pip, o GUI da scaricare a mano.
# Falli PRIMA della gara, con rete.
# ---------------------------------------------------------------------------
echo "== Extra consigliati (GUI / installazione manuale) =="
cat <<'NOTE'
  # --- Web ---
  - Burp Suite Community : proxy web (intercetta/rigioca richieste). Download:
                           https://portswigger.net/burp/communitydownload  (serve JDK)
  - Wireshark (GUI)      : analisi pcap/network (il pacchetto apt e' gia' installato;
                           lancialo con 'wireshark'). Aggiungi l'utente al gruppo:
                           sudo usermod -aG wireshark $USER   (poi ri-login)

  # --- Reverse ---
  - Ghidra               : decompilatore (reverse). https://ghidra-sre.org  (serve JDK)
  - IDA Free             : alternativa a Ghidra. https://hex-rays.com/ida-free
  - Cutter               : GUI per radare2/rizin. https://cutter.re (AppImage)
  - dnSpy / ILSpy        : reverse .NET (eseguibili Windows/mono)
  - jadx / jadx-gui      : reverse Android (APK). sudo apt install jadx
  - FLOSS                : stringhe offuscate. https://github.com/mandiant/flare-floss

  # --- Pwn ---
  - pwndbg / gef         : plugin gdb per il pwn. vedi notes/pwn/cheatsheet.md
  - pwninit              : aggancio libc. cargo install pwninit (o binario release)
  - one_gadget           : shell in un colpo. sudo gem install one_gadget
  - ropper               : alternativa a ROPgadget. pip install ropper
  - seccomp-tools        : analisi filtri seccomp. sudo gem install seccomp-tools

  # --- Forensics / Stego ---
  - stegsolve.jar        : ispezione piani di bit immagini (serve JDK)
  - stegseek             : brute veloce steghide. https://github.com/RickdeJager/stegseek
  - zsteg                : LSB PNG/BMP. sudo gem install zsteg (gia' tentato sopra)
  - volatility3          : memory forensics. pipx install volatility3
  - Sonic Visualiser / Audacity : spettrogrammi audio. sudo apt install audacity
  - NetworkMiner         : estrazione automatica da pcap (gira con mono)

  # --- Crypto ---
  - CyberChef (offline)  : ./scripts/get-cyberchef.sh
  - SageMath             : teoria dei numeri / reticoli / curve. sudo apt install sagemath

  # --- Wordlist ---
  - SecLists             : ./scripts/get-seclists.sh
  - rockyou              : spesso in /usr/share/wordlists/rockyou.txt (Kali) o da SecLists

  # --- Windows / AD (per sfide stile macchina) ---
  - BloodHound + neo4j   : mappa percorsi in Active Directory
  - impacket             : pipx install impacket  (secretsdump, GetNPUsers, ...)
  - netexec (nxc)        : pipx install netexec
NOTE
echo "[+] Setup base completato. Ricorda: source .venv/bin/activate prima di usare i tool Python."
