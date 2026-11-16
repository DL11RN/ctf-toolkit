# BLOCKCHAIN — Triage (parcheggiata in misc)

`[HT]` = HackTricks (Blockchain / Smart Contracts)

Preparazione minima: l'anno scorso era solo una buzzword. Se compare, quasi sempre è un
**contratto Solidity** di cui ti danno il sorgente e un endpoint per interagire.

## Primo sguardo al sorgente Solidity
Cerca questi pattern classici:
| Pattern | Rischio |
|---|---|
| funzione che manda ether e poi aggiorna lo stato | reentrancy |
| `tx.origin` per autorizzare | phishing/auth bypass |
| aritmetica senza check (Solidity < 0.8) | overflow/underflow |
| `delegatecall` verso indirizzo controllabile | storage hijack |
| variabili/funzioni senza modificatore di visibilità/accesso | accesso non previsto |
| segreto "privato" nello storage | lo storage on-chain è leggibile |
| casualità da `block.timestamp`/`blockhash` | prevedibile |

## Interazione
- `web3.py` (Python) oppure `cast`/`foundry` se installati.
- Capisci l'obiettivo: di solito portare una variabile a un certo stato (es. `isSolved()==true`)
  oppure svuotare il contratto.

## Dove
`[HT]` → Blockchain/Smart Contracts. `./search.sh "reentrancy"`, `./search.sh "delegatecall"`.
Writeup: `vendor/olicyber-writeups/` (cerca "blockchain"/"solidity").
