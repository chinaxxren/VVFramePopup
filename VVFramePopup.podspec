
Pod::Spec.new do |spec|
  spec.name         = "VVFramePopup"
  spec.version      = "0.0.3"
  spec.summary      = "VVAppTrace 跟踪ios方法执行性能工具"
  spec.homepage     = "https://github.com/chinaxxren/VVFramePopup"
  spec.license      = "MIT"
  spec.author       = { "chinaxxren" => "182421693@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/chinaxxren/VVFramePopup.git", :tag => "#{spec.version}" }
  spec.source_files  = "VVFramePopup/Source", "VVFramePopup/Source/**/*.*"
  spec.frameworks  = "UIKit"
end
