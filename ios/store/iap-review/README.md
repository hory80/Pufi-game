# Capturi pentru review IAP — 6 noiembrie 2026

PNG originale din simulatoare, fără decupare, redimensionare, text adăugat sau UI
inventat. Interfață în engleză, produsul Apple `unlock_all`, preț StoreKit Test
3,00 USD. În App Store Connect, produsul real are Apple ID `6831593303`.

| Fișier | Dispozitiv / runtime | Dimensiune | Utilizare |
| --- | --- | --- | --- |
| `ipad-iap-review-en.png` | iPad Pro 13-inch (M5), iPadOS 26.1 | 2064 × 2752 | Captura încărcată în Review Information → Screenshot pentru IAP |
| `iphone-iap-review-en.png` | iPhone 17 Pro, iOS 26.1 | 1206 × 2622 | Alternativă: secțiunea Părinți cu preț și restaurare |
| `iphone-apple-sheet-test-en.png` | iPhone 17 Pro, iOS 26.1 | 1206 × 2622 | Referință: fereastra reală Apple, etichetată Xcode, cu plata unică de 3 USD |

Acestea sunt capturi pentru **review-ul produsului IAP**, nu înlocuitori pentru
colecția de capturi promoționale în 12 limbi. iPad-ul a fost capturat în portret.
Captura ferestrei Apple este dintr-o probă UI anterioară, verificată vizual;
fluxul final automat capturează numai secțiunea Părinți, după poarta nativă.

Înaintea capturii: scenariu Debug cu un utilizator nou după 15 decembrie 2026,
fără a schimba ceasul sistemului sau regula din Release. Prețul vine din
`Product.displayPrice`, nu dintr-un text introdus pentru captură. Cumpărările și
restaurarea au fost verificate cu StoreKit Test, separat de serverele Sandbox.
Nu s-a efectuat nicio plată reală.

Reproducere: schema Xcode **PufiStoreKit**, apoi Home → Parents → poarta pentru
părinți → Full version. Testul `PurchaseUITests/testParentGateAndIAPReviewScreenshot`
produce atașamentul `Pufi-IAP-Review-English`; exportă-l prin `xcresulttool`.

Captura iPad și instrucțiunile pentru review au fost salvate în App Store
Connect. Produsul rămâne **Prepare for Submission**; nu a fost trimis la review.
