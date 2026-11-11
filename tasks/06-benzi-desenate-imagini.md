# Task 06 — Imaginile pentru Benzile desenate cu Pufi

Hory vrea să-i atragă pe copiii din clasa I la citit cu benzi desenate. Copilul citește singur cuvântul-cheie din fiecare balon și se înregistrează. La final, banda desenată se derulează ca un film, cu vocea lui.

Tu (Codex) **generezi imaginile** de mai jos și le **salvezi în repo**. Claude le optimizează apoi, adaugă baloanele, textul în 12 limbi și partea interactivă. **Nu modifica `index.html`, nimic din `src/` și nu scrie cod de joc.**

## Unde salvezi

- Folderul: **`benzi/raw/`**, în rădăcina repo-ului (`~/Documents/IOS Apps/Pufi-game/benzi/raw/`).
- Subfoldere, **exact** ca în titlurile de mai jos:
  - `benzi/raw/chars/` pentru personajele noi (fișele de personaj);
  - `benzi/raw/ep01/` … `benzi/raw/ep04/` pentru episoade: `cover.png`, `p1.png` … `p6.png`.
- Numele se scriu cu litere mici, exact ca în titluri, de exemplu `benzi/raw/ep01/p3.png`.
- Format: **PNG**.
  - Fișele de personaj (`chars/`) au **fundal transparent (canal alfa)**.
  - Casetele (`p1`–`p6`) și copertele au fundal plin, fără transparență.
- Excepție de la `AGENTS.md`: pentru acest task ai voie să adaugi fișiere **doar** în `benzi/raw/` și să completezi secțiunea „Raport” din `tasks/06-benzi-desenate-imagini.md`.

## Pași

1. `git checkout main && git pull`, apoi creează branch-ul `assets/benzi-imagini`.
2. Generează **întâi fișele de personaj**, apoi episoadele, **în ordinea din listă**, la **mărimea exactă** din titlu (toate sunt `1024×1024`). Folosește promptul **exact cum e scris** (blocul `text`) și adaugă la final blocul „Stil comun”.
3. **Consecvența personajelor** (cel mai important lucru):
   - Pufi trebuie să fie **mereu același**: vulpița portocalie cu eșarfa galbenă. Dă-i la **fiecare** imagine în care apare Pufi ca imagine de referință `isl/raw/pufi-idle.png`.
   - Fiecare personaj nou primește ca referință fișa lui din `benzi/raw/chars/`, de fiecare dată când apare. Puiul de dinozaur folosește `chars/dino-baby.png`, extraterestrul `chars/alien.png` și așa mai departe.
   - Într-un episod, caseta următoare primește ca referință și caseta anterioară. Așa se păstrează locul, culorile și lumina.
4. **Regula pentru baloane:** jocul pune singur baloanele de vorbire. De aceea fiecare casetă are **în treimea de sus un spațiu liniștit și liber** (cer, perete simplu) și **niciun personaj sau obiect important acolo**. Personajele stau în jumătatea de jos și la mijloc.
5. **Verifică fiecare imagine** înainte s-o păstrezi. Dacă una nu trece, regenereaz-o (maximum 3 încercări), apoi notează în raport.
   - Mărimea e exact 1024×1024: `sips -g pixelWidth -g pixelHeight fișier.png`.
   - Fișele de personaj au transparență reală: `sips -g hasAlpha fișier.png` → `yes`, fără pătrățele pictate.
   - **Niciun text, nicio literă, nicio cifră, niciun balon de vorbire, niciun „BOOM/CRAC” scris, niciun logo sau watermark.** Efectele de sunet le scrie jocul.
   - Fără chenar sau ramă de bandă desenată: jocul desenează rama.
   - Pufi seamănă cu `pufi-idle.png`: aceeași față, aceleași culori, eșarfa galbenă.
   - Treimea de sus e liberă pentru balon.
   - Dacă instrumentul tău nu poate face fundal transparent pentru fișe, folosește fundal **magenta plin `#FF00FF`** și notează în raport. Claude îl scoate.
6. Fă câte o planșă de control pentru fiecare episod: `benzi/raw/ep01/_sheet.png` etc. Pune cele 6 casete în ordine, 3 pe rând, cu numele dedesubt (numele pe planșă sunt permise, doar pe planșă).
7. Completează „Raport” la finalul acestui fișier: ce s-a generat, ce a eșuat, ce instrument ai folosit, dacă transparența e reală sau magenta.
8. Commit, `git pull --rebase origin main`, push, apoi deschide un **pull request** spre `main` cu titlul „Benzi desenate: imagini (etapa 1)”. **Nu face merge.** Răspunde-i lui Hory în română, pe scurt.

**Etapa 1** (obligatorie): fișele de personaj 1–2 și episoadele 1 și 2. **Etapa 2** (dacă ai timp, în același PR): fișele 3–4 și episoadele 3 și 4.

Dacă nu ai deloc acces la generare de imagini, oprește-te și spune-i lui Hory. Nu desena imaginile cu cod, SVG sau alte scripturi.

## Stil comun (adaugă-l la sfârșitul fiecărui prompt)

```text
Art style: premium children's picture-book / animated-film look, soft 3D clay and vinyl-toy render exactly like the attached Pufi reference: rounded chunky friendly shapes, matte materials with a very subtle soft fur/felt texture, warm soft light from the upper left, gentle ambient occlusion, no hard black outlines, cheerful, bright but not neon. Expressive faces and clear body language that a 6-year-old understands without words. Palette: Pufi's fur #FF8A3D, cream #FFF6E5, sunflower yellow #FFC93C (Pufi's scarf), sky blue #8FD8FF, sea turquoise #2EC4D6, grass green #7ED957, coral red #FF6B6B, lilac #B79CFF, warm wood #C68A4E. Square 1:1 composition. The TOP THIRD of the image must be a calm, simple, uncluttered area (sky, plain wall or soft background) with no characters, faces or important objects, because a speech bubble will be placed there; keep the characters in the middle and lower part. Absolutely no text, letters, numbers, speech bubbles, written sound effects, logos, signatures, watermarks or comic panel borders.
```

## Pufi (referință pentru toate imaginile)

Pufi este o vulpiță portocalie, prietenoasă, cu obraji crem, ochi mari și căprui și **eșarfă galbenă tricotată**. Referința este `isl/raw/pufi-idle.png` și trebuie dată la fiecare imagine în care apare Pufi.

---

## Fișele de personaj (`benzi/raw/chars/`, fundal transparent, 1024×1024)

### 1. `benzi/raw/chars/dino-baby.png`

```text
Character reference sheet image, single character, full body, standing, three-quarter front view, centered with generous empty margin, on a fully transparent background. A tiny friendly baby dinosaur (long-neck sauropod type) about the same height as a small fox cub: mint green #7ED957 body with soft turquoise #2EC4D6 round spots on its back, cream belly, big round shiny dark eyes, tiny rounded teeth-free smile, short chubby legs, a small round tail, two tiny bumps on the head. Curious, playful, a bit clumsy. One small piece of cracked cream eggshell still sitting on its head like a hat.
```

### 2. `benzi/raw/chars/alien.png`

```text
Character reference sheet image, single character, full body, standing, three-quarter front view, centered with generous empty margin, on a fully transparent background. A small cute friendly alien, the size of a fox cub: soft lilac #B79CFF round body, one big sparkling eye with long lashes, a single bendy antenna with a glowing sunflower-yellow #FFC93C ball on top, tiny stubby arms waving hello, three little round feet, a happy open smile. Not scary at all — huggable like a plush toy.
```

### 3. `benzi/raw/chars/robot.png` (etapa 2)

```text
Character reference sheet image, single character, full body, standing, three-quarter front view, centered with generous empty margin, on a fully transparent background. A small round friendly household robot named Bip, a bit shorter than a fox cub: glossy cream-white #FFF6E5 egg-shaped body with sky-blue #8FD8FF panels, a rounded screen face showing two big friendly dot eyes and a smile, a short antenna with a coral #FF6B6B light, two little round vent holes where a nose would be, short bendy arms with mitten hands, rolling on a single small wheel. Cheerful and slightly clumsy.
```

### 4. `benzi/raw/chars/parrot.png` (etapa 2)

```text
Character reference sheet image, single character, full body, perched pose standing on its feet, three-quarter front view, centered with generous empty margin, on a fully transparent background. A cheeky small parrot: bright coral-red #FF6B6B body, sunflower-yellow #FFC93C and turquoise #2EC4D6 wing tips, big round eyes with a mischievous look, a curved cream beak, a tiny tuft on the head. Funny and lovable, a little troublemaker.
```

---

## Episodul 1 — „Oul misterios” (`benzi/raw/ep01/`)

Povestea: pe plaja insulei, Pufi găsește un ou uriaș. Oul se mișcă, crapă și iese un pui de dinozaur. Puiul îi mănâncă mărul lui Pufi, apoi plânge după mama lui. Împreună urmăresc niște urme mari și o găsesc pe mama-dinozaur.

### `benzi/raw/ep01/cover.png`

```text
Comic book cover illustration (but without any title text). Pufi the fox (reference attached) and the baby dinosaur (reference attached) peeking out together from behind a giant cracked cream egg with turquoise spots, on a sunny tropical beach with turquoise sea. Both look straight at the viewer with big excited smiles. Warm, inviting, adventurous mood.
```

### `benzi/raw/ep01/p1.png`

```text
Comic panel 1. A sunny tropical beach with soft sand and calm turquoise sea. Pufi the fox (reference attached) walks along the beach and suddenly stops, very surprised, pointing with one paw at a big cream egg with turquoise spots half-buried in the sand. The egg is as tall as Pufi's knees. Clear surprised expression: wide eyes, open mouth.
```

### `benzi/raw/ep01/p2.png`

```text
Comic panel 2. Same beach. The giant spotted egg is now fully visible and as tall as Pufi. Pufi the fox hugs it from one side and listens with one ear pressed against the shell, eyes wide. The egg is wobbling and tilting (show this with the egg leaning and little sand puffs at its base, not with drawn motion lines). Funny, curious, suspenseful.
```

### `benzi/raw/ep01/p3.png`

```text
Comic panel 3. Same beach. The egg cracks open with shell pieces flying gently in the air, and the baby dinosaur (reference attached) pops its head and front paws out of the top with a huge happy smile. Pufi the fox has fallen backwards on the sand in surprise, paws up, laughing. Joyful, comedic moment.
```

### `benzi/raw/ep01/p4.png`

```text
Comic panel 4. Same beach, picnic blanket on the sand. The baby dinosaur (reference attached) happily munches Pufi's big red apple, cheeks full, a little apple juice drop flying. Pufi the fox (reference attached) sits next to it holding an empty paw out, looking at the apple with a funny "hey, that was mine!" expression, but smiling.
```

### `benzi/raw/ep01/p5.png`

```text
Comic panel 5. Edge of a friendly green jungle next to the beach. The baby dinosaur (reference attached) looks sad with one big tear, looking at a row of very large dinosaur footprints in the sand leading into the jungle. Pufi the fox (reference attached) kneels beside it, one paw on its back, comforting it, and points with the other paw along the footprints. Hopeful, caring mood.
```

### `benzi/raw/ep01/p6.png`

```text
Comic panel 6. A sunny jungle clearing in warm golden afternoon light. A big gentle mother dinosaur, same mint-green color with turquoise spots as the baby (reference attached), lowers her long neck and hugs the baby dinosaur happily. Pufi the fox (reference attached) stands nearby waving goodbye with a big happy smile, a few flowers and butterflies around. Warm, happy ending.
```

---

## Episodul 2 — „Racheta din cutie” (`benzi/raw/ep02/`)

Povestea: Pufi își face o rachetă dintr-o cutie de carton. Numără 3, 2, 1 și zboară printre stele până pe Lună. Acolo întâlnește un extraterestru mic și prietenos, se joacă amândoi, apoi Pufi se trezește acasă, în cutie. Pe pervaz îl salută o antenă mică și luminoasă.

### `benzi/raw/ep02/cover.png`

```text
Comic book cover illustration (but without any title text). Pufi the fox (reference attached) wearing a kitchen colander as a space helmet, flying in a homemade cardboard-box rocket through a starry purple-blue space, waving happily; the little lilac alien (reference attached) waves back from a small crescent moon. Magical, exciting, dreamy mood.
```

### `benzi/raw/ep02/p1.png`

```text
Comic panel 1. Pufi's cozy bedroom during the day, plain light-blue wall in the upper part. Pufi the fox (reference attached) builds a rocket from a big cardboard box: a paper cone on top, round window drawn with crayons, tape, scissors and crayons on the floor. Pufi holds up a crayon proudly, tongue out in concentration.
```

### `benzi/raw/ep02/p2.png`

```text
Comic panel 2. Evening in the garden, deep blue sky with the first stars in the upper part. Pufi the fox (reference attached) sits inside the cardboard-box rocket wearing a kitchen colander as a helmet, gripping the edges, eyes shining with excitement. The box rocket is just lifting off the grass with a soft cartoon cloud of smoke and a small friendly orange flame underneath. Magical, imaginative.
```

### `benzi/raw/ep02/p3.png`

```text
Comic panel 3. Outer space full of soft stars, a ringed lilac planet and a turquoise planet in the background. The cardboard-box rocket with Pufi the fox (reference attached) in a colander helmet flies through space with a sparkly trail; Pufi waves joyfully out of the side. Dreamy, wonder-filled.
```

### `benzi/raw/ep02/p4.png`

```text
Comic panel 4. On the soft grey surface of the moon with round craters, black starry sky in the upper part and the Earth small in the distance. The box rocket has landed. Pufi the fox (reference attached) steps out carefully and meets the little lilac alien (reference attached) who is peeking shyly out of a crater, antenna glowing. Both look surprised and curious, no fear.
```

### `benzi/raw/ep02/p5.png`

```text
Comic panel 5. On the moon surface, starry sky in the upper part. Pufi the fox (reference attached) and the little lilac alien (reference attached) bounce high in low gravity, laughing, tossing a small glowing yellow star to each other like a ball, little moon-dust puffs where they landed. Pure fun and friendship.
```

### `benzi/raw/ep02/p6.png`

```text
Comic panel 6. Pufi's bedroom at night, moonlight through the window, plain dark-blue wall in the upper part. Pufi the fox (reference attached) is fast asleep curled up inside the cardboard-box rocket with the colander helmet next to him, smiling in his sleep. On the windowsill outside, a tiny glowing yellow antenna ball of the lilac alien (reference attached) peeks in, as if waving goodnight. Cozy, magical, a little mysterious.
```

---

## Episodul 3 — „Robotul care strănută” (`benzi/raw/ep03/`, etapa 2)

Povestea: robotul Bip îl ajută pe Pufi la o prăjitură. Începe să strănute: zboară făina, apoi șosetele. Pufi se uită în „nasul” robotului, găsește o pană prinsă acolo și o scoate. Bip e bine și fac împreună prăjitura.

### `benzi/raw/ep03/cover.png`

```text
Comic book cover illustration (but without any title text). In a bright cozy kitchen, Bip the robot (reference attached) is mid-sneeze in a big puff of white flour, and Pufi the fox (reference attached) covered in flour laughs next to him holding a whisk. Funny, warm mood.
```

### `benzi/raw/ep03/p1.png`

```text
Comic panel 1. A bright cozy kitchen with plain cream wall in the upper part. Pufi the fox (reference attached) wearing a little chef apron and Bip the robot (reference attached) prepare a cake together: a bowl, eggs, a bag of flour, a whisk on the table. Both smile happily.
```

### `benzi/raw/ep03/p2.png`

```text
Comic panel 2. Same kitchen. Bip the robot (reference attached) sneezes a giant puff of flour from its two little vent holes; a white flour cloud fills the middle of the kitchen. Pufi the fox (reference attached) is completely white with flour, only his surprised eyes and yellow scarf visible. Very funny.
```

### `benzi/raw/ep03/p3.png`

```text
Comic panel 3. Same kitchen, now a bit messy. Bip the robot (reference attached) sneezes again and a pile of colorful socks shoots out of a laundry basket and flies around the room. Pufi the fox (reference attached) ducks under the table, holding a pot lid like a shield, laughing.
```

### `benzi/raw/ep03/p4.png`

```text
Comic panel 4. Same kitchen. Pufi the fox (reference attached) wearing a tiny headlamp looks closely into one of Bip the robot's (reference attached) little round nose vents with a magnifying glass; inside the vent a small fluffy feather is clearly visible. Bip sits still, eyes watering, patient. Curious detective mood.
```

### `benzi/raw/ep03/p5.png`

```text
Comic panel 5. Same kitchen. Pufi the fox (reference attached) carefully pulls the small fluffy feather out of Bip the robot's (reference attached) nose vent with tweezers; Bip's screen face shows big relieved happy eyes. A few sparkles of relief around them.
```

### `benzi/raw/ep03/p6.png`

```text
Comic panel 6. Same kitchen, cleaned up, warm evening light. Pufi the fox (reference attached) and Bip the robot (reference attached) proudly hold a beautiful round cake with cream and strawberries together; the small feather now decorates the top of the cake. Proud, happy ending.
```

---

## Episodul 4 — „Comoara papagalului” (`benzi/raw/ep04/`, etapa 2)

Povestea: valurile aduc o sticlă cu o hartă. Un papagal obraznic fură harta și Pufi aleargă după el printre palmieri. Papagalul o scapă exact deasupra locului cu comoara. Pufi sapă și găsește un cufăr plin cu cărți și fursecuri, pe care le împarte cu papagalul.

### `benzi/raw/ep04/cover.png`

```text
Comic book cover illustration (but without any title text). Pufi the fox (reference attached) wearing a small pirate hat and holding a toy spyglass stands on a tropical beach next to an open wooden treasure chest glowing with warm light; the cheeky parrot (reference attached) sits on top of the chest. Adventurous, sunny mood.
```

### `benzi/raw/ep04/p1.png`

```text
Comic panel 1. A sunny beach, calm sky in the upper part. A small glass bottle with a rolled-up old paper map inside has washed up on the sand. Pufi the fox (reference attached) kneels and picks it up with both paws, eyes sparkling with excitement.
```

### `benzi/raw/ep04/p2.png`

```text
Comic panel 2. Same beach. Pufi the fox (reference attached), now wearing a small pirate hat, unrolls the old paper map (show it only as an old map with a dotted path, palm trees drawn on it and a red cross made of two crossed lines — no letters). Suddenly the cheeky parrot (reference attached) swoops in from the side and grabs the map in its beak. Pufi is shocked.
```

### `benzi/raw/ep04/p3.png`

```text
Comic panel 3. Among tall palm trees on the island. The parrot (reference attached) flies away holding the map in its beak, looking back cheekily. Pufi the fox (reference attached) in his pirate hat runs after it, jumping over a coconut, determined and laughing. Energetic chase.
```

### `benzi/raw/ep04/p4.png`

```text
Comic panel 4. A small sandy clearing between palm trees. The parrot (reference attached) drops the map, which lands exactly on a spot in the sand marked with two crossed red sticks. Pufi the fox (reference attached) stops, looks at the crossed sticks and points at them with a big "aha!" face.
```

### `benzi/raw/ep04/p5.png`

```text
Comic panel 5. Same clearing. Pufi the fox (reference attached) digs energetically with a small toy shovel, sand flying; the corner of a wooden chest is starting to appear in the hole. The parrot (reference attached) watches from a palm branch, curious. Suspense.
```

### `benzi/raw/ep04/p6.png`

```text
Comic panel 6. Same clearing, warm glow. The wooden treasure chest is open: it is full of colorful picture books and round cookies (the books have no readable text on the covers). Pufi the fox (reference attached) happily shares a cookie with the parrot (reference attached), who now looks friendly. Happy, cozy ending.
```

---

## Raport

Etapa 1 finalizată la 11 noiembrie 2026, pe branch-ul `assets/benzi-imagini`.

- Generate 16 imagini originale în `benzi/raw/`, toate PNG 1024×1024. Fișele `chars/dino-baby.png` și `chars/alien.png`, plus `cover.png` și `p1.png`–`p6.png` pentru fiecare dintre `ep01/` și `ep02/`.
- Adăugate planșele `ep01/_sheet.png` și `ep02/_sheet.png`, 1024×720, cu cele șase cadre în ordine, trei pe rând, numele doar sub miniaturi.
- Instrument folosit — image_gen integrat. Prompturile sunt blocurile originale din task urmate de Stil comun. Au fost adăugate precizări despre rolul referințelor, spațiul liber de sus și continuitatea decorului/rachetei.
- `isl/raw/pufi-idle.png` a fost referință în toate imaginile cu Pufi. Fișele de personaj au fost referințe când apar personajele respective. Fiecare cadru p2–p6 folosește și cadrul precedent. Pentru finalul episodului 2 s-a folosit suplimentar dormitorul din p1.
- Fișele au canal alfa real, verificat cu sips și Pillow, cu valori alfa între 0 și 255. Nu s-a folosit magenta. Copertele și cadrele sunt RGB opace.
- Exporturile pătrate ale instrumentului au fost redimensionate proporțional cu sips la exact 1024×1024, fără decupare. Planșele sunt asamblate din imaginile generate.
- Control vizual individual și pe planșe — fără text, litere, cifre, baloane, logo, watermark sau rame. Fundalul superior este simplu, destinat baloanelor, iar acțiunea rămâne în zona de mijloc/jos. Stilul, eșarfa lui Pufi și identitatea personajelor au fost urmărite la fiecare cadru.
- Două încercări respinse și regenerate. Prima fișă a extraterestrului preluase eșarfa lui Pufi. Prima variantă ep02/p1 avea urechea prea sus. Variantele respinse nu sunt incluse în repo. Celelalte imagini au fost păstrate de la prima încercare.
- Etapa 2 (robot, papagal, episoadele 3–4) nu a fost începută în această livrare.
- Verificările au fost pentru fișierele grafice. Integrarea și optimizarea în joc urmează la Claude.
