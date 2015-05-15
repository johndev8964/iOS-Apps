# Uncomment this line to define a global platform for your project
# platform :ios, “8.0”

source 'https://github.com/CocoaPods/Specs.git'

target :CashAssistMobileCard do

pod 'MBProgressHUD', '~> 0.8'
pod 'SVProgressHUD'
pod 'AFNetworking', '~> 1.3.3'
pod 'ZXingObjC'
pod 'CocoaSecurity'
pod 'Toast', '~> 2.4'
pod 'IQKeyboardManager'

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

end



