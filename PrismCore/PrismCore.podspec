Pod::Spec.new do |s|

s.name             = 'PrismCore'
s.version          = '0.1.6'
s.summary          = 'Prism SDK for iOS. provides core chat functionality to support your custom UI in connecting to Prism'
s.homepage         = 'https://prismapp.io'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = 'Prism'

s.platform         = :ios
s.source           = { :http => 'https://s3-ap-southeast-1.amazonaws.com/prismapp-files/PrismCore_0.1.6.zip' }

s.ios.deployment_target = '9.0'
s.ios.vendored_frameworks = 'PrismCore.framework'

end

