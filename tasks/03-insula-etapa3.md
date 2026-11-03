# Task 03 — Imagini noi pentru Insula lui Pufi (decorațiuni, iarnă, clădiri care cresc, Pufi)

Aceleași reguli ca la `tasks/02-insula-imagini.md`. Tu (Codex) **generezi imaginile** și le **salvezi în repo**. Claude le optimizează și le pune în joc. **Nu modifica `index.html` și nu scrie cod de joc.**

## Unde salvezi

- Folderul: **`isl/raw/`** (`~/Documents/IOS Apps/Pufi-game/isl/raw/`), cu numele **exacte** din titluri.
- **PNG**. Toate în afară de `bg-winter.png` cu **fundal transparent real (alfa)**. Dacă nu se poate, folosește fundal magenta plin `#FF00FF` și notează în raport.
- Mărimi: `bg-winter.png` = **1536×1024**, toate celelalte = **1024×1024**.

## Pași

1. `git checkout main && git pull`, apoi creează branch-ul `assets/insula-etapa3`.
2. Generează în ordinea secțiunilor, cu promptul **exact** (blocul `text`), câte o imagine per apel.
3. **Imagini de referință și editări:**
   - `bg-winter` = editare a `bg-day.png`;
   - `b-<clădire>-1` și `b-<clădire>-2` = editări ale `b-<clădire>.png`;
   - toate ipostazele lui Pufi primesc `pufi-idle.png` ca referință.
4. **Verificări pentru fiecare imagine** (maximum 3 încercări, apoi notezi în raport):
   - mărimea exactă (`sips -g pixelWidth -g pixelHeight`);
   - alfa real (`sips -g hasAlpha` → `yes`);
   - fără text, cifre sau logo;
   - obiect întreg, cu margine liberă.
   - **Important la secțiunea C:** baza clădirii din `b-x-1.png` și `b-x-2.png` stă exact la aceeași înălțime și la același x ca în `b-x.png` (diferență maximă 8 px). Măsoară marginea de jos a conturului alfa, cu tot cu umbra, și notează valorile în raport pentru fiecare clădire.
   - `bg-winter`: pajiștea din mijloc rămâne goală.
5. Fă planșa `isl/raw/_contact-sheet-3.png`, cu toate imaginile noi și numele lor.
6. Completează „Raport” la final. Commit, `git pull --rebase origin main`, push. Deschide un PR spre `main` cu titlul „Insula lui Pufi: imagini (etapa 3)”, **fără merge**. Răspunde-i lui Hory în română.

Ordinea de prioritate, dacă nu apuci tot: **A, B, C, D**.

## Lista imaginilor

## A. Decorațiuni cumpărate cu stele (12)

### 1. `isl/raw/d-swing.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A wooden playground swing: an A-frame of warm wood #C68A4E with two ropes and a coral red #FF6B6B seat, a little grass patch at the base.

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 62% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 2. `isl/raw/d-slide.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small playground slide: a short ladder and a curved sunflower-yellow #FFC93C slide with sky blue #8FD8FF side rails, on a little grass patch.

Composition: one single object, centered horizontally, fully visible, the object about 62% of the image width and about 60% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 3. `isl/raw/d-fountain.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small round stone fountain with three tiers, cream white #FFF6E5 stone, sparkling turquoise #2EC4D6 water spouting from the top and splashing into the basin, tiny flowers around the base.

Composition: one single object, centered horizontally, fully visible, the object about 52% of the image width and about 58% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 4. `isl/raw/d-treehouse.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small cute treehouse: a chunky round tree with a fluffy green #7ED957 crown, a little wooden house #C68A4E with a coral red roof built among the branches, a rope ladder hanging down.

Composition: one single object, centered horizontally, fully visible, the object about 58% of the image width and about 84% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 5. `isl/raw/d-carousel.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small merry-go-round carousel with a striped coral red and cream white tent roof, a lilac #B79CFF top flag, three tiny toy horses in pastel colors, a round wooden base.

Composition: one single object, centered horizontally, fully visible, the object about 62% of the image width and about 70% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 6. `isl/raw/d-sandcastle.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A charming sandcastle made of sand #F6D58E with three little towers, a tiny shell decoration and a small coral red flag on the tallest tower, a toy bucket and spade next to it.

Composition: one single object, centered horizontally, fully visible, the object about 58% of the image width and about 52% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 7. `isl/raw/d-flowers.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A round flower bed with a low wooden border, full of chunky colorful flowers: coral red tulips, sunflower-yellow daisies, lilac bells and pink blossoms, green leaves.

Composition: one single object, centered horizontally, fully visible, the object about 60% of the image width and about 40% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 8. `isl/raw/d-pond.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small oval pond with turquoise #2EC4D6 water, three green lily pads with one pink flower, a few round stones around the edge, cattails on one side.

Composition: one single object, centered horizontally, fully visible, the object about 66% of the image width and about 40% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 9. `isl/raw/d-kite.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A diamond-shaped kite in coral red, sunflower yellow and sky blue panels with a long bow-tie tail, flying above a small wooden peg in the grass, the string going from the peg up to the kite.

Composition: one single object, centered horizontally, fully visible, the object about 44% of the image width and about 86% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 10. `isl/raw/d-balloon.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A small hot-air balloon with sunflower-yellow #FFC93C and coral red #FF6B6B vertical stripes, a wicker basket, tethered by two ropes to small pegs in a grass patch, floating just above the ground.

Composition: one single object, centered horizontally, fully visible, the object about 46% of the image width and about 86% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 11. `isl/raw/d-picnic.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A picnic: a coral red and white checkered blanket on the grass with a wicker basket, a few apples, a teapot and two cups.

Composition: one single object, centered horizontally, fully visible, the object about 66% of the image width and about 40% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 12. `isl/raw/d-lamp.png` — 1024×1024 px

Decorațiune pe care copilul o cumpără cu stele și o așază pe insulă.

```text
A short park bench of warm wood #C68A4E next to an old-fashioned street lamp with a dark green post and a warm yellow glowing lantern, on a tiny cobblestone patch.

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 72% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

## B. Iarna (pentru lansarea din decembrie)

### 13. `isl/raw/bg-winter.png` — 1536×1024 px

Insula iarna. Se face EDITÂND `bg-day.png` (dă-i imaginea ca intrare).

```text
Edit the attached island image. Keep the composition EXACTLY the same: same island shape, same meadow, same palm trees, same rock, same camera, same size. Turn it into a cozy, sunny winter day: the meadow is covered with a soft, smooth layer of white snow (with a few patches of green grass peeking through near the edges), the palm fronds and the rock have gentle snow caps, the sand ring is lightly dusted with snow, the sky is a pale winter blue gradient from #A9DDF7 at the top to #EAF7FF at the horizon, the sea stays turquoise #2EC4D6 but slightly calmer and cooler. The middle of the meadow must stay EMPTY and flat (no snowmen, no trees, no objects). Do NOT add falling snowflakes, sun, moon or text (the game adds snowflakes).

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 14. `isl/raw/w-tree.png` — 1024×1024 px

Brad de Crăciun pe insulă (decembrie).

```text
A chubby, cute Christmas fir tree, deep green with soft rounded branches, decorated with coral red and sunflower-yellow round baubles, a few lilac and sky blue baubles, a golden star on top, a garland of small warm lights, three wrapped presents with ribbons under it, a little snow on the branches.

Composition: one single object, centered horizontally, fully visible, the object about 58% of the image width and about 86% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 15. `isl/raw/w-snowman.png` — 1024×1024 px

Om de zăpadă (decembrie).

```text
A friendly round snowman made of three snowballs, two coal-black button eyes, a carrot nose, a big smile, a sunflower-yellow #FFC93C knitted scarf, a small coral red bucket as a hat, two twig arms waving.

Composition: one single object, centered horizontally, fully visible, the object about 48% of the image width and about 74% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 16. `isl/raw/pufi-winter.png` — 1024×1024 px

Pufi îmbrăcat de iarnă. Dă `pufi-idle.png` ca referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors and proportions.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Winter outfit: he also wears a cozy knitted coral red #FF6B6B hat with a white pom-pom, and small cream mittens. Pose: standing facing the viewer, one paw waving, big happy smile, a few snowflakes on his hat.

Composition: one single object, centered horizontally, fully visible, the object about 48% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

## C. Clădirile care cresc (2 etape pentru fiecare clădire = 16)

### 17. `isl/raw/b-time-1.png` — 1024×1024 px

turnul cu ceas, etapa 1 din 3. Se face EDITÂND `b-time.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the bottom third of the clock tower (the base with the door and one floor) is built; the upper part, the clock and the roof are not built yet; light wooden scaffolding with a small ladder stands around the unfinished top edge. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 18. `isl/raw/b-time-2.png` — 1024×1024 px

turnul cu ceas, etapa 2 din 3. Se face EDITÂND `b-time.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the tower is built up to and including the clock (no clock hands, no numbers), but the pointed roof is not built yet; light wooden scaffolding around the top, a small pile of coral roof tiles next to the base. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 19. `isl/raw/b-read-1.png` — 1024×1024 px

biblioteca, etapa 1 din 3. Se face EDITÂND `b-read.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the ground floor walls of the library are built, without the roof and without the round window decoration; wooden scaffolding along the top edge, a small stack of books waiting next to the door. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 20. `isl/raw/b-read-2.png` — 1024×1024 px

biblioteca, etapa 2 din 3. Se face EDITÂND `b-read.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the library is fully built but the blue roof is only half finished (one half done, the other half shows bare wooden roof beams); a small wooden ladder leans on the wall. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 21. `isl/raw/b-math-1.png` — 1024×1024 px

turnul din cuburi, etapa 1 din 3. Se face EDITÂND `b-math.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the bottom 2 toy blocks of the tower are stacked, the rest is missing; a few loose colorful blocks lie on the grass next to it. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 22. `isl/raw/b-math-2.png` — 1024×1024 px

turnul din cuburi, etapa 2 din 3. Se face EDITÂND `b-math.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the bottom 4 blocks are stacked, the top 2 blocks and the flag are missing; one block is being carried up by a tiny wooden crane arm. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 23. `isl/raw/b-world-1.png` — 1024×1024 px

farul, etapa 1 din 3. Se face EDITÂND `b-world.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the bottom third of the lighthouse (with the door) stands on the rock; the upper part, balcony and lantern are missing; light wooden scaffolding around the unfinished top edge. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 24. `isl/raw/b-world-2.png` — 1024×1024 px

farul, etapa 2 din 3. Se face EDITÂND `b-world.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the lighthouse tower is built up to the balcony, but the glass lantern room and the red dome are not built yet; scaffolding around the top. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 25. `isl/raw/b-shapes-1.png` — 1024×1024 px

casa formelor, etapa 1 din 3. Se face EDITÂND `b-shapes.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the orange cube base with its round door is built; the sphere and the cone are missing; a small wooden scaffold stands on top of the cube. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 26. `isl/raw/b-shapes-2.png` — 1024×1024 px

casa formelor, etapa 2 din 3. Se face EDITÂND `b-shapes.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the orange cube and the green sphere are built, but the blue cone roof and the star are missing; a small scaffold stands on top of the sphere. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 27. `isl/raw/b-robo-1.png` — 1024×1024 px

atelierul roboților, etapa 1 din 3. Se face EDITÂND `b-robo.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the lower half of the workshop walls is built (with the garage opening), no roof, no gear, no chimney; wooden scaffolding along the top edge. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 28. `isl/raw/b-robo-2.png` — 1024×1024 px

atelierul roboților, etapa 2 din 3. Se face EDITÂND `b-robo.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the workshop is fully built with its roof, but the big yellow gear is not mounted yet (it lies on the ground next to the door) and the chimney is missing. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 29. `isl/raw/b-chess-1.png` — 1024×1024 px

castelul de șah, etapa 1 din 3. Se face EDITÂND `b-chess.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the central tower up to about one third of its height and the gate are built; the side towers, the top crenellations and the flags are missing; wooden scaffolding around the top. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 30. `isl/raw/b-chess-2.png` — 1024×1024 px

castelul de șah, etapa 2 din 3. Se face EDITÂND `b-chess.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the central tower is complete with its checkerboard band, but the two side towers are only half built and there are no flags yet; scaffolding on the side towers. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 31. `isl/raw/b-pufi-1.png` — 1024×1024 px

căsuța lui Pufi, etapa 1 din 3. Se face EDITÂND `b-pufi.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: only the walls of the cottage ground floor and the round door are built; no roof, no chimney, no flower boxes; wooden scaffolding along the top edge. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 32. `isl/raw/b-pufi-2.png` — 1024×1024 px

căsuța lui Pufi, etapa 2 din 3. Se face EDITÂND `b-pufi.png` (dă-i imaginea ca intrare). Baza trebuie să rămână exact în același loc.

```text
Edit the attached image. Show the SAME building while it is still under construction: the cottage is built with its walls and windows but the terracotta roof is only half covered (bare wooden beams on one side) and the chimney is missing; a small ladder leans on the wall. Everything that is already built must look identical to the attached image (same shapes, colors and position). Friendly and tidy, not messy, no workers, no people.
CRITICAL: keep the exact same image size (1024×1024), the same camera angle, the same scale, and keep the bottom of the base EXACTLY where it is in the attached image (same pixel position), so the two images line up perfectly when swapped. Keep the transparent background (PNG with alpha) and the small soft contact shadow under the base. Same colors, same materials, same lighting.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

## D. Pufi în ipostaze noi + obiecte mici

### 33. `isl/raw/pufi-eat.png` — 1024×1024 px

Pufi într-o ipostază nouă. Dă `pufi-idle.png` ca referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: sitting on the grass, holding a big shiny red apple with both paws and taking a happy bite, eyes happily closed.

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 34. `isl/raw/pufi-read.png` — 1024×1024 px

Pufi într-o ipostază nouă. Dă `pufi-idle.png` ca referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: sitting on the grass reading an open picture book held in both paws, curious happy expression, the book cover is plain coral red with no text.

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 35. `isl/raw/pufi-look.png` — 1024×1024 px

Pufi într-o ipostază nouă. Dă `pufi-idle.png` ca referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: standing and looking through a small toy binoculars held with both paws, tail curled, excited expression.

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 36. `isl/raw/pufi-dance.png` — 1024×1024 px

Pufi într-o ipostază nouă. Dă `pufi-idle.png` ca referință.

```text
Use the attached image as the reference for the character — exactly the same character, colors, proportions and scarf.
Character "Pufi": a cute small fox cub, mascot of a kids' learning app. Orange fur #FF8A3D, cream white muzzle, chest, paws and tail tip #FFF1DC, big round head (about 45% of the body height), large glossy dark brown eyes with white sparkle highlights, small black nose, soft rosy cheeks, short legs, a very fluffy tail, wearing a small sunflower-yellow #FFC93C knitted scarf. Friendly, curious and gentle expression.
Pose: dancing happily on his hind legs, one paw up, one leg lifted, tail swinging, big open smile, two tiny music notes floating next to him (simple shapes, no text).

Composition: one single object, centered horizontally, fully visible, the object about 56% of the image width and about 80% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 37. `isl/raw/i-apple.png` — 1024×1024 px

Mărul cu care copilul hrănește animalele.

```text
A single shiny cartoon red apple with a short brown stem and one green leaf, glossy highlight.

Composition: one single object, centered horizontally, fully visible, the object about 40% of the image width and about 44% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 38. `isl/raw/i-gift.png` — 1024×1024 px

Cadoul de la sarcina zilei.

```text
A cute square gift box in lilac #B79CFF with a big sunflower-yellow #FFC93C ribbon and bow on top, a few tiny golden sparkles around it.

Composition: one single object, centered horizontally, fully visible, the object about 48% of the image width and about 56% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

### 39. `isl/raw/i-star.png` — 1024×1024 px

Steaua (monedă pentru decorațiuni).

```text
A chunky, glossy, rounded five-pointed golden star coin, sunflower yellow #FFC93C with a lighter highlight and soft orange #FF9F43 edges, cute but with no face.

Composition: one single object, centered horizontally, fully visible, the object about 52% of the image width and about 52% of the image height, with at least 6% empty margin on the left, right and top; the bottom of its base sits 8% above the bottom edge of the image; include only a small soft oval contact shadow directly under the base. Background: fully transparent (PNG with alpha channel). If transparency is impossible, use a perfectly flat pure magenta #FF00FF background with no gradient, no texture and no shadow on it.

Art style: premium children's mobile game art, soft 3D clay / vinyl-toy render, rounded bevelled edges, chunky friendly proportions, matte materials with a very subtle soft texture, warm soft sunlight from the upper left, gentle ambient occlusion, no hard black outlines, cheerful and calm (bright but not neon, not overstimulating). Palette — use only these hues and their lighter/darker shades: sea turquoise #2EC4D6, deep sea #1A8FC9, sand #F6D58E, grass green #7ED957 (shade #4CAF50), coral red #FF6B6B, sunflower yellow #FFC93C, sky blue #8FD8FF, lilac #B79CFF, warm wood #C68A4E, cream white #FFF6E5. Camera: three-quarter front view looking down about 30 degrees, near-orthographic, almost no perspective distortion. Absolutely no text, letters, numbers, logos, signatures or watermarks. No people.
```

---

## Raport (completează Codex)

- Data: 2 noiembrie 2026. Branch: `assets/insula-etapa3`; bază verificată: `main` la `c3ebf9a`.
- Instrument folosit: **OpenAI `imagegen` integrat**, câte o imagine per apel, în ordinea A, B, C, D. Blocurile de prompt au fost trimise integral; s-au adăugat numai instrucțiuni de dimensiune și clarificări ale marginilor/alfa ori coordonatelor bazei deja cerute. Nu s-au desenat asseturi cu cod/SVG și nu s-a folosit CLI/API.
- Generate: **toate cele 39 de imagini**, cu numele exacte din listă: A = 12 decorațiuni, B = 4 imagini de iarnă, C = 16 variante de clădiri, D = 4 ipostaze Pufi și 3 obiecte mici. Niciun asset anterior nu a fost înlocuit.
- Transparență: **reală** pentru toate cele **38 de sprite-uri**; `bg-winter.png` este opac. Verificare cu `sips` și citirea alfa (interval 0–255, incluzând pixeli complet transparenți și complet opaci). Niciun fundal magenta și niciun caroiaj pictat.
- Dimensiuni: `bg-winter.png` = **1536×1024**; toate celelalte = **1024×1024**. Instrumentul a livrat sprite-uri pătrate la altă rezoluție; normalizare cu `sips`, păstrând alfa. Nu s-au modificat pozițiile sprite-urilor prin script după generare.
- Referințe: fundalul de iarnă este o editare a `bg-day.png`; fiecare variantă C este o editare a clădirii sale originale, nu a celeilalte etape; toate cele cinci ipostaze Pufi noi folosesc `pufi-idle.png`. Imaginile de intrare au fost inspectate înainte de editare.
- Control vizual: obiecte întregi, fără text, cifre, logo sau watermark. Cele două note muzicale din `pufi-dance` sunt formele cerute în prompt. Centrul insulei de iarnă rămâne gol; nu s-au adăugat fulgi care cad, soare, lună sau obiecte centrale. Turnul cu ceas nu are limbi sau cifre.
- Planșă: **`isl/raw/_contact-sheet-3.png`**, **1600×2240**, grilă cu 5 coloane și toate cele 39 de imagini etichetate; verificată vizual pe fundal deschis. Etichetele apar numai pe planșă.

### Regenerări și probleme

- Au fost folosite maximum trei încercări per asset: `d-carousel` și `d-balloon` câte **3**; `d-treehouse`, `d-kite`, `d-picnic`, `pufi-winter`, `b-time-2` câte **2**; restul câte **1**. Variantele respinse rămân în afara repo-ului.
- Regenerările au corectat margini prea mici, halouri mari și extinderea laterală a bazei prin țiglele de lângă turn. La `d-carousel` a fost selectată varianta a doua, cu contur mai curat decât celelalte.
- **Abatere rămasă: `d-carousel.png`** are marginea superioară a conturului alfa >16 la y=50/1024 (aproximativ **4,9%**, față de minimum 6%); umbra ajunge la y=969. Este întreg și transparent, dar necesită puțin spațiu suplimentar la optimizare. Limita de trei încercări a fost respectată.
- Celelalte 37 de sprite-uri trec pragul de minimum 6% sus/stânga/dreapta pentru conturul măsurat. Procentele orientative de lățime/înălțime și distanța bazei față de marginea de jos rămân aproximative; se pot uniformiza la optimizare. Baza originalelor C a fost prioritară față de o nouă aliniere generică la 92%.
- Pot rămâne franjuri fine de antialiasing și pixeli aproape transparenți în afara conturului vizibil, inclusiv în imaginile originale. Variantele cu halouri mari au fost respinse. Editările sunt coerente vizual, dar nu sunt identice pixel cu pixel în regiunile reconstruite.

### Secțiunea C — alinierea bazei

**Toate cele 16 variante trec toleranța de 8 px** în măsurarea de mai jos: maxim **6 px pe x** și **5 px pe y**.

Metodă identică pentru original și variante: pe canvasul final 1024×1024 se folosește alfa **>16/255**, incluzând partea vizibilă a umbrei. `y-jos` este ultimul rând al acestui contur (indexare de la 0). `x` este centrul extinderii orizontale a alfa în ultimii 48 de pixeli de la bază, ca să măsoare baza, nu schela din vârf. Pragul exclude zgomotul aproape transparent din originale; alfa nenulă fără prag poate ajunge până la marginea canvasului și nu descrie precis baza vizibilă. Trecerea acestui control nu înseamnă identitate a întregii siluete.

| Clădire | Original (x, y-jos) | Etapa 1 | Etapa 2 | Max. Δx / Δy față de original | Rezultat |
|---|---|---|---|---|---|
| `b-time` | (508, 964) | (508.5, 967) | (510, 969) | 2 / 5 | PASS |
| `b-read` | (502, 966) | (501.5, 969) | (502, 968) | 0.5 / 3 | PASS |
| `b-math` | (509, 979) | (510, 983) | (509, 984) | 1 / 5 | PASS |
| `b-world` | (510.5, 915) | (510, 917) | (510, 917) | 0.5 / 2 | PASS |
| `b-shapes` | (496.5, 940) | (498, 944) | (498.5, 945) | 2 / 5 | PASS |
| `b-robo` | (528.5, 947) | (531, 952) | (530.5, 949) | 2.5 / 5 | PASS |
| `b-chess` | (510, 931) | (509, 932) | (508, 933) | 2 / 2 | PASS |
| `b-pufi` | (498, 947) | (504, 949) | (503, 949) | 6 / 2 | PASS |

### Compilare și pornire

- iPad (A16), iOS 26.5: **BUILD PASS**; aplicația instalată și pornită. Control vizual al paginii: **PASS**.
- iPhone 17 Pro, iOS 26.5: **BUILD PASS**; aplicația instalată și pornită. Control vizual al paginii: **PASS**.
- Loguri locale: `/tmp/pufi-stage3-ipad-build.log`, `/tmp/pufi-stage3-iphone-build.log`; capturi: `/tmp/pufi-stage3-ipad.png`, `/tmp/pufi-stage3-iphone.png`.
- Verificarea aplicației se referă la versiunea existentă de la baza indicată, nu la integrarea asseturilor noi. Acestea rămân în `isl/raw/` pentru Claude. Nu s-au modificat `index.html`, codul iOS sau scriptul de sincronizare.
- Pentru Claude: optimizează și integrează noile asseturi; păstrează canvasul și coordonatele bazei pentru stadiile C, ajustează marginea caruselului și verifică imaginile pe fundalul real al insulei. Copierea asseturilor optimizate în pachetul offline iOS trebuie verificată odată cu integrarea.
