# Materiale App Store — captură din simulatoare

Livrarea locală verificată este în `~/Downloads/Pufi-AppStore-2026-11-04/`. O copie este păstrată și în `ios/AppStoreMedia/2026-11-04/`. Fișierele mari nu sunt incluse în Git; raportul și instrumentele sunt versionate. Copiază întregul folder dacă vrei o copie de siguranță.

## Încărcare

În `2026-11-04/upload/` fiecare limbă are două foldere:

- `iphone/screenshots/`: PNG, **1206 × 2622**, portrait; iPhone 17 Pro, Dynamic Island, ecran mediu (6,3″).
- `ipad/screenshots/`: PNG, **2752 × 2064**, landscape; iPad Pro 13″ (M5).
- `iphone/previews/`: trei MP4, **886 × 1920**, portrait.
- `ipad/previews/`: trei MP4, **1600 × 1200**, landscape.

Alege limba și familia dispozitivului în App Store Connect. Încarcă imaginile în ordinea numerelor și cele trei clipuri la App Previews. Pentru clipuri, un cadru de copertă potrivit este la aproximativ 5 secunde. Nu încărca planșele de verificare sau fișierele din `originals/`.

| Folder | Limbă în App Store Connect |
|---|---|
| ro | Romanian |
| de | German |
| en | English (U.K.); aceleași materiale pot fi folosite pentru English (U.S.) |
| fr | French |
| it | Italian |
| es | Spanish (Spain) |
| pt | Portuguese (Brazil) |
| nl | Dutch |
| pl | Polish |
| hu | Hungarian |
| uk | Ukrainian |
| ru | Russian |

## Proveniență și conversii

Aplicație: `com.horace.pufistars`, jocul din commitul **d974308**. Simulatoare iOS/iPadOS **26.5**, cu aplicația reală SwiftUI + WKWebView și jocul împachetat offline. Automatizarea este în ținta de teste; aplicația livrată nu primește controale sau ecrane speciale de captură.

Capturile sunt produse de `simctl io screenshot`; înregistrările, de `simctl io recordVideo`. Navigarea folosește funcțiile și evenimentele reale ale jocului. Stelele din sesiune se câștigă prin deschiderea cardurilor alfabetului, pescuit și rezolvarea nivelurilor RoboPufi; cumpărăturile folosesc magazinul real și aceste stele. Nu se injectează desene, texte promoționale sau progres fictiv.

În `originals/` sunt păstrate înregistrările native și capturile PNG originale. Pentru încărcare, canalul alpha complet opac al PNG-urilor este eliminat fără redimensionare sau modificarea valorilor RGB. Clipurile sunt exporturi fidele ale înregistrărilor, fără decupare, cadre generate, accelerare sau tranziții adăugate. Conversia la rezoluția video Apple și 30 fps este necesară: rezoluția acceptată pentru video diferă de cea a ecranului simulatorului.

Fiecare MP4 are exact 30 secunde, H.264 High Level 4.0, yuv420p, progressive, 30 fps. Ținta de compresie este 10 Mbps, maximum 12 Mbps. Clipurile sunt **fără sunet**: `simctl` nu înregistrează audio. Exportul include o pistă AAC stereo silențioasă, 48 kHz, țintă 256 kbps; nu se adaugă voce sau muzică.

`manifest.json`, `VALIDATION.md` și planșele din `review/` descriu verificările fișierelor finale. Compatibilitatea locală nu înlocuiește procesarea și revizuirea efectivă de către Apple; materialele nu sunt încărcate automat în App Store Connect.

## Cerințe Apple consultate la 4 noiembrie 2026

- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/): ecranul iPhone obligatoriu este Dynamic Island medium; pentru iPad, 13″. Sunt permise până la 10 imagini pe set.
- [App preview specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications/): dimensiuni video distincte, 15–30 s, maximum 30 fps și 500 MB/clip.
- [App previews](https://developer.apple.com/app-store/app-previews/): maximum trei clipuri pe limbă, captură a aplicației reale.

## Reproducere

Instrumentele sunt în `ios/tools/`, iar sesiunea opt-in în `AppStoreCaptureTests.swift`. Citește `ios/tools/APP_STORE_CAPTURE.md` pentru pași. Doar această sesiune dedicată acceptă comenzile de captură din containerul simulatorului; ea nu rulează în aplicația publicată.
