#!/usr/bin/env python3
"""Pufi — audit de proveniență pentru foto/, fotbal/ și imn/ (Wikimedia Commons).

Rulează pe un Mac cu internet (nu în aplicație):
    python3 -m pip install --user pillow numpy
    python3 tools/asset_audit.py            # toate
    python3 tools/asset_audit.py --only foto,fotbal,imn

Ce face, fără să ghicească:
  * pentru fiecare fișier local caută candidați pe Commons (pagina Wikipedia folosită la descărcare,
    imaginile articolului, căutare pe Commons după subiect și autorul înregistrat);
  * descarcă miniaturi și compară imaginea cu fișierul local (hash perceptual dHash 64 biți);
    potrivire acceptată doar la distanță Hamming <= 10 → „VERIFICAT”; 11–16 → „PROBABIL” (verifică manual);
  * pentru imnuri compară sunetul (amprentă spectrală, ffmpeg) cu înregistrările audio de pe Commons;
  * citește de pe pagina fișierului: autor, licență, link licență, șabloanele de licență (wikitext),
    restricții (personality rights etc.);
  * scrie licenses/assets.json și ASSET_LICENSES.md. Nimic nu e completat din memorie.
"""
import argparse, hashlib, io, json, math, os, re, subprocess, sys, time, urllib.error, urllib.parse, urllib.request
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UA = {"User-Agent": "PufiAssetAudit/1.0 (family kids learning app 'Pufi'; license audit; https://github.com/hory80/Pufi-game) python-urllib"}
try:
    from PIL import Image
    import numpy as np
except ImportError:
    sys.exit("Lipsesc pachete: python3 -m pip install --user pillow numpy")
SRC = json.load(open(os.path.join(ROOT, "tools", "asset_sources.json")))
CACHE = os.path.join(ROOT, "licenses", ".cache"); os.makedirs(CACHE, exist_ok=True)

def get(url, binary=False, tries=6):
    # Shared query suffixes are identical for many files: hash the complete URL.
    ck = os.path.join(CACHE, hashlib.sha256(url.encode("utf-8")).hexdigest())
    if os.path.exists(ck): return open(ck, "rb").read()
    for a in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60) as r: data = r.read()
            open(ck, "wb").write(data); time.sleep(0.4); return data
        except urllib.error.HTTPError as e:
            if e.code in (429, 503) and a < tries - 1: w = int(e.headers.get("Retry-After") or 0) or 8 * (a + 1); time.sleep(w); continue
            raise
        except Exception:
            if a < tries - 1: time.sleep(3 * (a + 1)); continue
            raise
def api(base, **p):
    p.update(format="json", formatversion=2); return json.loads(get(base + "?" + urllib.parse.urlencode(p)))
WP, CM = "https://en.wikipedia.org/w/api.php", "https://commons.wikimedia.org/w/api.php"
strip = lambda h: re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", h or "")).strip()

def dhash(im, n=8):
    g = im.convert("L").resize((n + 1, n), Image.LANCZOS); a = np.asarray(g, dtype=np.int16)
    return (a[:, 1:] > a[:, :-1]).flatten()
def ham(a, b): return int((a != b).sum())

def file_info(titles):
    """Metadate în loturi scurte: numele lungi pot depăși limita URI a serverului."""
    out = {}
    for i in range(0, len(titles), 10):
        d = api(CM, action="query", titles="|".join(titles[i:i + 10]), prop="imageinfo|revisions", rvprop="content", rvslots="main",
                iiprop="url|size|mime|extmetadata", iiurlwidth=320, iiextmetadatafilter="Artist|Credit|LicenseShortName|LicenseUrl|UsageTerms|AttributionRequired|Restrictions|Copyrighted|ImageDescription")
        for pg in d["query"].get("pages", []):
            if pg.get("missing") or "imageinfo" not in pg: continue
            ii = pg["imageinfo"][0]; md = ii.get("extmetadata", {}); v = lambda k: (md.get(k) or {}).get("value", "")
            txt = ((pg.get("revisions") or [{}])[0].get("slots", {}).get("main", {}).get("content", "")) or ""
            tpl = sorted(set(m.strip() for m in re.findall(r"\{\{\s*([^|}\n]+)", txt) if re.match(r"(?i)(cc-|pd|gfdl|self|attribution|kogl|godl|copyrighted free use|personality|trademark|esa|european parliament|free screenshot|licen|fal|ogl)", m.strip())))
            out[pg["title"]] = {"file": pg["title"], "page": ii.get("descriptionurl"), "thumb": ii.get("thumburl"), "url": ii.get("url"), "w": ii.get("width"), "h": ii.get("height"), "mime": ii.get("mime"),
                "author": strip(v("Artist")), "credit": strip(v("Credit")), "license": strip(v("LicenseShortName")), "license_url": v("LicenseUrl"), "usage": strip(v("UsageTerms")),
                "attribution_required": v("AttributionRequired"), "restrictions": strip(v("Restrictions")), "templates": tpl, "duration": None}
    return out

def candidates_photo(subject, author):
    c = []
    try:
        d = api(WP, action="query", titles=subject, prop="pageimages|images", piprop="name", imlimit=60, redirects=1)
        for pg in d["query"]["pages"]:
            if pg.get("pageimage"): c.append("File:" + pg["pageimage"])
            c += [i["title"] for i in pg.get("images", []) if re.search(r"\.(jpe?g|png|webp|tiff?)$", i["title"], re.I)]
    except Exception as e: print("   wp", e)
    q = [subject] + ([subject + " " + author.split(",")[0].split("(")[0].strip()] if author and "unknown" not in author.lower() else [])
    for s in q:
        try:
            d = api(CM, action="query", list="search", srsearch=s + " filetype:bitmap", srnamespace=6, srlimit=30)
            c += [r["title"] for r in d["query"]["search"]]
        except Exception as e: print("   search", e)
    seen = set(); return [x for x in c if not (x in seen or seen.add(x))]

def match_photo(local, subject, author):
    im = Image.open(local); lh = dhash(im); lar = im.width / im.height
    cands = candidates_photo(subject, author); info = file_info(cands); best = None
    for t, f in info.items():
        if not f.get("thumb"): continue
        try: th = Image.open(io.BytesIO(get(f["thumb"], True)))
        except Exception: continue
        d = ham(lh, dhash(th)); ar = (f["w"] or 1) / (f["h"] or 1)
        if best is None or d < best[0]: best = (d, f, ar)
        # No later candidate can improve on zero; tie handling stays unchanged.
        if d == 0: break
    if not best: return None, None, lar
    return best[0], best[1], lar

COUNTRY = {"AR": "Argentina", "AT": "Austria", "AU": "Australia", "BE": "Belgium", "BR": "Brazil", "CA": "Canada", "CH": "Switzerland", "CN": "China", "DE": "Germany", "DK": "Denmark", "EG": "Egypt", "ES": "Spain", "FI": "Finland", "FR": "France", "GB": "United Kingdom", "GR": "Greece", "HR": "Croatia", "HU": "Hungary", "IE": "Ireland", "IN": "India", "IS": "Iceland", "IT": "Italy", "JP": "Japan", "KR": "South Korea", "MD": "Moldova", "MX": "Mexico", "NL": "Netherlands", "NO": "Norway", "PL": "Poland", "PT": "Portugal", "RO": "Romania", "SE": "Sweden", "TR": "Turkey", "UA": "Ukraine", "US": "United States", "ZA": "South Africa"}
def pcm(path_or_bytes, secs=95, off=0):
    src = path_or_bytes
    if isinstance(path_or_bytes, bytes):
        src = os.path.join(CACHE, "tmp_audio"); open(src, "wb").write(path_or_bytes)
    r = subprocess.run(["ffmpeg", "-v", "error", "-ss", str(off), "-t", str(secs), "-i", src, "-ac", "1", "-ar", "8000", "-f", "f32le", "-"], capture_output=True)
    return np.frombuffer(r.stdout, dtype=np.float32)
def feat(x):
    n, hop = 1024, 400; fr = [x[i:i + n] * np.hanning(n) for i in range(0, max(0, len(x) - n), hop)]
    if not fr: return np.zeros((0, 24))
    S = np.abs(np.fft.rfft(np.array(fr), axis=1))[:, 6:480]; B = np.array_split(S, 24, axis=1); F = np.log1p(np.stack([b.sum(1) for b in B], 1))
    F -= F.mean(0, keepdims=True); F -= F.mean(1, keepdims=True); F /= (np.linalg.norm(F, axis=1, keepdims=True) + 1e-9); return F
def best_corr(loc, cand):
    if len(loc) < 20 or len(cand) < len(loc): return 0.0, 0
    best = (0.0, 0)
    for lag in range(0, len(cand) - len(loc) + 1, 2):
        c = float((loc * cand[lag:lag + len(loc)]).sum(1).mean())
        if c > best[0]: best = (c, lag)
    return best[0], best[1] * 400 / 8000
def match_anthem(local, code):
    loc = feat(pcm(local, 35)); name = COUNTRY.get(code, code); cands = []
    for s in [f"national anthem of {name} filetype:audio", f"{name} national anthem filetype:audio", f"anthem {name} filetype:audio"]:
        try: cands += [r["title"] for r in api(CM, action="query", list="search", srsearch=s, srnamespace=6, srlimit=25)["query"]["search"]]
        except Exception as e: print("   search", e)
    cands = list(dict.fromkeys(cands)); info = file_info(cands); best = None
    for t, f in info.items():
        if not f.get("url") or not (f.get("mime") or "").startswith(("audio", "application/ogg", "video/webm")): continue
        try: data = get(f["url"], True)
        except Exception: continue
        sc, off = best_corr(loc, feat(pcm(data, 240)))
        if best is None or sc > best[0]: best = (sc, f, off)
    return best

def mods(kind, local, f):
    im = Image.open(local) if kind != "imn" else None; m = []
    if kind == "imn": m.append("trunchiat la primele ~35 s, convertit în MP3 (ffmpeg)")
    else:
        if f and f.get("w") and f.get("h"):
            ar, lar = f["w"] / f["h"], im.width / im.height
            if abs(ar - lar) / ar > 0.02: m.append(f"decupat (raport original {ar:.2f}, local {lar:.2f})")
            if max(im.size) < max(f["w"], f["h"]): m.append(f"redimensionat la {im.width}×{im.height} px")
        m.append("recomprimat JPEG")
    return "; ".join(m)

def status(dist, f):
    if dist is None or f is None: return "NEGĂSIT"
    if dist <= 10: return "VERIFICAT"
    if dist <= 16: return "PROBABIL"
    return "NEGĂSIT"
FLAG = re.compile(r"(?i)gfdl|attribution$|^attribution|esa|kogl|godl|european parliament|public domain|pd|unknown|fair use|non-free|nc|nd")

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--only", default="foto,fotbal,imn"); a = ap.parse_args(); only = a.only.split(",")
    out_p = os.path.join(ROOT, "licenses", "assets.json"); res = json.load(open(out_p)) if os.path.exists(out_p) else {}
    rec = SRC["recorded_credit"]
    for kind in ["foto", "fotbal"]:
        if kind not in only: continue
        titles = SRC["foto_titles" if kind == "foto" else "fotbal_titles"]
        for fn in sorted(os.listdir(os.path.join(ROOT, kind))):
            if not fn.lower().endswith(".jpg"): continue
            key = fn[:-4]; local = os.path.join(ROOT, kind, fn); rc = rec[kind].get(key, ""); author_rec = rc.split(" · ")[0]
            print(f"{kind}/{fn} …", end=" ", flush=True)
            try: dist, f, lar = match_photo(local, titles.get(key, ""), author_rec)
            except Exception as e: print("eroare", e); continue
            st = status(dist, f); print(st, dist, f and f["file"])
            res[f"{kind}/{fn}"] = {"kind": kind, "key": key, "subject": titles.get(key), "recorded_credit": rc, "status": st, "hash_distance": dist,
                                   "source": f if st != "NEGĂSIT" else None, "best_candidate": f["file"] if f else None, "modifications": mods(kind, local, f) if st != "NEGĂSIT" else "necunoscut (sursa negăsită)"}
            json.dump(res, open(out_p, "w"), ensure_ascii=False, indent=1)
    if "imn" in only:
        for fn in sorted(os.listdir(os.path.join(ROOT, "imn"))):
            if not fn.lower().endswith(".mp3"): continue
            code = fn[:-4]; print(f"imn/{fn} …", end=" ", flush=True)
            try: b = match_anthem(os.path.join(ROOT, "imn", fn), code)
            except Exception as e: print("eroare", e); continue
            sc, f, off = b if b else (0, None, 0); st = "VERIFICAT" if sc >= 0.85 else "PROBABIL" if sc >= 0.6 else "NEGĂSIT"; print(st, round(sc, 3), f and f["file"])
            res[f"imn/{fn}"] = {"kind": "imn", "key": code, "subject": f"National anthem of {COUNTRY.get(code, code)}", "status": st, "audio_score": round(sc, 3), "offset_s": off,
                                "source": f if st != "NEGĂSIT" else None, "best_candidate": f["file"] if f else None, "modifications": mods("imn", None, f)}
            json.dump(res, open(out_p, "w"), ensure_ascii=False, indent=1)
    write_md(res)

def write_md(res):
    L = ["# ASSET_LICENSES — Pufi", "", "Generat de `tools/asset_audit.py` din fișierele locale, prin potrivire de imagine sau sunet cu Wikimedia Commons. Nimic nu e completat din memorie.", "",
         "Stări: **VERIFICAT** = potrivire sigură (imagine dHash ≤ 10 / sunet ≥ 0,85; altă interpretare a aceluiași imn dă de obicei < 0,6); **PROBABIL** = de confirmat manual; **NEGĂSIT** = sursă necunoscută → înlocuire sau eliminare.", ""]
    from collections import Counter
    cnt = Counter((v["kind"], v["status"]) for v in res.values())
    L += ["| Folder | VERIFICAT | PROBABIL | NEGĂSIT |", "|---|---|---|---|"] + [f"| {k} | {cnt[(k,'VERIFICAT')]} | {cnt[(k,'PROBABIL')]} | {cnt[(k,'NEGĂSIT')]} |" for k in ["foto", "fotbal", "imn"]] + [""]
    for kind in ["foto", "fotbal", "imn"]:
        L += [f"## {kind}/", "", "| Fișier | Stare | Pagina originală | Autor / interpret | Licență | Link licență | Atribuire | Modificări | Note |", "|---|---|---|---|---|---|---|---|---|"]
        for p, v in sorted((p, v) for p, v in res.items() if v["kind"] == kind):
            s = v.get("source") or {}; note = []
            if s.get("restrictions"): note.append("restricții: " + s["restrictions"])
            if s and FLAG.search(s.get("license", "")): note.append("licență de verificat manual")
            if s.get("templates"): note.append("șabloane: " + ", ".join(s["templates"][:6]))
            if v["kind"] == "imn": note.append("compoziția: de verificat separat (vezi șabloanele paginii)")
            if v["status"] == "NEGĂSIT": note.append("cel mai apropiat candidat: " + str(v.get("best_candidate")) + "; credit înregistrat: " + str(v.get("recorded_credit", "")))
            att = f"{s.get('author','')} · {s.get('license','')} · via Wikimedia Commons" if s else ""
            esc = lambda x: str(x or "").replace("|", "\\|").replace("\n", " ")
            L.append(f"| `{p}` | {v['status']} | {esc(s.get('page'))} | {esc(s.get('author'))} | {esc(s.get('license'))} | {esc(s.get('license_url'))} | {esc(att)} | {esc(v.get('modifications'))} | {esc('; '.join(note))} |")
        L.append("")
    open(os.path.join(ROOT, "ASSET_LICENSES.md"), "w").write("\n".join(L) + "\n"); print("Scris: ASSET_LICENSES.md și licenses/assets.json")

if __name__ == "__main__": main()
