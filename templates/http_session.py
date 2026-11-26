#!/usr/bin/env python3
"""
Scaffold per sfide web: sessione requests riusabile (cookie, header, base URL).
Da adattare: endpoint, parametri, logica. Uso didattico sulla sfida assegnata.
Gira in venv: source .venv/bin/activate (requests e' in tools/requirements.txt).

Coperti i fondamenti del protocollo: GET (+params), HEAD (header), POST (form/json),
OPTIONS (Allow) e verbi arbitrari. Dove cercare la flag: body, header, cookie,
Allow, Location del redirect. Vedi notes/web/http-requests.md.
"""
import requests

BASE = "https://chall.example.it"

s = requests.Session()
s.headers.update({"User-Agent": "ctf"})
# s.verify = False   # se certificato self-signed (sopprimi i warning se serve)


def dump(r):
    """Stampa tutto cio' dove una flag puo' nascondersi."""
    print(r.request.method, r.url, "->", r.status_code)
    print("  headers:", dict(r.headers))
    if r.cookies:
        print("  cookies:", r.cookies.get_dict())
    if r.text:
        print("  body:", repr(r.text[:500]))
    return r


def get(path, **kw):
    return dump(s.get(BASE + path, **kw))


def head(path, **kw):
    # HEAD: nessun body, la flag puo' stare negli header (server mal configurato)
    return dump(s.head(BASE + path, **kw))


def post(path, data=None, json=None, **kw):
    # data=... -> x-www-form-urlencoded ; json=... -> application/json
    return dump(s.post(BASE + path, data=data, json=json, **kw))


def options(path, **kw):
    r = s.options(BASE + path, **kw)
    print("Allow:", r.headers.get("Allow"))
    return r


def verb(method, path, **kw):
    # Verbo arbitrario/inatteso (DELETE, TRACE, PROPFIND, FOO, ...)
    return dump(s.request(method, BASE + path, **kw))


if __name__ == "__main__":
    r = get("/")
    # Esempi (scommenta cio' che serve):
    # get("/server-records", params={"id": "flag"})     # GET con query string
    # head("/")                                          # flag negli header?
    # get("/token"); r = get("/flag")                    # cookie di sessione
    # post("/login", data={"username": "admin", "password": "admin"})   # form
    # post("/login", json={"username": "admin", "password": "admin"})   # JSON
    # options("/")                                       # verbi supportati
    # verb("DELETE", "/")                                # verbo inatteso
    # print(s.cookies.get_dict())
