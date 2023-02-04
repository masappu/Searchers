# Uncomment the next line to define a global platform for your project
# platform :ios, '15.2'

target 'Seachers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Seachers
pod 'GoogleMaps', '6.0.1'
pod 'GooglePlaces', '6.0.0'
pod 'SwiftyJSON'
pod 'Alamofire', '5.5.0'
pod 'SDWebImage', '5.12.2'
pod 'RealmSwift'
pod 'VideoSplashKit'

disableGenerics = ['RealmSwift']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if disableGenerics.include?(target.name)
                config.build_settings['OTHER_SWIFT_FLAGS'] = '-Xfrontend -requirement-machine-inferred-signatures=off'
            end
        end
    end
end

end
