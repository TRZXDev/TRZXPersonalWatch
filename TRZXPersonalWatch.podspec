Pod::Spec.new do |s|
    s.name         = "TRZXPersonalWatch"
    s.version      = "0.0.1"
    s.ios.deployment_target = '8.0'
    s.summary      = "TRZXPersonalWatch"
    s.homepage     = "https://github.com/TRZXDev/TRZXPersonalHome"
    s.license              = { :type => "MIT", :file => "FILE_LICENSE" }
    s.author             = { "bicassos" => "383929022@qq.com" }
    s.source       = { :git => "https://github.com/TRZXDev/TRZXPersonalWatch.git", :tag => s.version }
    s.source_files  = "TRZXPersonalWatch/TRZXPersonalWatch/**/*.{h,m}"
    s.resources    = 'TRZXPersonalWatch/TRZXPersonalWatch/**/*.{xib,png}'

    s.dependency "TRZXNetwork"
    s.dependency "ReactiveCocoa", "~> 2.5"
    s.dependency "TRZXNetwork"
    s.dependency "MJExtension"
    s.dependency "TRZXKit"
    s.dependency "SDWebImage"


    s.requires_arc = true
end