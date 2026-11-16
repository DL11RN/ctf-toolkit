#!/usr/bin/env python3
"""
Scaffold per sfide 'interattive' (misc/network): connetti, leggi, rispondi in loop.
Utile per: fare calcoli al volo, risolvere molte domande, gestire un proof-of-work.
"""
from pwn import *

HOST, PORT = "chall.example.it", 1337

def main():
    io = remote(HOST, PORT)

    # Esempio: loop domanda->risposta
    # while True:
    #     line = io.recvline().decode()
    #     log.info(line.strip())
    #     if "?" in line:
    #         ans = str(eval(line.split("=")[0]))   # ATTENZIONE a eval su input non fidato
    #         io.sendline(ans.encode())

    io.interactive()

if __name__ == "__main__":
    main()
