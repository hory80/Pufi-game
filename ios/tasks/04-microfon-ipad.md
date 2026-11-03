# Task 04 — Microfonul nu pornește pe iPad-ul fizic („Microfonul nu este disponibil”)

Pe iPad-ul fizic al lui Hory, în **Citește → Povești → „Citesc cu voce” 🎤**, apare „Microfonul nu este disponibil”. Asta înseamnă că `native.call('asr.start', …)` a răspuns `false`. La fel ar trebui să se comporte și „🎤 Dictează” din „Poveste nouă”.

Lucrezi doar în `ios/`, pe branch-ul `ios/microfon-diagnostic`, apoi deschizi PR fără merge.

## 1. Spune-ne exact de ce nu pornește

Jocul (`main`, de la commit-ul „Microfon: afișează motivul exact…”) acceptă deja un răspuns detaliat. Schimbă `asr.start` din `Bridge.swift` așa:

- La succes rămâne **`true`**, ca să nu se schimbe contractul.
- La eșec răspunde **`{"ok": false, "reason": "<cod scurt>"}`**. Jocul afișează codul în paranteză, după mesaj.

Coduri de folosit:

| Cod | Când |
|---|---|
| `speech-denied` | Recunoașterea vorbirii e refuzată de utilizator |
| `speech-restricted` | Recunoașterea vorbirii e restricționată (de exemplu de Timp de utilizare) |
| `speech-notDetermined` | Utilizatorul nu a ales încă |
| `mic-denied` | Permisiunea pentru microfon e refuzată |
| `no-recognizer-<locale>` | `SFSpeechRecognizer(locale:)` întoarce nil |
| `unavailable-<locale>` | Recunoașterea pentru limba respectivă nu e disponibilă acum |
| `session:<mesaj>` | Eroare de la `AVAudioSession` |
| `format:<rate>Hz` | Formatul intrării are sample rate 0 sau 0 canale |
| `engine:<mesaj>` | `AVAudioEngine.start()` a eșuat |
| `other:<mesaj>` | Orice altă eroare |

Scrie același motiv și cu `NSLog("Pufi ASR: …")`.

## 1b. Două comenzi noi în bridge (jocul le folosește deja; dacă lipsesc, după 1,5 s trece mai departe)

- **`asr.perm`** → `{"speech":"authorized|denied|restricted|notDetermined","mic":"granted|denied|undetermined"}`. Doar citește starea, fără să întrebe. Folosește `SFSpeechRecognizer.authorizationStatus()` și `AVAudioApplication.shared.recordPermission`.
- **`openSettings`** → deschide pagina aplicației din Setări (`UIApplication.openSettingsURLString`) și răspunde `true`. Jocul o apelează doar după poarta pentru părinți.

Cum le folosește jocul:
- **La prima pornire a microfonului:** dacă starea e `notDetermined` / `undetermined`, jocul arată întâi o explicație („Pufi are nevoie de microfon…”, cu „Da, permite” / „Nu acum”). Abia după „Da” apelează `asr.start`, care declanșează cererea iOS.
- **Dacă permisiunea e refuzată:** jocul arată pașii din Setări și butonul „⚙️ Deschide Setările”.

## 2. Verifică și repară cauzele probabile

- **`Info.plist`:** există `NSMicrophoneUsageDescription` și `NSSpeechRecognitionUsageDescription`, cu texte clare.
- **Ordinea pornirii:** setezi categoria `.playAndRecord`, faci `setActive(true)` și abia **după aceea** citești `inputNode.outputFormat(forBus: 0)`. Dacă formatul are rata 0, încearcă o dată `inputNode.inputFormat(forBus: 0)`; dacă tot nu merge, întoarce `format:…`.
- **Recunoașterea pe dispozitiv:** `requiresOnDeviceRecognition = true` poate eșua dacă modelul limbii nu e descărcat. Dacă sarcina de recunoaștere dă eroare imediat cu această setare, repornește **o singură dată** fără ea (permite rețeaua) și notează în raport.
- **Concurența (Swift):** blocul `installTap` și callback-ul `recognitionTask` rulează pe fire de fundal, dar clasa e `@MainActor`. Verifică să nu apară avertismente sau crash-uri de izolare. Mută `req.append` / scrierea în fișier într-o funcție `nonisolated`, dacă e nevoie.
- **Sesiunea audio:** după `stop()` sesiunea revine la `.playback`, iar dacă vorbirea (TTS) pornește în timp ce ascultăm, nu trebuie să rupă microfonul. Dacă `speak` vine în timpul ascultării, oprește întâi ascultarea.
- **Dictarea din „Poveste nouă”:** folosește același `asr.start` cu `words: []`. Verifică să apară textul parțial (`asr.partial`).

## 3. Testează pe iPad-ul fizic al lui Hory

- Instalează pe iPad-ul conectat prin cablu (Debug, contul lui Hory sau Personal Team).
- Testează în **română** și în **engleză** (schimbi limba din steagul din joc):
  1. „Citesc cu voce” la „Pufi și mingea”: lângă „Te ascult” trebuie să apară textul auzit, iar rama trebuie să avanseze.
  2. „➕ Poveste nouă” → „🎤 Dictează”: textul trebuie să apară în câmp.
- Dacă tot nu merge, raportează **codul exact** afișat în paranteză și ce scrie în log.
- Verifică și setările iPad-ului și notează-le în raport:
  - Setări → Confidențialitate → **Microfon** → Pufi;
  - Setări → Confidențialitate → **Recunoaștere vorbire** → Pufi;
  - Setări → General → Tastatură → **Activează dictarea**.

## Raport

Ce a fost cauza, ce ai schimbat, rezultatul pe iPad în română și în engleză, plus codurile afișate (dacă au apărut). Nu modifica `index.html`. Răspunde-i lui Hory în română.
