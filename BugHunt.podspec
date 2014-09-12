Pod::Spec.new do |s|

  s.name         = "BugHunt"
  s.version      = "0.0.1"
  s.summary      = "A drop-in module that allows for easy bug reporting."
  s.license      = "Etsy Inc."

  s.homepage     = ""
  s.screenshots  = ""

  s.author       = { "Chris Constable" => "cconstable@etsy.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "", :tag => "0.0.1" }

  s.source_files  = "BugHunt/**/*.{h,m}"
  s.public_header_files = "BugHunt/**/*.h"
  s.resources = "BugHunt/**/*.{png,xib}"
  
  s.requires_arc = true
  s.dependency 'MBProgressHUD', '~> 0.8'
  s.dependency 'AFNetworking/UIKit', '~> 2.0'

end
