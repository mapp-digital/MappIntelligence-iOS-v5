Pod::Spec.new do |s|

    s.name    = 'MappIntelligence'
    s.version = '5.0.0-beta1'

    s.author   = { 'Mapp Digital' => 'devgroup.mobile@webtrekk.com' }
    s.homepage = 'https://mapp.com/mapp-cloud/analytics/app-analytics/'
    s.license  = { :type => 'MIT', :file => 'LICENSE.md' }
    s.ios.deployment_target = '10.0'
    s.watchos.deployment_target = '4.0'
    s.source   = { :git => 'https://github.com/Webtrekk/Webtrekk-iOS-v5.git', :tag => s.version }
    s.source_files = "MappIntelligence/**/*.{h,m}"
    s.watchos.source_files = "MappIntelligenceWatchOS/**/*.{h,m}"
    s.summary  = 'The MappIntelligence SDK allows you to track user activities, screen flow usage for your App.'

    s.frameworks         = 'Foundation', 'UIKit'
    s.ios.frameworks     = 'AVFoundation', 'AVKit', 'CoreTelephony'
    s.watchos.frameworks = 'WatchKit'
end
