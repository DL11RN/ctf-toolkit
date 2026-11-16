#!/usr/bin/env python3
"""
Scaffold angr: raggiungi un indirizzo 'success' evitandone uno 'fail'.
Tipico per keygen/validatori. Trova gli indirizzi con Ghidra/objdump.
"""
import angr
import claripy
import sys

BINARY = "./chall"
FIND = 0x0        # indirizzo del blocco "success" (stampa flag / "Correct")
AVOID = [0x0]     # indirizzi del blocco "wrong"
INPUT_LEN = 32    # lunghezza simbolica dell'input, da adattare

def main():
    proj = angr.Project(BINARY, auto_load_libs=False)

    # Input simbolico via stdin (adatta se legge da argv):
    sym = claripy.BVS("inp", INPUT_LEN * 8)
    state = proj.factory.full_init_state(stdin=sym)
    for byte in sym.chop(8):
        state.solver.add(byte >= 0x20, byte <= 0x7e)

    simgr = proj.factory.simulation_manager(state)
    simgr.explore(find=FIND, avoid=AVOID)

    if simgr.found:
        found = simgr.found[0]
        sol = found.solver.eval(sym, cast_to=bytes)
        print("[+] Input:", sol)
    else:
        print("[-] Nessun percorso trovato: rivedi FIND/AVOID/INPUT_LEN")

if __name__ == "__main__":
    main()
