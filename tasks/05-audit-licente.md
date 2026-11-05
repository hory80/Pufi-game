# Task 05 — Auditul de proveniență pentru foto/, fotbal/, imn/ (Wikimedia Commons)

Pentru App Store trebuie să dovedim de unde vine fiecare fotografie și fiecare înregistrare. Claude a scris scriptul, dar mediul lui nu are acces la Wikimedia, așa că **tu (Codex) îl rulezi pe Mac mini**, care are internet.

**Nu modifica `index.html` și nici `ios/`.** Ai voie să adaugi sau să modifici doar `licenses/assets.json`, `ASSET_LICENSES.md` și raportul de la finalul acestui fișier.

## Pași

1. `git checkout main && git pull`, apoi creează branch-ul `assets/audit-licente`.
2. Pregătește mediul:
   - `python3 -m pip install --user pillow numpy`;
   - verifică că `ffmpeg` există (`ffmpeg -version`); dacă nu, `brew install ffmpeg`.
3. Rulează `python3 tools/asset_audit.py`.
   - Durează 30–90 de minute, pentru că descarcă miniaturi și, la imnuri, fișierele audio.
   - E politicos cu serverele Wikimedia (pauze, User-Agent, reîncercări la 429).
   - Dacă se întrerupe, îl rulezi din nou: continuă din cache (`licenses/.cache/`, ignorat de git).
   - Poți rula și pe bucăți: `--only foto`, apoi `--only fotbal`, apoi `--only imn`.
4. **Nu „repara” manual rezultatele.** Scriptul acceptă doar potriviri prin comparare de imagine sau sunet:
   - **VERIFICAT**: imagine dHash ≤ 10, sunet ≥ 0,85;
   - **PROBABIL**: între praguri;
   - **NEGĂSIT**: fără potrivire.
5. **PROBABIL** (maximum 20 de fișiere): deschide pagina Commons și compară vizual cu fișierul local. Notează în raport, pentru fiecare: „la fel” sau „diferit”. Nu schimba JSON-ul.
6. Commit pentru `licenses/assets.json` și `ASSET_LICENSES.md` (regenerat de script). Apoi `git pull --rebase origin main`, push și un PR spre `main` cu titlul „Audit licențe foto/fotbal/imn”, **fără merge**.

## Raport (completează Codex)

- Rezultat: foto VERIFICAT/PROBABIL/NEGĂSIT = …; fotbal = …; imn = …
- PROBABIL verificate vizual: …
- Erori sau întreruperi: …
