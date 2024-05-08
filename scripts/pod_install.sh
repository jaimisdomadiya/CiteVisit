cd ios

echo 'pod deintegrate...'
pod deintegrate

echo 'pod cache clean...'
pod cache clean --all

echo 'remove podfile/Podfile.lock...'
# rm Podfile && rm -rf Podfile.lock
rm -rf Podfile.lock

echo 'flutter build clean...'
flutter clean

echo 'flutter pub get...'
flutter pub get

echo 'pod install...'
arch -x86_64 pod install

echo 'pod installation completed! ✅'
cd ..

# post_install do |installer|
#   installer.pods_project.targets.each do |target|
#     flutter_additional_ios_build_settings(target)
#     target.build_configurations.each do |config|
#     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
#     config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
#         '$(inherited)',
#         'PERMISSION_CAMERA=1',
#         'PERMISSION_MICROPHONE=1',
#         'PERMISSION_PHOTOS=1',
#         'PERMISSION_NOTIFICATIONS=1',
#       ]
#     end
#     target.build_configurations.each do |build_configuration|
#         build_configuration.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64 i386'
#     end
#   end
# end