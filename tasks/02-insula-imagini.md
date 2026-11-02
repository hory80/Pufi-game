# Task 02 — Imaginile pentru Insula lui Pufi

Hory vrea ca Insula lui Pufi să arate mai real și mai atractiv, ca un joc 3D pentru copii, nu desenată pe calculator. Tu (Codex) **generezi imaginile** de mai jos și le **salvezi în repo**. Claude le optimizează apoi și le pune în joc. **Nu modifica `index.html` și nu scrie cod de joc.**

## Unde salvezi

- Folderul: **`isl/raw/`**, în rădăcina repo-ului (`~/Documents/IOS Apps/Pufi-game/isl/raw/`).
- Numele fișierelor sunt **exact** cele din titlurile de mai jos, cu litere mici, de exemplu `isl/raw/bg-day.png`.
- Formatul: **PNG**. Pentru sprite-uri (tot în afară de `bg-day` și `bg-night`) e nevoie de **fundal transparent (canal alfa)**.
- Excepție de la `AGENTS.md`: pentru acest task ai voie să adaugi fișiere **doar** în `isl/raw/` și în `tasks/02-insula-imagini.md` (secțiunea „Raport”).

## Pași

1. `git checkout main && git pull`, apoi creează branch-ul `assets/insula-imagini`.
2. Generează imaginile **în ordinea din listă**, cu instrumentul tău de generare de imagini, la **mărimea exactă** de pe fiecare titlu (`1536×1024` sau `1024×1024`). Promptul se folosește **exact cum e scris** (blocul `text`), fără să-l scurtezi.
3. **Consecvența setului:**
   - `bg-night.png` se face **editând** `bg-day.png`, nu din nou de la zero.
   - `pufi-walk`, `pufi-sleep`, `pufi-jump` primesc ca **imagine de referință** `pufi-idle.png`. La fel `egg-2` și `egg-3` primesc `egg-1.png`, iar animalele primesc `pufi-idle.png`, dar doar pentru stil.
   - Toate imaginile au aceeași paletă, același unghi de cameră (cam 30° de sus), aceeași lumină (din stânga-sus) și același stil (jucărie 3D din lut/vinil, mat).
4. **Verifică fiecare imagine** înainte s-o păstrezi. Dacă una nu trece, regenereaz-o (maximum 3 încercări), apoi notează în raport.
   - mărimea în pixeli e exactă (`sips -g pixelWidth -g pixelHeight fișier.png` pe Mac);
   - sprite-urile au transparență reală (`sips -g hasAlpha fișier.png` → `yes`); fără pătrățele „de transparență” pictate în imagine;
   - **niciun text, nicio literă, nicio cifră, niciun logo sau watermark**;
   - obiectul e întreg, centrat, cu margine liberă, iar baza stă puțin deasupra marginii de jos;
   - `bg-day`: pajiștea din mijloc e **goală** (fără case, copaci sau pietre);
   - `b-time`: cadranul ceasului **nu are limbi și nu are cifre**.
   - Dacă instrumentul tău nu poate face fundal transparent, folosește fundalul **magenta plin `#FF00FF`** cerut în prompt. Claude îl scoate. Notează asta în raport.
5. Fă o planșă de control: `isl/raw/_contact-sheet.png`, cu toate imaginile mici, în grilă, cu numele dedesubt. Ajută la verificarea vizuală.
6. Completează „Raport” la finalul acestui fișier: ce s-a generat, ce a eșuat, ce instrument ai folosit și dacă transparența e reală sau magenta.
7. Commit, `git pull --rebase origin main`, push, apoi deschide un **pull request** spre `main` cu titlul „Insula lui Pufi: imagini (etapa 1)”. **Nu face merge.** Răspunde-i lui Hory în română, pe scurt.

Dacă nu ai deloc acces la generare de imagini, oprește-te și spune-i lui Hory. Nu desena imaginile cu cod, SVG sau alte scripturi.

## Paleta comună (pentru verificare)

| Rol | Culoare |
|---|---|
| Mare turcoaz | `#2EC4D6` |
| Mare adâncă | `#1A8FC9` |
| Nisip | `#F6D58E` |
| Iarbă / umbră | `#7ED957` / `#4CAF50` |
| Coral (acoperișuri) | `#FF6B6B` |
| Floarea-soarelui | `#FFC93C` |
| Cer | `#8FD8FF` |
| Liliac | `#B79CFF` |
| Lemn cald | `#C68A4E` |
| Crem | `#FFF6E5` |
| Blana lui Pufi | `#FF8A3D` |

## Lista imaginilor

Etapa 1 = imaginile 1–21 (obligatorii). Etapa 2 = animalele 22–33 (fă-le după etapa 1, în același PR dacă ai timp).

## Etapa 1 — fundalul (generează-le primele)

### 1. `isl/raw/bg-day.png` — 1536×1024 px

Insula ziua: fundalul întregului ecran. Fără clădiri, jocul le pune singur.

```text
Wide 3:2 landscape illustration for a kids' game background. A single round tropical island in a calm sea. Horizon line at 28% from the top; above it a soft sky gradient from #8FD8FF at the top to #DDF4FF at the horizon, with 2 small fluffy white clouds near the top corners — no sun, no moon, no birds. The island is centered and spans about 86% of the image width; its grassy top surface spans from 36% to 80% of the image height. The grassy top is a LARGE, FLAT, EMPTY meadow in grass green #7ED957 with a few tiny flowers only near its edges — no buildings, no trees, no rocks, no paths and no objects in the middle 70% of the meadow (game objects will be placed there later). A ring of warm sand beach #F6D58E around the meadow, soft white foam where sand meets water. Exactly two palm trees at the far left end of the island and two at the far right end. A small grey rock with a flat top standing in the sea at the lower right (centered about 88% from the left and 78% from the top), for a lighthouse. Sea turquoise #2EC4D6 near the shore fading to deep #1A8FC9 at the bottom, gentle stylized ripples. Cozy, sunny, peaceful.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 2. `isl/raw/bg-night.png` — 1536×1024 px

Aceeași insulă noaptea. Se face EDITÂND `bg-day.png` (dă-i imaginea ca intrare și promptul de mai jos).

```text
Edit the attached island image. Keep the composition EXACTLY the same: same island shape, same meadow, same palm trees, same rock, same camera, same size. Change only the lighting to a calm, cozy night: sky gradient from #142456 at the top to #2C3E80 at the horizon, sea #1C3D7A with soft moonlit silver reflections, grass and sand darker and slightly blue-tinted, palm trees as soft dark shapes. Do NOT add a moon, stars, lights or any new objects — the game adds them. No text, no watermark.
```

## Etapa 1 — cele 8 clădiri (una pentru fiecare card)

### 3. `isl/raw/b-time.png` — 1024×1024 px

Card: Timpul. Turnul cu ceas. Limbile ceasului le desenează jocul, cu ora reală.

```text
A slender, tall fairy-tale clock tower for a children's island: cream white #FFF6E5 walls with warm wood #C68A4E trim, a pointed coral red #FF6B6B roof with a tiny golden ball on top, small arched windows, a round wooden door at the bottom. Near the top, a big round clock face facing the viewer: a plain cream white disc with 12 small dark dots around the edge — NO clock hands and NO numbers (the game draws the hands). The clock face is centered horizontally on the tower.

Composition: one single object, centered horizontally, fully visible, the object about 34% of the image width and about 84% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 4. `isl/raw/b-read.png` — 1024×1024 px

Card: Citește. Biblioteca.

```text
A cozy little library building for a children's island: soft pink #FFD9E2 walls, a rounded blue roof #5B7FDE, a big round front window showing colorful book spines inside, a wooden round door, a small reading bench outside with a stack of colorful books, a sign above the door shaped like an open book (no letters on it), little flower pots.

Composition: one single object, centered horizontally, fully visible, the object about 70% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 5. `isl/raw/b-math.png` — 1024×1024 px

Card: Matematică. Turnul cifrelor din cuburi de jucărie (cu puncte ca pe zar, fără cifre).

```text
A playful tower built from 6 stacked chunky toy blocks, slightly staggered, each block a different color — coral red #FF6B6B, sunflower yellow #FFC93C, grass green #7ED957, sky blue #8FD8FF, lilac #B79CFF, orange #FF9F43 — each block shows white dots like dice faces (1 to 6 dots) instead of numbers, a tiny window and a small door in the bottom block, a little triangular flag on top.

Composition: one single object, centered horizontally, fully visible, the object about 40% of the image width and about 85% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 6. `isl/raw/b-world.png` — 1024×1024 px

Card: Lumea. Farul (stă pe stânca din dreapta).

```text
A classic chubby lighthouse standing on a small grey rock base: white tower with coral red #FF6B6B horizontal stripes, a balcony with a little railing, a glass lantern room glowing soft warm yellow #FFE27A, a red dome roof with a tiny globe-shaped weathervane on top, a small round wooden door at the bottom.

Composition: one single object, centered horizontally, fully visible, the object about 34% of the image width and about 86% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 7. `isl/raw/b-shapes.png` — 1024×1024 px

Card: Forme. Casa formelor geometrice.

```text
A whimsical small house built from big geometric shapes: an orange cube #FFB347 as the base with a round door, a large green sphere #7ED957 sitting on top of it with round porthole windows, and a blue cone-shaped roof #4AA8FF on top of the sphere, a small yellow star on the very tip, little triangle and circle shaped garden decorations at the base.

Composition: one single object, centered horizontally, fully visible, the object about 52% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 8. `isl/raw/b-robo.png` — 1024×1024 px

Card: RoboPufi. Atelierul roboților.

```text
A small friendly robot workshop / garage: lavender-blue walls #D9E4FF, a flat roof with a short chimney releasing one soft white steam puff, a big sunflower-yellow #FFC93C gear mounted on the front wall, a half-open rolling garage door with a small cute round robot (big round eyes, antenna, cream and light blue colors) peeking out, a toolbox and a few springs and bolts near the door.

Composition: one single object, centered horizontally, fully visible, the object about 66% of the image width and about 64% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 9. `isl/raw/b-chess.png` — 1024×1024 px

Card: Șah. Castelul de șah.

```text
A small fairy-tale castle whose towers look like chess rooks: light stone #E6E9F2 walls, a taller central tower and two shorter side towers with crenellated tops, lilac #B79CFF pennant flags, a band of black-and-white checkerboard pattern around the central tower, an arched wooden gate, tiny round windows.

Composition: one single object, centered horizontally, fully visible, the object about 62% of the image width and about 78% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 10. `isl/raw/b-pufi.png` — 1024×1024 px

Card: Pufi. Căsuța lui Pufi.

```text
A cozy cottage for a little fox: peach walls #FFE0C7, a terracotta roof #C0603A, a round wooden front door, window boxes with flowers, a brick chimney with a soft curl of smoke, a small white picket fence on one side, two sunflowers next to the house, a tiny fox-tail shaped weathervane on the roof.

Composition: one single object, centered horizontally, fully visible, the object about 62% of the image width and about 66% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 11. `isl/raw/b-site.png` — 1024×1024 px

Locul gol unde se construiește (și schela peste clădirile mici).

```text
A small friendly construction plot: a low wooden scaffolding frame, a neat stack of coral and cream bricks, a small sunflower-yellow #FFC93C toy crane, one orange traffic cone, a little wheelbarrow with sand. Simple, tidy, cheerful, not messy.

Composition: one single object, centered horizontally, fully visible, the object about 60% of the image width and about 58% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

## Etapa 1 — Pufi și oul

### 12. `isl/raw/pufi-idle.png` — 1024×1024 px

Pufi stă și salută. Generează-l primul dintre Pufi; e referința pentru celelalte trei.

```text
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: standing on his hind legs facing the viewer, one paw raised waving hello, big happy smile, tail curled to the side.

Composition: one single object, centered horizontally, fully visible, the object about 48% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 13. `isl/raw/pufi-walk.png` — 1024×1024 px

Pufi merge spre dreapta. Dă `pufi-idle.png` ca imagine de referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: walking to the RIGHT in side view (three-quarter), mid-step, tail up, cheerful expression.

Composition: one single object, centered horizontally, fully visible, the object about 54% of the image width and about 78% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 14. `isl/raw/pufi-sleep.png` — 1024×1024 px

Pufi doarme (noaptea). Dă `pufi-idle.png` ca imagine de referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: curled up asleep on the ground, eyes closed, peaceful smile, fluffy tail wrapped around him like a blanket.

Composition: one single object, centered horizontally, fully visible, the object about 60% of the image width and about 48% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 15. `isl/raw/pufi-jump.png` — 1024×1024 px

Pufi sare de bucurie. Dă `pufi-idle.png` ca imagine de referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: jumping for joy in the air, both front paws raised, eyes happily closed, big open smile, tail swinging.

Composition: one single object, centered horizontally, fully visible, the object about 52% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 16. `isl/raw/egg-1.png` — 1024×1024 px

Oul întreg.

```text
A single large surprise egg: smooth cream white #FFF6E5 shell with soft pastel spots in pink #FFB3C7, sky blue #8FD8FF and mint green #A8E6CF, a gentle glossy highlight, standing upright.

Composition: one single object, centered horizontally, fully visible, the object about 44% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 17. `isl/raw/egg-2.png` — 1024×1024 px

Același ou, crăpat. Dă `egg-1.png` ca imagine de referință.

```text
Use the attached image as reference: exactly the same egg, same spots and colors. The egg now has a zig-zag crack across its upper half with a tiny warm glow coming out of the crack.

Composition: one single object, centered horizontally, fully visible, the object about 44% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 18. `isl/raw/egg-3.png` — 1024×1024 px

Oul deschis (două jumătăți de coajă, gol). Dă `egg-1.png` ca imagine de referință.

```text
Use the attached image as reference: same eggshell colors and spots. The egg has hatched: the bottom half of the shell stands open and empty, the top half lies tilted next to it, a few tiny shell pieces and small golden sparkles around.

Composition: one single object, centered horizontally, fully visible, the object about 60% of the image width and about 48% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

## Etapa 2 — animalele din ouă (opțional, după ce etapa 1 e gata)

### 19. `isl/raw/a-bunny.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby bunny, white and light grey, long ears, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 20. `isl/raw/a-bear.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby brown bear cub, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 21. `isl/raw/a-panda.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby panda, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 22. `isl/raw/a-koala.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby koala, grey, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 23. `isl/raw/a-lion.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby lion cub with a tiny fluffy mane, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 24. `isl/raw/a-piglet.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a pink piglet, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 25. `isl/raw/a-frog.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a small green frog #7ED957, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 26. `isl/raw/a-penguin.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby penguin, grey fluffy chick, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 27. `isl/raw/a-duck.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a yellow duckling #FFC93C, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 28. `isl/raw/a-owl.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby owl, light brown with big round eyes, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 29. `isl/raw/a-turtle.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a small green sea turtle, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 30. `isl/raw/a-hedgehog.png` — 1024×1024 px

Animal de pe insulă. Dă `pufi-idle.png` ca imagine de referință (doar pentru stil).

```text
Use the attached image only as a STYLE reference (same render style, lighting and cuteness level) — do not copy the fox.
A cute a baby hedgehog with soft brown spikes, big glossy eyes with sparkle highlights, rosy cheeks, round chubby proportions, standing facing the viewer, three-quarter view, happy expression.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```


---

## Raport (completează Codex)

- Instrument folosit:
- Transparență: reală / magenta
- Generate OK:
- Probleme:
