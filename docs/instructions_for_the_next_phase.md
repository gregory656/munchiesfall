# Next Phase: Make the First Soko Run Playable

The welcome screen and menu now launch on the phone. The next milestone is a small, complete arcade run that feels good to play. Build one character and one market lane first; add a larger cast after the run itself is fun.

## The order to build things

1. **Playable prototype with a temporary character.** Make sure moving, catching, scoring, losing a life, and restarting work before waiting on finished art.
2. **Amani, the Soko Rookie (the first real playable character).** Generate a consistent design and the few poses needed for the prototype.
3. **Food and hazards.** Start with mandazi, samosa, chapati, and one hazard. Keep their art simple while tuning the game.
4. **A complete run.** Add a countdown or survival timer, score/combo feedback, three lives, a results screen, and restart.
5. **Animation polish for Amani.** Add catch, hit, and celebration reactions after the gameplay can trigger them.
6. **Mandazi Mike, the first unlockable.** Add a small, testable passive ability after the base character works.
7. **Samosa Queen, the second unlockable.** Add her rare-food bonus after Mandazi Mike works.
8. **More characters, foods, districts, and powers.** Expand only after a short run is already enjoyable and can be completed repeatedly.

Do not generate ten characters before the first run works. The current milestone is a vertical slice, not the full launch roster described in the long-range game goal.

## Phase 1 — Build the playable loop before final art

Create a separate gameplay scene so it does not replace the menu:

```text
scenes/gameplay/market_run.tscn
scripts/gameplay/market_run.gd
scripts/gameplay/player/player_controller.gd
scripts/gameplay/food/falling_item.gd
scripts/gameplay/food/item_spawner.gd
scripts/gameplay/ui/run_hud.gd
```

Implement in this order:

1. Add a simple market background, a temporary player placeholder, a catch zone/basket, and safe screen margins for a portrait phone.
2. Move the player left and right. Support touch dragging across the play area and keyboard left/right for editor testing. Clamp the player inside the market lane.
3. Spawn three collectible items at random horizontal positions near the top. Let them fall at readable speeds.
4. Detect an item entering the basket/catch zone. Remove it, add points, update the HUD, and briefly show a satisfying pickup response.
5. Add one hazard. Hitting it removes one of three hearts; a collectible never removes a heart.
6. End the run when the timer expires or all hearts are lost. Show score, best score, and a working Retry and Menu button.
7. Save the latest score and best score through the existing `SaveData` local save manager.

**Playable checkpoint:** a person can launch from the existing menu, move with one finger, catch food, dodge one hazard, understand the score/lives, lose, and immediately retry. Use shapes or the existing art as temporary visuals until this checkpoint is met.

## Phase 2 — Make Amani the first real character

Use one consistent character design for the whole first pass. Amani is the fictional market rookie already represented by the starter profile: a lively Nairobi teen/young adult, expressive face, distinctive short textured hair, red-orange jacket, teal cross-body strap, dark shorts/trousers, and bright sneakers. Keep the silhouette readable against a busy market background. Avoid tiny accessories that disappear on a phone.

The existing `assets/munchies_first_character.jpg` can guide the rough silhouette and colors, but it has a plain background and is not a finished in-game sprite. Ask the image generator for transparent outputs and consistent camera, body proportions, clothing, lighting, and scale in every pose.

### First art request

Generate Amani as a **2D game sprite**, full body, facing the camera with a slight three-quarter turn, relaxed ready-to-run pose, feet visible, centered, clean silhouette, transparent background, no text, no props covering the body, soft warm stylized 3D-cartoon rendering, bold readable colors. Treat the supplied starter-character image only as a loose reference for the red jacket and teal strap; create an original, polished Kenyan market-game character.

Before generating animation frames, approve one front/three-quarter standing pose. Reuse that design reference for every next pose. Ask for a sprite sheet only if the image tool can keep the same face, outfit, camera, and frame size across frames; otherwise generate separate transparent poses and assemble them in Godot.

### Minimum character animation set

Start with these five animation names and meanings:

| Animation | Use | First pass |
| --- | --- | --- |
| `idle` | Waiting in the lane | 2–4 subtle looping poses or one pose with a gentle code-driven bounce |
| `run` | Moving left or right | 4–6 looping frames; flip horizontally when moving left |
| `catch` | Food reaches the basket | 2–3 quick frames or a short arm/body reach |
| `hurt` | Hit by a hazard | 2–3 frames, brief flash/knockback, then return to play |
| `celebrate` | Run ends or personal best | 3–5 frames, play once |

For an initial prototype, get `idle` and `run` working first. Trigger `catch`, `hurt`, and `celebrate` after the corresponding gameplay events exist. Keep collision shape and catch-zone placement stable while the art changes so a new sprite does not break the controls.

### Asset handoff rules

- Put approved character files under `assets/characters/amani/` and keep original generated files in a `source/` subfolder.
- Use transparent PNG files, consistent frame dimensions, consistent feet/baseline, and predictable names such as `amani_idle_01.png`, `amani_run_01.png`, and `amani_catch_01.png`.
- For a sprite sheet, request a single horizontal row per animation, evenly sized cells, no labels or gaps, and transparent pixels around the character. Check the sheet before connecting it to a scene; image generators can vary proportions between frames.
- Keep source art and runtime exports separate. Do not overwrite existing art while iterating.
- Target readable art at the phone's actual display size. Test silhouettes over both light and dark parts of the market scene.

## Phase 3 — Connect character art and reactions in Godot

Use a `CharacterBody2D` for Amani's movement, with a child `AnimatedSprite2D` for pose frames and a separate collision shape for gameplay. Godot's `AnimatedSprite2D` reads its named animations from a `SpriteFrames` resource; use `idle`, `run`, `catch`, `hurt`, and `celebrate` as the animation keys. A short `AnimationPlayer` track or a small GDScript tween can add a low-cost squash, bounce, pickup sparkle, or hit flash without generating extra drawings. See the official [Godot 4.7 AnimatedSprite2D documentation](https://docs.godotengine.org/en/4.7/classes/class_animatedsprite2d.html) and [SpriteFrames documentation](https://docs.godotengine.org/en/4.7/classes/class_spriteframes.html).

Keep gameplay state separate from presentation. The player controller should emit or signal events such as `item_caught`, `player_hit`, and `run_finished`; the character animation script reacts to those events. This lets us replace temporary art without rewriting scoring or physics.

## Phase 4 — Add the first two unlockable characters

Only add these after Amani can complete a full run:

1. **Mandazi Mike:** playful stall-runner energy; first ability is a small bonus to coins/score from caught food. Keep the ability visible and simple to balance.
2. **Samosa Queen:** confident, celebratory market champion; first ability slightly increases the chance of a rare food drop. Show the bonus in the character selection screen and test that it does not make runs automatic wins.

For each character, reuse the same scene and animation contract. Change art, tuning data, and one ability value; do not duplicate the full movement/scoring code. Keep both earnable through play later; do not build purchases or loot boxes in this phase.

## What we will code together

As you generate and choose art, I can help build the player scene/controller, touch movement, item spawning, collisions, scoring/combos, hearts, HUD, run-end/retry flow, and the animation state machine in GDScript. When you add generated PNGs or sprite sheets to the project, share the filenames or ask me to inspect the assets; I can wire them into Godot and help fix frame alignment and import settings. Simple motion such as idle bobbing, squash/stretch, pickup flashes, and UI feedback can be made directly with Godot animation/tween code while we wait for hand-drawn poses.

## Definition of done for this phase

- One finger moves Amani smoothly across the portrait lane.
- Three food items can be caught and score correctly; one hazard costs a heart.
- HUD shows score, combo (if enabled), and remaining lives.
- A run ends clearly, saves latest/best score, and can be retried without restarting the app.
- Amani has a readable idle and run animation, plus at least one catch and one hit reaction.
- The APK is exported and tried on the connected Android phone after the editor version works.
- Only then begin adding Mandazi Mike and Samosa Queen.
