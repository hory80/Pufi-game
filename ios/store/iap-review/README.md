# Capturi pentru review IAP — 6 noiembrie 2026

PNG originale din simulatoare, fără decupare, redimensionare sau text adăugat.
Arată noul meniu Părinți, în engleză, cu produsul `unlock_all` și prețul
StoreKit Test 3 USD. Produsul real are Apple ID `6831593303`.

| Fișier | Simulator / runtime | Dimensiune |
| --- | --- | --- |
| `ipad-iap-review-en.png` | iPad Pro 13-inch (M5), iPadOS 26.1 | 2064 × 2752, portret |
| `iphone-iap-review-en.png` | iPhone 17 Pro, iOS 26.1 | 1206 × 2622, portret |

Provin din testul `PurchaseUITests/testParentGateAndIAPReviewScreenshot`, după
poarta nativă, exportate nemodificate din `PufiParentsPhoneBirthday.xcresult` și
`PufiParentsPadBirthday.xcresult`. Sumele SHA-256 sunt în fișierul alăturat.
Schema PufiStoreKit simulează un utilizator nou după termenul gratuit; ceasul
sistemului și regula Release nu sunt schimbate. Prețul vine din Product.displayPrice.

Sunt capturi pentru review IAP, nu colecția promoțională în 12 limbi. Capturile
vechi au fost înlocuite, inclusiv eliminarea ferestrei Apple cu vechiul meniu.
În App Store Connect este încă salvată captura anterioară: aceasta trebuie
înlocuită cu noul `ipad-iap-review-en.png` înainte de trimitere. Produsul nu a fost
trimis la review.

Separat, Hory a confirmat cumpărarea reală de test Sandbox pe iPhone 16 HR,
persistența accesului după actualizare/relansare și restaurarea explicită din
noul card. Nicio plată reală nu a fost efectuată.
