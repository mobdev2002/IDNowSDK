
Pod::Spec.new do |s|
  s.name         = 'iOSIDNowSDK'
  s.version      = '1.0.0'
  s.summary      = 'iOSIDNowSDK'
  s.description  = <<-DESC
                  iOSIDNowSDK
                   DESC
  s.homepage     = 'https://github.com/victoriiapetrenko/IDNowSDK.git'
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/victoriiapetrenko/IDNowSDK.git', :tag => 'master'}
  s.source_files  = 'ios/*.{h,m}'

  #s.dependency 'IDNowSDKCore.framework', '~> 3.8'
  #s.vendored_libraries = 'IDNowSDKCore.a'
  #s.libraries = 'IDNowSDKCore'
  #s.frameworks = 'IDNowSDKCore'

s.subspec 'Framework' do |sp|
    sp.ios.deployment_target = '8.0'
    #sp.ios.vendored_frameworks = 'ios/IDNowSDKCore.framework'
  end

  s.requires_arc = true
  s.static_framework = true
  s.dependency 'React'
  s.dependency 'IDnowSDK', '3.21.0'

end

  