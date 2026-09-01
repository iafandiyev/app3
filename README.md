# raga.io - iOS SpriteKit Game

Raga.io is a fully functional iOS 2D multiplayer-style game inspired by Agar.io. You play as a colorful cell, eating smaller food particles to grow in size while avoiding larger enemies and viruses.

## Features
- **Smooth Gameplay:** Written entirely in Swift using the native SpriteKit framework.
- **Controls:** Virtual analog joystick for touch control.
- **Entities:** Player cell, AI Bots (with different behaviors), Food, Viruses, and Power-ups (Speed, Shield).
- **UI:** Includes a Minimap, Score HUD, and Leaderboard.
- **Game Mechanics:** Splitting, shrinking, eating, and physics-based movement.

## Building and Running
This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project file.

1. Ensure you have Xcode 15+ installed.
2. Install XcodeGen: `brew install xcodegen`
3. Generate the project: run `xcodegen generate` in the root folder.
4. Open the generated `raga-io.xcodeproj` in Xcode.
5. Build and run on your simulator or device.

## CI/CD and IPA Build
The repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that automatically builds an unsigned `.ipa` file upon pushing to the `main` branch. 
You can use tools like **Sideloadly** or **AltStore** to sideload this `.ipa` onto your iPhone.
