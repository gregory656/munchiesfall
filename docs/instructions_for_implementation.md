VISUAL ART DIRECTION — STRICT REQUIREMENT

Use the attached Munchies Fall UI concept image as the visual reference for the entire interface.

Recreate its design language as closely as practical:
- Premium stylized 3D cartoon aesthetic.
- Colourful Kenyan Soko market backgrounds.
- Warm lighting, depth and rich environmental detail.
- Large glossy buttons with playful visual feedback.
- Wooden market-inspired panels and signage.
- Expressive, friendly African cartoon character illustrations.
- Vibrant purple, orange, yellow, green and blue accents.
- Polished mobile-game typography and consistent iconography.

Do not simply create default Godot buttons arranged in a grid.

Build a cohesive, production-quality mobile game interface. Use temporary illustrations and placeholders where final 3D assets are unavailable. Keep all screens visually consistent.

# MUNCHIES FALL — 3D GAME UI AND HOME SCREEN IMPLEMENTATION

Act as a senior Godot 4 game UI developer and GDScript engineer.

We are developing **Munchies Fall**, a full 3D mobile game with a colourful, stylized Kenyan Soko (market) identity.

Our current milestone is to build a polished, functional onboarding experience and main menu dashboard before beginning character modelling, market environment construction and gameplay systems.

## 1. IMPORTANT PROJECT RULES

Before writing code:

1. Inspect the existing Godot project and its complete folder structure.
2. Identify the existing main scene, project settings, scripts and assets.
3. Preserve the existing working project and Android export configuration.
4. Do not delete or overwrite existing working scenes without a clear reason.
5. Reuse existing files and folders where appropriate.
6. Use GDScript, not C#.
7. Use Godot 4-compatible APIs.
8. Keep the project compatible with Android devices.
9. Use mobile-friendly layouts, touch controls and responsive anchors.
10. Explain which files you create or modify and where they belong.

If something in the existing project is unclear, explain it before making destructive changes.

## 2. VISUAL DIRECTION

Create a premium-looking, stylized 3D mobile game interface.

The design should feel:
- Colourful, playful and welcoming.
- Modern and polished.
- Inspired by lively Kenyan street markets.
- Full of personality and visual detail.
- Easy to navigate on a phone.
- Suitable for a commercial mobile game.

Use warm colours, rich backgrounds, attractive panels, rounded buttons, subtle gradients, clean typography, tasteful shadows and smooth transitions.

Do not make the interface look like a generic admin dashboard or a basic developer prototype.

The 3D game world will eventually appear behind the interface. For this milestone, use attractive placeholder backgrounds if the actual market environment does not exist yet.

## 3. TECHNICAL UI ARCHITECTURE

Use Godot's Control node system for the interface.

Recommended architecture:
- CanvasLayer for the interface overlay.
- Control as the root of each UI screen.
- Containers and anchors for responsive layouts.
- GDScript for all interactions.
- Separate scenes for onboarding, home, settings, scores and placeholders.
- A central screen navigation manager or another clean navigation system.

Keep the actual game world separate from the UI.

The interface should be designed to work over a future full 3D environment.

## 4. ONBOARDING SCREEN

Create an attractive welcome screen.

Main title:

WELCOME TO MUNCHIES FALL!

Supporting message:

"Your Soko adventure starts here. Catch delicious surprises, discover extraordinary characters and become a legend of the market!"

Include:
- Munchies Fall branding.
- A visually attractive background.
- A prominent CONTINUE button.
- A small animated hand pointer indicating where the player should tap.
- A Settings shortcut.
- Smooth entrance animations and transitions.

The hand pointer should gently move or bounce towards the Continue button.

When Continue is tapped, transition to the main home screen.

Save onboarding completion locally so returning players can skip the introduction. Include a way to replay the welcome screen from settings if practical.

## 5. MAIN HOME SCREEN

Build the main dashboard.

It must contain:

### Top profile area
- Player avatar placeholder.
- Player name: Soko Rookie.
- Player level.
- Experience progress bar.
- Soko Coins placeholder.
- Premium currency placeholder.

### Main action
A large, visually dominant PLAY button.

For now, tapping PLAY should open a placeholder game screen explaining that the first playable market level is under development.

### Feature buttons

Create functional navigation buttons for:

1. PLAY
2. CHARACTERS
3. MARKET
4. SOKO TYCOON
5. DAILY REWARDS
6. CHALLENGES
7. LEADERBOARD
8. SETTINGS

Unfinished features should open attractive Coming Soon screens. Do not leave buttons inert.

### Dashboard statistics

Display:
- Current score.
- Best score.
- Total games played.
- Total items collected.

Use sample values where real game data does not exist yet. Make it clear these are placeholders and structure the system so real values can be connected later.

## 6. SETTINGS SCREEN

Create a functional settings screen containing:

- Music volume.
- Sound effects volume.
- Music on/off.
- Sound on/off.
- Vibration on/off.
- Graphics quality placeholder.
- Language placeholder.
- Back button.

Use proper sliders and toggle controls.

Persist settings locally using Godot ConfigFile or an appropriate Godot settings system.

Ensure settings remain saved when the game is closed and reopened.

## 7. SCORES AND PROFILE

Create a scores screen with:
- Best score.
- Latest score.
- Total games played.
- Highest combo placeholder.
- Total food collected.

Create a profile screen with:
- Player name.
- Level.
- Experience.
- Statistics.

Use a simple local data manager so we can connect actual gameplay data later.

## 8. COMING SOON SCREENS

Create a reusable placeholder screen for:
- Characters.
- Market.
- Soko Tycoon.
- Daily Rewards.
- Challenges.
- Leaderboard.

Each should have:
- A relevant icon or placeholder illustration.
- A short description.
- A Coming Soon label.
- A working Back button.

Do not implement fake multiplayer, fake purchases or fake online leaderboards.

## 9. ANIMATIONS AND INTERACTIONS

Implement:
- Smooth screen transitions.
- Button hover/press feedback where appropriate.
- Button scaling or subtle animation when tapped.
- Animated hand pointer on onboarding.
- Smooth panel entrances.
- Responsive touch interaction.

Avoid excessive animations that could hurt performance on lower-end Android phones.

## 10. SUGGESTED PROJECT STRUCTURE

Adapt this structure to the existing project rather than blindly duplicating files:

scenes/
  ui/
    onboarding/
      onboarding.tscn
    home/
      home.tscn
    settings/
      settings.tscn
    scores/
      scores.tscn
    profile/
      profile.tscn
    placeholders/
      coming_soon.tscn

scripts/
  ui/
    screen_manager.gd
    onboarding.gd
    home.gd
    settings.gd
    scores.gd
    profile.gd
  managers/
    save_manager.gd
    audio_manager.gd

assets/
  ui/
    backgrounds/
    icons/
    fonts/
    buttons/

## 11. QUALITY REQUIREMENTS

- Use clean, reusable GDScript.
- Avoid giant scripts that handle every screen.
- Use signals for UI communication where appropriate.
- Use sensible node names.
- Avoid unnecessary plugins and external dependencies.
- Ensure all buttons work.
- Ensure the interface scales properly on different Android screen sizes.
- Use portrait orientation unless the existing project has an intentional landscape configuration.
- Keep the design performant.

## 12. TESTING AND DELIVERY

After implementation:

1. Verify that the project opens without errors.
2. Verify that the onboarding screen loads.
3. Test the Continue button.
4. Test every home screen button.
5. Test Back navigation.
6. Test settings controls and persistence.
7. Test score and profile screens.
8. Check for missing assets and broken scene references.
9. Run the project in Godot and prepare it for Android testing.

Do not claim that something works unless you have actually tested it.

## 13. WORKING METHOD

Implement this milestone in small stages:

Stage 1: Inspect the existing project and report findings.

Stage 2: Create the onboarding screen.

Stage 3: Create the main home dashboard.

Stage 4: Add navigation and placeholder screens.

Stage 5: Add settings, scores and local persistence.

Stage 6: Polish animations and responsive layouts.

Stage 7: Test the complete experience.

After each stage, summarize the files changed and any testing performed.

Do not move into character modelling, market construction or actual gameplay implementation yet.

**FINAL GOAL:** When I launch Munchies Fall on my Android phone, I should see a polished welcome screen, tap Continue, enter a beautiful main menu, navigate through all available sections, adjust settings and view placeholder statistics. The UI must be ready for us to integrate the full 3D market world and characters in the next development milestone.