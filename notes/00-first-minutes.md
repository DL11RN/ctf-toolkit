# PRIMI MINUTI & STRATEGIA DI GARA

5 ore, ~20-25 sfide, Jeopardy. L'obiettivo non è risolvere la sfida più bella: è
**massimizzare i flag**. Tempo e assegnazione delle persone sono la vera risorsa.

## Minuti 0-10 (tutta la squadra)
1. Collegatevi a Discord, leggete gli annunci e le **regole sull'IA** (limiti vs divieto totale).
2. Capite il **formato del flag** (es. `CCIT{...}` / `flag{...}`) — serve per sapere cosa cercare e per i grep.
3. Capite come si **sottomette** e se ci sono penalità per tentativi errati.
4. Fate un **giro di ricognizione**: aprite ogni sfida, leggete il titolo+testo, scaricate gli allegati.
5. Taggate ogni sfida: `[facile/sospetta-quick-win]`, `[media]`, `[rognosa]`, `[categoria]`.

## Assegnazione (triage)
- Nessuno in 4 sullo stesso task. Ognuno su **2 task** così, se uno si impunta, l'altro avanza.
- Prima i **quick win** (flag "regalati", encoding, OSINT facile, sanity-check): punti subito, morale su.
- Specialista primario + **backup** su ogni categoria: se il primario è bloccato, il backup prende.
- Ogni 30-45 min: rapido check "chi è bloccato?" → riallocate. Un task fermo da 45 min va **passato o messo in pausa**.
- Nel punteggio dinamico i task "difficili" valgono di più finché pochi li risolvono: se siete forti in una nicchia, valorizzatela presto.

## Quick-win check (fai sempre questi, costano secondi)
```bash
strings -n6 file | grep -iE 'CCIT|flag|\{.*\}'   # flag in chiaro
file file ; exiftool file                          # tipo reale + metadati
cat /robots.txt ; vedi commenti HTML ; /sitemap.xml
```
- Testo "strano" → CyberChef "Magic" (`vendor/cyberchef/`).
- Allegato binario → `binwalk file` (roba nascosta).

## Igiene operativa
- **Una cartella per sfida** (`work/<nome>/`), lavora sempre su **copie**.
- Tieni un file `work/SOLVED.md` con flag trovati + chi li ha sottomessi (evita doppioni).
- Condividi i flag parziali/leak nel canale di squadra: spesso un pezzo sblocca un altro.
- Non bruciare tentativi: verifica il formato del flag prima di sottomettere.

## Se finisci in squadra con sconosciuti
- Dichiara subito le tue 2 categorie forti, chiedi le loro, copri i buchi col repo.
- Usa `./search.sh` davanti a tutti: diventi utile anche fuori dalla tua nicchia.

## Mentalità
- Il flag è spesso nelle **basi** (metadati, stringhe, commenti): non overthinkare.
- Se una strada non dà frutti in ~45 min, **cambia** sfida. Torni dopo con occhi freschi.
