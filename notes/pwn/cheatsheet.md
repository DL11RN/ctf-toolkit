# PWN — Cheatsheet (comandi e setup)

## Ispezione
```bash
file ./chall
checksec --file=./chall        # (pwntools) RELRO/Canary/NX/PIE
strings -n6 ./chall | grep -i -E 'bin/sh|flag|system|printf'
nm -C ./chall | grep -i win    # funzione "win" se non stripped
```

## Offset dell'overflow (pwntools)
```bash
cyclic 200                     # genera pattern
# dopo il crash, prendi il valore in RIP/RSP:
cyclic -l 0x6161...            # restituisce l'offset
```

## Libc fornita: aggancio
```bash
# pwninit (comodo): scarica/aggancia la libc e crea un chall patchato
pwninit
# oppure manualmente:
patchelf --set-interpreter ./ld-linux-x86-64.so.2 ./chall
patchelf --replace-needed libc.so.6 ./libc.so.6 ./chall
# versione della libc:
strings libc.so.6 | grep -i "glibc"
```

## Debugger: installare pwndbg o gef
```bash
# pwndbg
git clone https://github.com/pwndbg/pwndbg vendor/pwndbg && cd vendor/pwndbg && ./setup.sh
# oppure gef
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"   # (con rete, prima della gara)
```
Comandi utili in gdb: `vmmap`, `telescope $rsp`, `checksec`, `search`, `b *addr`, `x/20gx addr`.

## Strumenti ROP
```bash
ROPgadget --binary ./chall | grep ': pop rdi'
# in pwntools: rop = ROP(elf); rop.raw(...); rop.call(...)
```

## Seccomp
```bash
seccomp-tools dump ./chall     # vedi quali syscall sono permesse
```

Per la tecnica completa → `notes/pwn/00-triage.md` e le fonti in `vendor/`.
