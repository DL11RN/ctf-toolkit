#!/usr/bin/env python3
"""
Probe HTTP per sfide "protocollo" (verbi, header, cookie, body).
Data una URL, prova verbi diversi e cerca la flag in TUTTI i posti utili:
body, header di risposta, cookie, header Allow, Location dei redirect.

Uso (in venv: source .venv/bin/activate):
    python3 templates/http_probe.py http://web-NN.challs.olicyber.it/
    python3 templates/http_probe.py http://target/path --data username=admin,password=admin
    python3 templates/http_probe.py http://target/ --verbs DELETE,TRACE,PROPFIND,FOO
    python3 templates/http_probe.py http://target/ --flag 'CCIT'

Didattico, da usare solo sulla sfida assegnata.
"""
import argparse
import re
import sys

import requests

DEFAULT_VERBS = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH",
                 "DELETE", "TRACE", "PROPFIND", "FOO", "FLAG"]


def hits(text, pattern):
    return pattern.findall(text or "")


def show(where, value, pattern):
    found = hits(str(value), pattern)
    mark = "  <== " + " ".join(found) if found else ""
    print(f"    {where}: {value!r}{mark}")
    return found


def kv_to_dict(raw):
    """'a=b,c=d' -> {'a':'b','c':'d'}"""
    out = {}
    if not raw:
        return None
    for pair in raw.split(","):
        k, _, v = pair.partition("=")
        out[k.strip()] = v.strip()
    return out


def probe(url, verbs, body, as_json, flag_pattern, timeout):
    s = requests.Session()
    s.headers.update({"User-Agent": "ctf"})
    all_found = []

    for m in verbs:
        try:
            kw = {"timeout": timeout, "allow_redirects": False}
            if m in ("POST", "PUT", "PATCH") and body:
                kw["json" if as_json else "data"] = body
            r = s.request(m, url, **kw)
        except requests.RequestException as e:
            print(f"[{m}] errore: {e}")
            continue

        print(f"[{m}] {r.status_code}")
        all_found += show("body", r.text, flag_pattern)
        for h, v in r.headers.items():                # Allow, Location, X-Flag, ...
            if h.lower() in ("allow", "location") or flag_pattern.search(v):
                all_found += show(f"header {h}", v, flag_pattern)
        if r.cookies:
            all_found += show("cookies", r.cookies.get_dict(), flag_pattern)

    print("\n--- cookie di sessione accumulati ---")
    print("   ", s.cookies.get_dict())

    print("\n=== FLAG TROVATE ===" if all_found else "\n=== nessuna flag nei posti controllati ===")
    for f in sorted(set(all_found)):
        print("   ", f)


def main():
    ap = argparse.ArgumentParser(description="Probe HTTP multi-verbo per CTF")
    ap.add_argument("url")
    ap.add_argument("--verbs", default=",".join(DEFAULT_VERBS),
                    help="verbi separati da virgola")
    ap.add_argument("--data", help="body k=v,k=v per POST/PUT/PATCH")
    ap.add_argument("--json", action="store_true", help="invia il body come JSON")
    ap.add_argument("--flag", default=r"(?:flag|CCIT|OLICYBER)\{[^}]*\}",
                    help="regex del formato flag")
    ap.add_argument("--timeout", type=float, default=10)
    args = ap.parse_args()

    pattern = re.compile(args.flag, re.IGNORECASE)
    probe(args.url, [v.strip() for v in args.verbs.split(",") if v.strip()],
          kv_to_dict(args.data), args.json, pattern, args.timeout)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
