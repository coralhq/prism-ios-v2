Pod::Spec.new do |s|

s.name             = 'PrismUI'
s.version          = '0.1.0.0'
s.summary          = 'Prism SDK for iOS. provides snap on UI functionality to enable fast integration with Prism'
s.homepage         = 'https://prismapp.io'
s.license          = { :type => 'MIT', :file => 'LICENSE'}
s.author           = 'Prism'

s.platform         = :ios
s.source           = { :http => 'https://s3-ap-southeast-1.amazonaws.com/prismapp-files/PrismUI_0.1.0.0.zip' }

s.ios.deployment_target = '9.0'
s.ios.vendored_frameworks = 'PrismUI.framework'

s.dependency 'PrismCore', '0.1.0.0'

end

