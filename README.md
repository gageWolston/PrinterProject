# Printer Shop (Flutter)

A small Flutter app used for a software engineering project. It demonstrates listings of printers, promos, a cart, and a minimal auth flow for testing.

## Notes
- Admin test credentials: **Username:** `Admin`, **Password:** `1234` (displayed in the drawer under "Super Secret Admin Account Info"). **don't tell anybody..**
- The app clears any logged-in session on startup to avoid leaking state between runs. Registered user accounts (username/password) are persisted in Hive.
- Snackbars have been removed to avoid blocking interactions; the app uses subtle visual feedback (animated cart icon + button press animations).

## Setup
Requirements:
- Flutter SDK (stable) >= 3.x
- Dart

Install dependencies:

```bash
flutter pub get
```

Run on device:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

## What I changed
I performed a code cleanup and small refactors to improve readability and maintainability without changing app behavior. See commit history for details.

## Share
- Recommended: push to a private repo and share the link.
- Alternatively: create a zip of the project excluding `build/`, `.dart_tool/`, `.idea/`, etc.

If you'd like, I can add a small `export` script or prepare a cleaned release branch for sharing.
