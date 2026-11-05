# Pufi — pagini publice pentru App Store

GitHub Pages publică deja `main`, rădăcina depozitului. Paginile devin publice
după integrarea PR-ului și terminarea deployment-ului. Nu schimba sursa Pages.

URL-uri de folosit după verificarea răspunsului HTTP 200:

- Support: https://hory80.github.io/Pufi-game/ios/store/support/
- Privacy: https://hory80.github.io/Pufi-game/ios/store/privacy/
- Disclaimer: https://hory80.github.io/Pufi-game/ios/store/disclaimer/

Paginile au secțiuni în engleză și română (`#english`, `#romana`). Aceleași
URL-uri pot fi folosite pentru cele 12 localizări App Store. Contact public
aprobat: `iptvnou@gmail.com`. Numele personal a fost eliminat la cerere.
Fără JavaScript, formulare, reclame, analiză, cookie-uri sau fonturi externe.

## Publicare

1. Integrează PR-ul în `main`; așteaptă deployment-ul Pages.
2. Verifică public cele trei pagini, navigarea și contactul.
3. Completează Support URL pentru fiecare localizare a versiunii în App Store
   Connect și Privacy Policy URL în App Privacy.
4. Păstrează Apple Standard EULA. Disclaimerul este suplimentar, nu Custom EULA.

Nu confirma declarațiile App Privacy doar pe baza paginilor: verifică buildul
efectiv trimis și serviciile active la lansare.

## Politica și codul aplicației

Politica reflectă configurația actuală: progres, povești, preferințe și data
nașterii opțională local, copie în UserDefaults, laude în `Documents/voices`,
ultima citire în `lastReading.caf`, recunoaștere Apple pe dispozitiv când este
disponibilă sau pe server altfel, verificarea tranzacției și indicator Keychain.
Contextul exercițiului este transmis recognizerului, nu doar fluxul audio.

RevenueCat nu este configurat (`appl_REPLACE_ME`). Actualizează politica și
declarațiile App Store **înainte** de activarea lui ori a altui serviciu care
primește date. Ștergerea aplicației nu garantează eliminarea Keychain/copii backup.

De făcut separat de Claude în `parents()` sau `window.__parentsExtra`: acces
ușor la politica de confidențialitate și disclaimer, ideal ca text local/offline,
fără a permite navigarea web externă. Acest PR nu modifică jocul sau bridge-ul.

Disclaimerul acoperă scopul educativ, rezultatele negarantate, supravegherea,
erorile de voce/conținut, progresul local, recompensele virtuale, materialele
terțe și limitele răspunderii cu păstrarea drepturilor obligatorii. Nu dovedește
licențele Wikimedia și nu garantează aplicabilitatea juridică în toate țările.

Surse verificate la 5 noiembrie 2026:

- [Apple — confidențialitate, retenție și ștergere](https://developer.apple.com/app-store/review/guidelines/#privacy)
- [Apple — Siri, Dictation & Privacy](https://www.apple.com/legal/privacy/data/en/ask-siri-dictation/)
- [Apple — Standard EULA](https://www.apple.com/legal/internet-services/itunes/dev/stdeula/)
- [GitHub Pages — găzduire și jurnale IP](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages)

## Verificare — 5 noiembrie 2026

- Build iPhone 17 Pro / iOS 26.5: PASS.
- Build iPad Pro 13-inch (M5) / iPadOS 26.5: PASS.
- Aplicația instalată și pornită pe ambele simulatoare; ecranul principal vizibil.
- Site: navigare, ancore EN/RO, FAQ expandabil, e-mail și layout mobil/tabletă.
- Linkuri locale și ancore verificate; fără scripturi sau nume personal în HTML.
- Publicarea GitHub Pages: în așteptarea integrării PR-ului în `main`.

Buildurile folosesc `/tmp/PufiSupportBuild`, copia locală a surselor, configurației
și jocului, pentru evitarea blocajelor iCloud. Sincronizare și generare normale.
Jurnale: `/tmp/pufi-support-iphone-build.log`, `/tmp/pufi-support-ipad-build.log`.
