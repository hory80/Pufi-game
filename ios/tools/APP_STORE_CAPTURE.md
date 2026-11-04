# Captură reală pentru App Store

Prerechizite: Xcode + XcodeGen, iOS/iPadOS 26.5, ffmpeg/ffprobe în `/opt/homebrew/bin/`. Dispozitivele folosite la livrarea din 4 noiembrie 2026 sunt iPhone 17 Pro și iPad Pro 13″ (M5). Verifică din nou [cerințele Apple](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/) înaintea unei sesiuni viitoare.

Instrumentele nu schimbă jocul web sau interfața publicată. Un test găsește WKWebView-ul aplicației deja afișate și execută navigarea/controalele jocului. Sesiunea există numai pe simulator, numai dacă fișierul `Documents/AppStoreCapture/enabled` este prezent, și se oprește explicit la final. În testele obișnuite este omisă.

1. Din rădăcina repo-ului, pornește `ios/tools/start_store_capture.sh` într-un terminal. Acesta construiește pentru ambele dispozitive și lasă două sesiuni de test active. Așteaptă pornirea aplicației pe ambele simulatoare.
2. Din alt terminal, setează iPhone portrait și iPad landscape:

   ```sh
   python3 ios/tools/app_store_capture.py iphone --action portrait
   python3 ios/tools/app_store_capture.py ipad --action landscape
   ```

   În Device Hub rotește fizic simulatorul iPad în landscape; verifică prin captură că aplicația este fullscreen, fără desktop, dock sau ferestre de sistem. Nu folosi o simplă rotire a imaginii ulterior.
3. Rulează cele două capturi (în terminale separate sau procese paralele):

   ```sh
   python3 ios/tools/app_store_capture.py iphone --all
   python3 ios/tools/app_store_capture.py ipad --all
   ```

   `--languages ro de en` limitează o probă. `PUFI_IPHONE_UDID` și `PUFI_IPAD_UDID` schimbă dispozitivele; păstrează modelele/dimensiunile din raport. `PUFI_MEDIA_OUTPUT` schimbă destinația (implicit `ios/AppStoreMedia/2026-11-04`). La reluare, clipurile deja existente sunt păstrate; validează-le înainte de a considera o sesiune întreruptă completă. Un MP4 incomplet trebuie recapturat.
4. După ambele loturi, `python3 ios/tools/finalize_store_capture.py` așază decorațiunile câștigate prin controalele reale, completează imaginile românești și reînregistrează demonstrațiile de mutare a unei decorațiuni pentru RO/RU. Operația reface local cele patru clipuri respective.
5. Normalizează și verifică setul:

   ```sh
   xcrun swiftc -O -module-cache-path /tmp/pufi-swift-module-cache ios/tools/normalize_store_png.swift -o /tmp/pufi-normalize-png
   /tmp/pufi-normalize-png ios/AppStoreMedia/2026-11-04
   python3 ios/tools/verify_store_media.py ios/AppStoreMedia/2026-11-04
   python3 ios/tools/make_store_review.py ios/AppStoreMedia/2026-11-04
   xcrun swift -module-cache-path /tmp/pufi-swift-module-cache ios/tools/make_store_contact_sheets.swift ios/AppStoreMedia/2026-11-04
   ```

   Planșele sunt doar pentru control, în `review/`; nu se încarcă în App Store. Compară vizual limbile, ecranele și cadrele video. Dacă Documents/iCloud dă erori temporare de citire, folosește o copie locală verificată pentru conversii și apoi păstrează livrarea într-un folder local disponibil pentru încărcare.
6. Oprește testele:

   ```sh
   python3 ios/tools/app_store_capture.py iphone --action stop
   python3 ios/tools/app_store_capture.py ipad --action stop
   ```

   Implementarea finală șterge activarea la ieșire. La o oprire forțată, elimină numai folderul temporar `Documents/AppStoreCapture` din containerul simulatorului înainte de a rula întreaga suită de teste.

Originalele simctl sunt păstrate în `originals/`. PNG-urile pentru upload au aceleași dimensiuni și valori RGB, fără canalul alpha opac. MP4-urile păstrează înregistrarea reală, convertită la rezoluțiile video Apple, fără accelerare, montaje sau imagini generate. Audio este o pistă AAC silențioasă; simctl nu captează sunetul aplicației.
