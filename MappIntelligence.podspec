Pod::Spec.new do |s|

    s.name    = 'MappIntelligence'
    s.version = '5.0.4.2'

    s.author   = { 'Mapp Digital' => 'devgroup.mobile@webtrekk.com' }
    s.homepage = 'https://mapp.com/mapp-cloud/analytics/app-analytics/'
    s.license  = { :type => 'MIT', :file => 'LICENSE.md' }
    s.ios.deployment_target = '10.0'
    s.watchos.deployment_target = '4.0'
    s.tvos.deployment_target = '11.0'
    s.source   = { :git => 'https://github.com/mapp-digital/MappIntelligence-iOS-v5.git', :tag => s.version }
    s.exclude_files = 'MappIntelligence/include/**', 'MappIntelligence/UserMatching/AppoxeeSDK.xcframework/ios-arm64_x86_64-simulator/HeadersSim/**',
    'MappIntelligence/UserMatching/AppoxeeSDK.xcframework/tvos-arm64/HeadersTV/**',
    'MappIntelligence/UserMatching/AppoxeeSDK.xcframework/tvos-arm64_x86_64-simulator/HeadersTVSim/**',
    'MappIntelligence/UserMatching/AppoxeeSDK.xcframework/watchos-arm64_arm64_32/HeadersWatchOS/**',
    'MappIntelligence/UserMatching/AppoxeeSDK.xcframework/watchos-arm64_x86_64-simulator/HeadersWatchOSSim/**'
    s.source_files = "MappIntelligence/**/*.{h,m}"
    s.watchos.source_files = "MappIntelligenceWatchOS/**/*.{h,m}"
    s.ios.source_files = "MappIntelligenceiOS/**/*.{h,m}"
    s.tvos.source_files = "MappIntelligencetvOS/**/*.{h,m}"
    s.summary  = 'The MappIntelligence SDK allows you to track user activities, screen flow usage for your App.'

    s.frameworks         = 'Foundation', 'UIKit'
    s.ios.frameworks     = 'AVFoundation', 'AVKit', 'CoreTelephony', 'WebKit'
    s.watchos.frameworks = 'WatchKit'
    
    s.ios.vendored_frameworks = 'MappIntelligence/UserMatching/AppoxeeSDK.xcframework'
end
