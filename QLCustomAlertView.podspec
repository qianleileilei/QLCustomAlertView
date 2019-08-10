#
#  Be sure to run `pod spec lint QLCustomAlertView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "QLCustomAlertView"
  spec.version      = "0.0.1"
  spec.summary      = "A Custom AlertView for UI modification"
  spec.description  = <<-DESC
			this is QLCustomAlertView repo, use QLCustomAlertView you can easy handle the UI for all kinds of AlertView.
                   DESC

  spec.homepage     = "https://www.jianshu.com/u/2808d08f9104"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "qianlei" => "13698090397@163.com" }
  spec.social_media_url   = "https://www.jianshu.com/u/2808d08f9104"
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "8.0"

  spec.source       = { :git => "https://github.com/qianleileilei/QLCustomAlertView.git", :tag => spec.version }
  spec.source_files  = "QLCustomAlertView/QLCustomAlertView/Classes/*.{h,m}"
  
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  spec.frameworks = "UIKit", "Foundation"
  spec.requires_arc = true
  spec.dependency "Masonry", "~> 1.1.0"

end
