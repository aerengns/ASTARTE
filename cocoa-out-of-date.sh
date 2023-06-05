flutter clean
sudo rm -rf ios/Pods
sudo rm ios/Podfile.lock
flutter pub get
( cd ios || exit ; pod install )