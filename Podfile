# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

target 'BNAHDataRecoder' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  pod 'SDWebImage'
  pod 'IQKeyboardManager'
  pod 'SVProgressHUD'
  pod 'SCLAlertView'
  pod 'RealmSwift'

  # Pods for BNAHDataRecoder

  target 'BNAHDataRecoderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BNAHDataRecoderUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
