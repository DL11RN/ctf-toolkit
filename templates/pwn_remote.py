#!/usr/bin/env python3
"""
Scaffold pwntools: locale / remoto / gdb. Adatta le variabili e la logica di 'solve'.
Uso:
    ./pwn_remote.py            # locale
    ./pwn_remote.py GDB        # locale sotto gdb
    ./pwn_remote.py REMOTE     # contro HOST:PORT
"""
from pwn import *

# --- Configurazione ---
BINARY = "./chall"
HOST, PORT = "chall.example.it", 1337
LIBC = ""  # es. "./libc.so.6" se fornita, altrimenti lascia vuoto

context.binary = exe = ELF(BINARY, checksec=False) if BINARY else None
context.terminal = ["tmux", "splitw", "-h"]  # adatta al tuo terminale
# context.log_level = "debug"

libc = ELF(LIBC, checksec=False) if LIBC else None

GDB_SCRIPT = """
# b *main
# b *0x...
continue
"""

def start():
    if args.REMOTE:
        return remote(HOST, PORT)
    if args.GDB:
        return gdb.debug([BINARY], gdbscript=GDB_SCRIPT)
    return process([BINARY])

def solve():
    io = start()

    # --- Esempio di struttura (da riempire) ---
    # io.recvuntil(b"prompt: ")
    # offset = 0  # trovalo con cyclic
    # payload = flat({ offset: 0x0 })
    # io.sendline(payload)

    io.interactive()

if __name__ == "__main__":
    solve()
