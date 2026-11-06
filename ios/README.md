# Pufi — aplicația iOS (iPad + iPhone)

Aplicație SwiftUI care împachetează jocul web (`../index.html` + `foto/`, `imn/`, `fotbal/`) într-un `WKWebView`, offline, plus funcții native:

- **Voce nativă** (`AVSpeechSynthesizer`) — folosește vocile Premium/Enhanced instalate pe aparat; karaoke sincronizat pe cuvinte.
- **🎤 Citesc cu voce** — recunoașterea vorbirii (`SFSpeechRecognizer`, pe aparat când limba o permite) colorează cuvintele citite de copil; la final „Ascultă-te”.
- **🎙️ Vocea părintelui** — 5 laude înregistrate (rămân pe aparat), redate uneori după o reușită.
- **IAP** direct prin Apple StoreKit 2 — o singură cumpărare „Deblochează tot”.
- **Poarta pentru părinți** înaintea panoului Părinți (deci și a cumpărării).
- **Copie de siguranță a progresului** (localStorage → UserDefaults).

## Pași (prima dată)

```sh
brew install xcodegen          # o singură dată
cd ios
./sync_web.sh                  # copiază jocul în PufiStars/WebContent
xcodegen                       # generează PufiStars.xcodeproj
open PufiStars.xcodeproj
```

În Xcode: **Signing & Capabilities → Team** (contul tău), păstrează Bundle ID `com.horace.pufistars`, adaugă o imagine 1024×1024 în `Assets.xcassets/AppIcon`, apoi Run pe iPad.

La fiecare build, scriptul „Sync web game” recopiază automat `index.html` din rădăcina repo-ului — deci după `git pull` doar dai Run.

## Achiziția permanentă (StoreKit 2)

Produsul App Store Connect este **non-consumable** `unlock_all` (Apple ID
`6831593303`), cu preț de bază **3,00 USD**. Prețul afișat în aplicație vine
întotdeauna din `Product.displayPrice`, în moneda magazinului utilizatorului.
Nu sunt necesare chei sau un serviciu terț. Aplicația verifică tranzacțiile Apple,
ascultă aprobările/rambursările și restaurează prin `AppStore.sync()`.
Contractul JS `iap.status/price/buy/restore` rămâne identic.

Pentru teste locale și capturi: generează proiectul, alege schema
**PufiStoreKit** și un simulator, apoi Run în Xcode. Schema folosește
`StoreKit/Pufi.storekit` și argumente exclusiv Debug pentru un utilizator nou
după 15 decembrie. Trece poarta pentru părinți înainte de cumpărare. Aceste
tranzacții sunt de test, fără bani reali. Configurația nu este inclusă în app;
numai bundle-urile de teste o includ ca resursă.

Schema normală **PufiStars**, configurația Release/Archive și App Store folosesc
produsele reale Apple. Debug normal rămâne deblocat. Argumentul
`-PufiStoreKitTest` permite tranzacțiile StoreKit cu scenariul Debug izolat:
nu se citește AppTransaction și nu se modifică Keychain. Fără fișier StoreKit
selectat în schema Xcode, aceeași configurație Debug poate fi folosită pentru
proba Sandbox a produsului real, pe dispozitiv, cu un cont Sandbox Apple.

Înainte de lansare trebuie testată și cumpărarea/restaurarea în **Sandbox**, cu
produsul real complet configurat, și trimis primul IAP împreună cu versiunea app.
Testele locale nu confirmă încă funcționarea produsului pe serverele App Store.

## Limbi pentru voce/recunoaștere
`SpeechService.locales`: ro, de, en, fr, it, es, pt, nl, pl, hu, uk, ru. Pentru voce mai bună: pe iPad, Setări → Accesibilitate → Conținut vorbit → Voci → descarcă varianta „Enhanced/Premium” pentru fiecare limbă.

## De verificat pe aparat
- Recunoașterea în **română**: `native.call('asr.available',{lang:'ro'})` → `onDevice`. Dacă e `false`, audio trece prin serverele Apple — de menționat în politica de confidențialitate.
- Categoria **Kids**: fără analytics/ads terțe; linkurile externe sunt blocate în `GameWebView`.

## Numele aplicației
- Sub iconiță (pe ecranul principal): **Pufi** (`CFBundleDisplayName`). Un nume lung ar fi tăiat de iOS.
- Numele din App Store (max. 30 de caractere), per limbă:
  ro „Pufi – Școala jocurilor” · de „Pufi – Die Spieleschule” · en „Pufi – The Game School” · fr „Pufi – L’école des jeux” · it „Pufi – La scuola dei giochi” · es „Pufi – La escuela de juegos” · pt „Pufi – A escola dos jogos” · nl „Pufi – De spelletjesschool” · pl „Pufi – Szkoła zabaw” · hu „Pufi – A játékiskola” · uk „Пуфі – Школа ігор” · ru „Пуфи – Школа игр”

## Verificare automată

```sh
xcodebuild -project PufiStars.xcodeproj -scheme PufiStars \
  -destination 'platform=iOS Simulator,name=iPad (A16),OS=26.5' \
  -derivedDataPath /tmp/pufi-derived -parallel-testing-enabled NO \
  -collect-test-diagnostics never test
```

Alege un simulator instalat. Folosește o destinație iPhone pentru a repeta verificarea.
Într-un folder sincronizat cu iCloud, păstrează DerivedData în `/tmp`: metadatele
Finder adăugate automat pot invalida semnarea simulatorului. Nu este nevoie de
un Developer Team pentru simulatoare. Pentru un aparat fizic, Hory trebuie să
aleagă propriul Team în Signing & Capabilities.

Testele verifică jocul împachetat, bridge-ul real WKWebView, vocea nativă,
Debug IAP fără cheie, copia progresului, blocarea navigării externe, poarta și
orientările. Calitatea microfonului, recunoașterea românei pe aparat și
cumpărările reale trebuie verificate pe dispozitiv.

## Lansare gratuită și utilizatori existenți

Bundle identifier-ul confirmat de Hory este **`com.horace.pufistars`**. Modifică
configurația în `project.yml`, nu doar proiectul Xcode generat. Pictograma este
păstrată în Git la `PufiStars/Assets.xcassets/AppIcon.appiconset/PufiIcon-1024.png`;
`xcodegen` și sincronizarea jocului nu o regenerează și nu o șterg.

Până la **15 decembrie 2026, ora 00:00 Europe/Zurich**
(`2026-12-14T23:00:00Z`) accesul este complet. După această dată, rămâne complet
pentru utilizatorii cu o dată originală de achiziție anterioară limitei, verificată
prin StoreKit `AppTransaction.shared`, sau cu o tranzacție Apple verificată și nerevocată pentru `unlock_all`.
Eligibilitatea timpurie se păstrează în Keychain pe aparat. Pe un aparat nou,
tranzacția verificată a aceluiași Apple ID permite restabilirea eligibilității.
Dacă StoreKit nu răspunde, `iap.status` folosește rezultatul local după cel mult
3 secunde; o cerere StoreKit aflată în curs nu este duplicată. Pagina jocului se
încarcă independent de această verificare.

În Debug, implicit totul este deblocat. Pentru scenarii deterministe, adaugă în
**Scheme → Run → Arguments** sau la `simctl launch`:

| Scenariu | Argumente |
| --- | --- |
| Înainte de limită | `-PufiNow 2026-12-14T22:59:59Z -PufiOriginalPurchase none` |
| Utilizator vechi după limită | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase 2026-12-14T22:59:59Z` |
| Utilizator nou după limită | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase none` |
| Utilizator nou cu versiunea completă | `-PufiNow 2026-12-15T00:00:00Z -PufiOriginalPurchase none -PufiPremium true` |

Oricare dintre aceste argumente activează un scenariu izolat: fără StoreKit,
cumpărături sau modificarea Keychain-ului real. `PufiPremium` simulează un
entitlement activ; nu efectuează o cumpărătură. Toate argumentele sunt excluse din
Release. Data-limită este strictă: o achiziție exact la limită nu califică pentru
acces permanent gratuit.
