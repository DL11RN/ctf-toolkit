#!/usr/bin/env python3
"""
Scaffold z3: inverti un insieme di vincoli su un input (tipico in reverse/crypto facile).
Adatta numero/ampiezza delle variabili e i vincoli estratti dal binario.
"""
from z3 import *

N = 16  # lunghezza del flag/input, da adattare

s = Solver()
flag = [BitVec(f"c_{i}", 8) for i in range(N)]

# Caratteri stampabili (adatta se serve)
for c in flag:
    s.add(c >= 0x20, c <= 0x7e)

# --- Vincoli estratti dal target (esempi) ---
# s.add(flag[0] ^ flag[1] == 0x13)
# s.add(flag[2] + flag[3] == 0xfa)
# s.add(flag[4] == ord('C'))

if s.check() == sat:
    m = s.model()
    out = bytes(m[c].as_long() for c in flag)
    print("[+] SAT:", out)
else:
    print("[-] UNSAT: rivedi i vincoli")
