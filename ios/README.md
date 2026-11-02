# Pufi — aplicația iOS (iPad + iPhone)

Aplicație SwiftUI care împachetează jocul web (`../index.html` + `foto/`, `imn/`, `fotbal/`) într-un `WKWebView`, offline, plus funcții native:

- **Voce nativă** (`AVSpeechSynthesizer`) — folosește vocile Premium/Enhanced instalate pe aparat; karaoke sincronizat pe cuvinte.
- **🎤 Citesc cu voce** — recunoașterea vorbirii (`SFSpeechRecognizer`, pe aparat când limba o permite) colorează cuvintele citite de copil; la final „Ascultă-te”.
- **🎙️ Vocea părintelui** — 5 laude înregistrate (rămân pe aparat), redate uneori după o reușită.
- **IAP** prin RevenueCat — o singură cumpărare „Deblochează tot”.
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

În Xcode: **Signing & Capabilities → Team** (contul tău), păstrează Bundle ID `ch.hory.pufistars`, adaugă o imagine 1024×1024 în `Assets.xcassets/AppIcon`, apoi Run pe iPad.

La fiecare build, scriptul „Sync web game” recopiază automat `index.html` din rădăcina repo-ului — deci după `git pull` doar dai Run.

## RevenueCat
1. App Store Connect: produs **non-consumable** `unlock_all`.
2. RevenueCat: entitlement `premium`, offering *current* cu un pachet ce conține `unlock_all`.
3. Pune cheia publică iOS (`appl_…`) în `PufiStars/Services/PurchaseService.swift`.
Fără cheie, în Debug totul e deblocat.

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
