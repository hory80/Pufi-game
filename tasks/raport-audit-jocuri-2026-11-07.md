# Pufi – audit și îmbunătățirea jocurilor (7 noiembrie 2026)

Raport scris de Claude la cererea lui Hory. Codul din `src/` este sursa de adevăr; `index.html` se generează cu `python3 src/build.py`.

## 1. Ce am verificat și cum

| Verificare | Instrument | Rezultat |
|---|---|---|
| Fiecare zonă se deschide, fiecare joc (card) și primul nivel se încarcă | `src/tests/crawl.cjs` (Playwright), 11 zone, aprox. 70 de carduri | fără erori JS, fără texte `undefined`/`NaN` |
| „Monkey test”: în fiecare joc, 25–40 de atingeri aleatoare pe butoane și elemente, ca un copil | `MONKEY=25..40 node src/tests/crawl.cjs <limbi>` | **0 erori JS** în ro, en, de, fr (iPad 1180×820) și hu, uk (telefon 390×844) |
| Ceasul la „Ore fixe” (bug raportat de Hory) | `src/tests/tmfix.cjs`: acul orar întors înapoi peste 12 | **reprodus** pe versiunea veche (blocaj permanent), **reparat** (6/6 la Gară, 5/5 la Trezire) |
| Exercițiile nu se repetă | test direct pe generatoare: 40 de extrageri la rând | 0 repetări în fereastra de memorie |
| Circuite, Senzori, Mașini simple (refăcute pe 6–7 nov.) | `cir.cjs`, `sens3.cjs`, `mech.cjs` | toate nivelurile se deschid în 12 limbi; câte un nivel din fiecare joc nou jucat automat cap-coadă |

**Limite oneste:**
- Testele automate prind erori, blocaje și texte stricate. Ele **nu** pot dovedi că un joc e mai distractiv sau mai clar pentru un copil de 5 ani; asta cere observarea unui copil care joacă.
- În prima rulare de „monkey test” (germană/franceză) au apărut câteva erori pe care filtrul meu le-a ascuns; în patru rulări ulterioare (de, fr, ro; ultima cu 40 de atingeri pe joc) **nu s-au mai reprodus**. Cauza probabilă: o succesiune aleatoare rară. Rămâne de urmărit (vezi secțiunea 5).
- Vocea (TTS) nu poate fi ascultată în testele automate; am verificat doar textele trimise spre voce.

## 2. Inventarul jocurilor

| Zonă | Jocuri |
|---|---|
| 🔢 Matematică | Adunări și scăderi, Crocodilul lacom, Strada vecinilor, Pinguinii în ordine, Cutia cu secret, Soroban, Face 10 |
| 🧮 Soroban | Școala lui Pufi, Arena Anzan, 12 niveluri, Joacă liberă, Face 10 |
| 🌍 Lumea | Steaguri (cu hartă, monumente, imnuri, fotbaliști) |
| 📖 Citește | Alfabetul, Vânătoarea de sunete, Unde auzi sunetul?, Pescuiește litera (+ acvariu), Scrie cu degetul, Cuvântul magic, Bule cu litere, Trenulețul silabelor, Cuvinte gemene, Citește și alege, Povești (+ Povestea mea) |
| ⏳ Timpul | Ceasul (explorează, baloane, cucu, pizza, gară, memorie, cuptor), Ziua (trezirea, ordinea, programul zilei, momentele zilei, ieri-azi-mâine), Săptămâna și calendarul, Anotimpurile |
| 📐 Forme | Tabla cu elastice, Puzzle cu forme, Cuburi 3D, Ghicește și măsoară |
| 🤖 RoboPufi | Programează-l pe RoboPufi, Mașini simple (6 jocuri, 45 niveluri), Circuite (18), Senzori (6 jocuri, 46 niveluri), Laboratorul de culori, Garajul |
| ♟️ Șah | Partidă cu robotul, Piesele, Culege stelele, Prinde piesa, Salvează regele, Șah mat, Bătălia pionilor |
| 🦊 Pufi | platformer cu 8 lumi |
| 🏝️ Insula | clădiri, animale, decorațiuni, misiunea zilei |

## 3. Audit pe jocuri

V = verificat (reprodus sau măsurat). I = ipoteză, necesită observarea unui copil.

| Joc | Cele mai importante 3 probleme | Îmbunătățire | Prioritate | Stare |
|---|---|---|---|---|
| Timpul › toate jocurile cu ceas | 1. V: acul întors înapoi peste 12 bloca jocul definitiv („altă oră” chiar la răspuns corect, iar Pufi citea o oră fără sens). 2. V: exercițiile se puteau repeta. 3. V: „Programul zilei” avea mereu aceeași listă fixă. | ceasul nu mai poate ajunge la valori negative; memorie anti-repetare; programul zilei generat aleator, în ordinea firească a zilei | **critică** | ✅ reparat |
| Matematică › Adunări, Crocodilul, Strada vecinilor, Cutia cu secret | 1. V: același exercițiu putea reveni imediat. 2. I: la nivelurile mici sunt puține combinații, deci repetarea se simțea repede. 3. I: lipsește o explicație vizuală după a doua greșeală. | anti-repetare pe ultimele 8–10 exerciții | ridicată | ✅ (1), (3) rămâne |
| Lumea › Steaguri | 1. V: la nivelul Ușor (12 țări) steagul putea reveni după o singură rundă. 2. I: distractorii sunt aleatori, nu „plauzibili” (steaguri asemănătoare). 3. I: imnurile/monumentele sunt bonusuri, nu parte din joc. | anti-repetare pe ultimele 8 țări | medie | ✅ (1), (2–3) propuse |
| Soroban (12 niveluri, Face 10, modul vechi) | 1. V: exercițiile puteau reveni. 2. I: Anzan poate fi prea rapid pentru 6 ani. 3. I: lecțiile animate sunt lungi. | anti-repetare | medie | ✅ (1) |
| Citește › Pescuiește, Trenulețul, Cuvântul magic, Citește și alege | 1. V: cuvântul/litera puteau reveni la rând. 2. I: la unele limbi listele de cuvinte sunt scurte. 3. I: diacriticele (ș/ț, ö/ü) trebuie verificate de un vorbitor nativ. | anti-repetare pe ultimele 12 cuvinte / 8 litere | medie | ✅ (1) |
| RoboPufi › Circuite | 1. V: nivelurile se blocau în 9 limbi (traduceri lipsă). 2. puține niveluri. 3. puțină interactivitate. | traduceri, 6 niveluri noi, rezolvitor electric nou | critică | ✅ (6 nov.) |
| RoboPufi › Senzori | 1. doar 3 jocuri scurte. 2. fără progresie. 3. fără repetabilitate. | 6 senzori, 46 niveluri pe hartă | ridicată | ✅ (6 nov.) |
| RoboPufi › Mașini simple | 1. V: la bicicletă răspunsul era mereu „2”. 2. puține runde. 3. fără progresie. | ture aleatoare, 45 niveluri, scripete, catapultă | ridicată | ✅ (6–7 nov.) |
| Forme | 1. I: Tabla cu elastice are o ordine fixă de sarcini (bună pentru învățare, slabă pentru rejucare). 2. I: Cuburi 3D – ordine fixă a tipurilor de sarcini. 3. — | păstrat (ordinea fixă e intenționată pentru progresie) | scăzută | de observat cu copilul |
| Șah | 1. I: „Partida cu robotul” poate fi prea grea fără ajutor. 2. — 3. — | fără modificări (nicio eroare găsită) | scăzută | de observat |
| Platformerul Pufi | nicio eroare în testele automate; dificultatea săriturilor pe telefon trebuie încercată pe dispozitiv | — | scăzută | de testat pe iPhone |
| Insula | nicio eroare; testată anterior de Codex pe dispozitiv | — | — | ok |

## 4. Modificări făcute azi

1. **Ceasul (Timpul)** – `src/tm_module.html`
   - Problema: dacă acul era învârtit înapoi peste 12, valoarea internă devenea negativă, iar orice răspuns, chiar corect, era respins pentru totdeauna; Pufi citea o oră fără sens.
   - Modificare: valoarea ceasului rămâne mereu între 0:00 și 23:59; toate comparațiile folosesc ora pe cadranul de 12.
   - Beneficiu: copilul nu mai rămâne blocat și nu mai aude mesaje greșite.
   - Verificare: reprodus pe versiunea veche (blocat la 7:00), reparat pe cea nouă (6/6 și 5/5).
2. **Anti-repetare comună** – `window.__fresh` în `src/joc-base.html`, folosit în Timp (cucu, pizza, gară, trezire, baloane, cuptor, luni, zile, ieri-azi-mâine, calendar), Matematică (adunări, comparații, cutia cu secret, vecini), Soroban, Face 10, Steaguri și Citește (pescuit, tren, cuvântul magic, citește și alege).
   - Beneficiu: exercițiile se simt noi; copilul nu poate „ghici” din memorie.
   - Verificare: 0 repetări în fereastra de memorie la 40 de extrageri; monkey test fără erori.
3. **Programul zilei** – generat aleator la fiecare joc, cu activitățile în ordinea firească.
4. **Sursele în repo** – `src/` + `src/build.py` + teste în `src/tests/`; instrucțiuni în `AGENTS.md`.

## 5. Ce rămâne (în ordinea priorității)

1. **Observare cu copilul** (15 minute pe zonă): unde se blochează, unde se plictisește, ce nu înțelege din instrucțiunea vorbită. E singura cale reală de a judeca „distractiv” și „clar”.
2. **Erorile rare din prima rulare monkey (de/fr)**: nereproduse în 3 rulări; dacă apar pe dispozitiv, notează jocul și ce s-a apăsat.
3. **Steaguri**: distractori asemănători (aceleași culori/continent) pentru nivelul greu.
4. **Matematică**: după a doua greșeală, o explicație vizuală (numărare cu obiecte) în loc de simplul „mai încearcă”.
5. **Diacritice și liste de cuvinte** la Citește: verificare de un vorbitor nativ pentru hu, pl, uk, ru.
6. **Platformer** pe iPhone (ecran mic): controlul săriturilor.

### Decizii de produs pentru Hory
- Progresul vechi la Senzori și Mașini simple nu s-a mutat pe noile hărți de niveluri (copiii pornesc de la zero). Dacă vrei, se poate transfera.
- Forme și Șah au ordine fixă a sarcinilor; e o alegere de învățare. Dacă vrei rejucare, se pot amesteca.
