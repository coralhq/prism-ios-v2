Pod::Spec.new do |s|

s.name             = 'PrismCore'
s.version          = '0.2.0'
s.summary          = 'Prism SDK for iOS. provides core chat functionality to support your custom UI in connecting to Prism'
s.homepage         = 'https://prismapp.io'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = 'Prism'

s.platform         = :ios
s.source           = { :git => 'https://github.com/coralhq/prism-ios-v2.git', :tag => s.version }
s.swift_version    = '4.0'

s.ios.deployment_target = '9.0'
s.source_files = 'PrismCore/PrismCore/**/*.{h,m,swift}'
s.frameworks    = 'UIKit', 'Foundation'

end

