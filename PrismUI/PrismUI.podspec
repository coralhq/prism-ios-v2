Pod::Spec.new do |s|

s.name             = 'PrismUI'
s.version          = '0.2.0'
s.summary          = 'Prism SDK for iOS. provides snap on UI functionality to enable fast integration with Prism'
s.homepage         = 'https://prismapp.io'
s.license          = { :type => 'MIT', :file => 'LICENSE'}
s.author           = 'Prism'

s.platform         = :ios
s.swift_version    = '4.0'
s.ios.deployment_target = '9.0'

s.source           = { :git => 'https://github.com/coralhq/prism-ios-v2.git', :tag => s.version }
s.source_files = 'PrismUI/PrismUI/**/*.{h,m,swift}'
s.frameworks = 'UIKit', 'Foundation'
s.resource_bundles = {
    'PrismUI' => ['PrismUI/PrismUI/**/*.{xcassets,plist,xcdatamodeld,xib,strings}']
}
s.dependency 'PrismCore', '0.2.0'

end

