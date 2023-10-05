Pod::Spec.new do |s|

    s.name    = 'MappIntelligence'
    s.version = '5.0.5'

    s.author   = { 'Mapp Digital' => 'devgroup.mobile@webtrekk.com' }
    s.homepage = 'https://mapp.com/mapp-cloud/analytics/app-analytics/'
    s.license  = { :type => 'MIT', :file => 'LICENSE.md' }
    s.ios.deployment_target = '10.0'
    s.source   = { :git => 'https://github.com/mapp-digital/MappIntelligence-iOS-v5.git', :tag => s.version }
    s.exclude_files = 'MappIntelligence/include/**'
    s.source_files = "MappIntelligence/**/*.{h,m}"
    s.ios.source_files = "MappIntelligenceiOS/**/*.{h,m}"
    s.user_target_xcconfig = {
            'GENERATE_INFOPLIST_FILE' => 'YES'
       }

        s.pod_target_xcconfig = {
         'GENERATE_INFOPLIST_FILE' => 'YES'
        }
    s.summary  = 'The MappIntelligence SDK allows you to track user activities, screen flow usage for your App.'

    s.frameworks         = 'Foundation', 'UIKit'
    s.ios.frameworks     = 'AVFoundation', 'AVKit', 'CoreTelephony', 'WebKit'
    
end
