#
#  Be sure to run `pod spec lint DoRun.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DoRun"
  s.version      = "0.0.1"
  s.summary      = "DoRun is a elegant swift tool framework."


  s.homepage     = "https://github.com/guo-pf/DoRun"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "guo-pf" => "gpf51321@163.com" }


  s.source       = { :git => "https://github.com/guo-pf/DoRun.git", :tag => s.version }


  s.source_files  = "DoRun", "DoRun/DoRun/*.{swift}"

  s.platform                   = :ios

  s.ios.deployment_target      = '8.0'

end
