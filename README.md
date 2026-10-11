# Fakhri Manager

Arabic RTL football manager career simulator for Android, built with Flutter. Includes a perspective/isometric-style tactical pitch (custom-painted, not a full 3D engine), squad management, tactics, match simulation, transfers, training/rest, board/fan confidence, budget, academy/facilities spending and career log.

## Build APK using Klencod IDE / GitHub Actions
1. Upload the contents of this folder to a GitHub repository (root must contain `pubspec.yaml`, `lib/`, and `.github/`).
2. Open **Actions** and run **Build Fakhri Manager APK**. Pushes to main/master also trigger a build.
3. The workflow creates missing Android platform files with `flutter create`, runs `flutter pub get`, analyzes the app, and builds a release APK.
4. Download artifact `Fakhri-Manager-APK` from the successful workflow run.

If Klencod has a direct Build APK option, open this project root. If it reports missing `android/app/build.gradle`, the workflow above generates the Android folder automatically.

## Scope / honesty
This is a playable prototype with simulated football data. The pitch is a 2.5D/perspective tactical visualization, not a real-time 3D match engine. No live real-world data, online multiplayer, or cloud save is included. Club/player names are fictionalized demo data or illustrative examples; no official logos/assets are included. APK has not been built in this authoring environment.
