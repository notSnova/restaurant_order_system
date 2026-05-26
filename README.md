# restaurant_order_system

- commands:
  emulator -avd Pixel_6 <!-- Run emulator -->
  flutter run -d web-server <!-- To run debug mode through web -->
  flutter run <!-- To run debug mode through emulator -->
  flutter pub get <!-- Resolve app dependencies -->
  flutter build apk <!-- Build apk in build folder -->
  flutter install <!-- Install apk in emulator -->
  adb install -r build/app/outputs/flutter-apk/app-release.apk <!-- Re-install apk in emulator -->
  adb uninstall com.example.restaurant_order_system <!-- Uninstall apk in emulator -->

Step to run the project:

1. Open project folder via VSCode.
2. Run 'flutter pub get' command through terminal.
3. Run your emulator (preferably Pixel 6 device).
4. Run 'flutter build apk' command in terminal.
5. Run 'flutter install' command in terminal.
6. Wait until the system build and install done.
7. Run the application.
8. Done.
