Pod::Spec.new do |s|

    s.name    = 'Webtrekk'
    s.version = '0.0.1'

    s.author   = { 'Mapp Digital' => 'devgroup.mobile@webtrekk.com' }
    s.homepage = 'https://mapp.com/mapp-cloud/analytics/app-analytics/'
    s.license  = { :type => 'MIT', :file => 'LICENSE.md' }
    s.ios.deployment_target = '10.0'
    s.watchos.deployment_target = '4.0'
    s.source   = { :git => 'https://github.com/Webtrekk/webtrekk-ios-sdk.git', :tag => s.version }
    s.summary  = 'The MappIntelligence SDK allows you to track user activities, screen flow and media usage for your App.'

    s.module_map = 'Module/Module.modulemap'

    s.frameworks         = 'Foundation', 'UIKit'
    s.ios.frameworks     = 'AVFoundation', 'AVKit', 'CoreTelephony'
    s.watchos.frameworks = 'WatchKit'
end
