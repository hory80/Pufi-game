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

## Raport (Codex — 5 noiembrie 2026)

- Rezultat complet, 241/241 fișiere: foto VERIFICAT/PROBABIL/NEGĂSIT = **86/0/13**;
  fotbal = **106/0/0**; imn = **25/6/5**.
- JSON-ul este rezultatul automat nemodificat manual; VERIFICAT descrie potrivirea
  fișierului, nu o aprobare juridică globală. Vezi notele de după tabelele ASSET_LICENSES.
- PROBABIL: niciun caz foto. Cele șase audio (BR, DE, IN, NO, PT, RO) au paginile
  originale identificate; comparație suplimentară de semnal/forme de undă = la fel
  în fragmentul comun, corelație PCM 0,9016–0,9885. Fără audiție umană; stările
  rămân PROBABIL. Nu s-a pretins verificare vizuală a unei fotografii inexistente.
- Erori/intervenții: cache-ul folosea numai sufixul URL-ului, identic pentru cereri
  diferite; corectat cu SHA-256 al URL-ului complet, după aprobarea explicită a lui
  Hory. Loturile de 40 au produs HTTP 414 la BE-2; reduse la 10 și reluate din cache.
  La distanță zero se oprește comparația, deoarece un candidat ulterior nu o poate
  îmbunătăți. Pragurile și regula primului candidat la egalitate sunt neschimbate.
- Verificări script: cereri cu sufix identic au răspunsuri/cache separate; reluarea
  aceluiași URL folosește cache-ul corect. Rezultatul cu/fără oprirea la zero este
  identic pe AT-1, AT-2 și AR-1. Inventarul final acoperă exact cele 241 de fișiere,
  fără intrări lipsă sau duplicate.
- Cazuri importante: FR-1 cere CC BY-SA 3.0 pentru fotografie, deși API spune PD
  pentru obiect; KR audio cere CC BY 4.0 pentru interpretare și are avertisment
  teritorial pentru compoziție. RO-3 cere credit Copernicus; KOGL, GODL și
  European Parliament au condiții proprii. Detalii și linkuri în inventar.
- Integrare de Claude: populați și adaptați window.__ASSETS din JSON, apoi aplicați
  filtrarea. Codul actual nu consumă manifestul și așteaptă altă schemă de câmpuri.
- Nu au fost modificate index.html, ios/, foto/, fotbal/ sau imn/.
- Builduri de control iPhone 17 Pro și iPad Pro 13-inch (M5), OS 26.5: PASS.
  Sursele Swift și jocul din copia temporară sunt identice cu depozitul. Aplicația
  a fost pornită pe ambele simulatoare și ecranul principal a fost verificat.
  Fișierele iOS nu au fost modificate sau comise de acest audit.
