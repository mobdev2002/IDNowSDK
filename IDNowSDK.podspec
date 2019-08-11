
Pod::Spec.new do |s|
  s.name         = "IDNowSDK"
  s.version      = "1.0.0"
  s.summary      = "IDNowSDK"
  s.description  = <<-DESC
                  IDNowSDK.
                   DESC
  s.homepage     = "http://facebook.github.io/react-native/"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/IDNowSDK", :tag => "master" }
  s.source_files  = "IDNowSDK/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  