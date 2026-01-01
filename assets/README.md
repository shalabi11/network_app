# Assets README

This folder contains all assets used in the Network App.

## Structure

- **images/** - App images (logos, icons, etc.)
- **icons/** - Custom icon files
- **animations/** - Lottie animation JSON files

## How to Add Assets

1. Place your files in the appropriate subdirectory
2. Reference them in your code using the paths defined in `lib/core/constants/asset_constants.dart`

## Required Assets (Optional)

- `logo.png` - App logo
- `tower_icon.png` - Tower marker icon
- `splash.json` - Splash screen animation (Lottie)
- `loading.json` - Loading animation (Lottie)
- `empty.json` - Empty state animation (Lottie)
- `error.json` - Error animation (Lottie)

Note: The app will work without these assets. They are referenced in the code but not required for compilation.
