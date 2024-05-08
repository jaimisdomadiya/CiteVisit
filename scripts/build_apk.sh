echo 'flutter build clean...'
flutter clean

echo 'flutter pub get...'
flutter pub get

echo 'fluter build apk...'
flutter build apk --split-per-abi --no-shrink

echo 'flutter apk build success! ✅'
cd build/app/outputs/flutter-apk
open .