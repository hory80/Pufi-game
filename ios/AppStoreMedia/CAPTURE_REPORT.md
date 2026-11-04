# Raport App Store — 4 noiembrie 2026

Livrare: `~/Downloads/Pufi-AppStore-2026-11-04/`, cu o copie în `ios/AppStoreMedia/2026-11-04/`. Folderul `upload/` conține **216 PNG și 72 MP4**: pentru fiecare dintre cele **12 limbi**, câte **9 capturi și 3 clipuri de exact 30 secunde**, separat pentru iPhone și iPad. Originalele sunt păstrate în `originals/`; planșele de control, în `review/`. Fișierele mari sunt livrate local, nu în PR.

## Dispozitive și formate

| Material | Simulator | Orientare | Dimensiune |
|---|---|---|---|
| Capturi iPhone | iPhone 17 Pro, iOS 26.5 | portrait | 1206 × 2622 |
| Capturi iPad | iPad Pro 13″ M5, iPadOS 26.5 | landscape | 2752 × 2064 |
| App Preview iPhone | același simulator | portrait | 886 × 1920 |
| App Preview iPad | același simulator | landscape | 1600 × 1200 |

Cerințele Apple au fost verificate la data capturii: iPhone Dynamic Island **medium** și iPad **13″** sunt clasele obligatorii. Sursele oficiale și corespondența limbilor sunt în [ghid](README.md).

Clipurile arată pescuitul/acvariul, două niveluri RoboPufi și insula cu magazinul și așezarea/mutarea unei decorațiuni. Capturile mai includ povești cu silabe colorate, matematică, ceas, forme și șah. Scorurile și decorațiunile provin din acțiunile reale ale jocului, fără editarea progresului. Capturarea se face cu `simctl`, din aplicația reală; nu se generează sau compun ecrane promoționale.

PNG-urile pentru upload sunt RGB opace, fără redimensionare. Toate cele **216** au aceleași valori RGB ca originalele, verificate pixel cu pixel. Video: H.264 High Level 4.0, progressive, yuv420p, pixeli pătrați, **900 cadre / 30 fps / 30.000 s**, țintă 10 Mbps, sub 500 MB/clip. Audio: pistă AAC stereo silențioasă, 48 kHz, țintă 256 kbps; simctl nu înregistrează sunetul aplicației. Cinci exporturi cu 899 cadre au fost refăcute din înregistrările native, fără repetarea sau inventarea capturii.

`manifest.json` conține dimensiunile, durata și SHA-256 pentru fiecare fișier de upload. `VALIDATION.md` are rezultatul **PASS — 216 PNG, 72 MP4, 0 erori**. Au fost inspectate planșele tuturor capturilor și cadre la 5/15/25 secunde din fiecare clip; nu se pretinde vizionarea integrală, cadru cu cadru, a tuturor înregistrărilor. Materialele nu au fost încărcate în App Store Connect și nu sunt prezentate ca aprobate deja de Apple.

## Modificări în repo

- `PufiStarsTests/AppStoreCaptureTests.swift`: sesiune opt-in de automatizare în WKWebView-ul aplicației deja vizibile; numai simulator, omisă în testele obișnuite. Nicio facilitate de captură nu intră în aplicația publicată.
- `tools/`: pornirea sesiunilor, navigarea reală și capturarea, exportul video, normalizarea PNG, verificarea formatelor/pixelilor și planșele de control. [Pași de reproducere](../tools/APP_STORE_CAPTURE.md).
- `AppStoreMedia/README.md`, acest raport și `BUILD_REPORT.md`: formate, livrare, proveniență și limitări.
- `.gitignore`: exclude exporturile mari locale și cache-ul Python.

Codul produsului, bundle identifier-ul și contractul bridge-ului nu sunt modificate. `index.html`, `foto/`, `imn/`, `fotbal/`, WebContent generat și proiectul Xcode generat nu sunt incluse în commit.

## Build și rulare

- Build iPhone 17 Pro: **PASS** (`build-for-testing`).
- Build iPad Pro 13″ M5: **PASS** (`build`).
- Lansare normală după încheierea capturilor, fără sesiunea de test: **PASS**, joc vizibil pe ambele simulatoare.
- Cele două sesiuni reale de captură XCTest: **PASS**.
- Rulare obișnuită a noului test: **SKIP corect**, fără activarea capturii.
- Verificare suplimentară `EntitlementPolicyTests`: **7/8 teste trec**; testul existent `testKeychainFlagSurvivesNewStoreInstance` eșuează la trei aserțiuni în build-ul nesemnat pentru simulator (`CODE_SIGNING_ALLOWED=NO`). Nu declar suita completă trecută. Implementarea Keychain nu este modificată în acest PR.

Xcode a rămas blocat într-o citire coordonată iCloud a proiectului din Documents (confirmat prin stack sample). Verificările finale s-au făcut dintr-o copie locală a acelorași surse native și a jocului deja împachetat, cu versiunile de pachete fixate. Doar în proiectul temporar a fost omis pasul de recopie a jocului; conținutul era deja identic. SHA-256 al `index.html` din repo și din acel pachet: `bec7ceafdbb937f44ee63a5938f2e1d24d1449f0023a263860cae8656c3fe928`.

## Proveniență și observații web

Joc capturat: **d974308**; bundle **com.horace.pufistars**, versiunea 1.0 (1). Nu s-au modificat fișierele jocului. Pe iPhone portrait, titlul insulei se îngustează și se rupe pe mai multe rânduri în unele limbi lungi (de exemplu FR/NL); capturile păstrează exact comportamentul existent. O eventuală ajustare ar trebui făcută în header-ul `#isl-root .rb-top`/`#isl-title` din `index.html`, de agentul care întreține web-ul. Nu este necesară o modificare web pentru formatele de upload livrate.
