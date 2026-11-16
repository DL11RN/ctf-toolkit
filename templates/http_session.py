#!/usr/bin/env python3
"""
Scaffold per sfide web: sessione requests riusabile (cookie, header, base URL).
Da adattare: endpoint, parametri, logica. Uso didattico sulla sfida assegnata.
"""
import requests

BASE = "https://chall.example.it"

s = requests.Session()
s.headers.update({"User-Agent": "ctf"})
# s.verify = False   # se certificato self-signed (sopprimi i warning se serve)

def get(path, **kw):
    r = s.get(BASE + path, **kw)
    print(r.status_code, len(r.text))
    return r

def post(path, data=None, json=None, **kw):
    r = s.post(BASE + path, data=data, json=json, **kw)
    print(r.status_code, len(r.text))
    return r

if __name__ == "__main__":
    r = get("/")
    # Esempi:
    # post("/login", data={"user": "admin", "pass": "x"})
    # print(s.cookies.get_dict())
    # r = get("/flag"); print(r.text)
