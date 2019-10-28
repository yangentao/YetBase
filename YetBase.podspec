#
# Be sure to run `pod lib lint Yson.podspec' to ensure this is a
# pod spec lint
# pod trunk push
#

Pod::Spec.new do |s|
  prjName = 'YetBase'
  s.name             = prjName
  s.version          = '1.1.1'
  s.summary          = "#{prjName} is an iOS  library writen by swift."
  s.description      = "#{prjName} is an iOS library writen by swift. OK"
  s.homepage         = "https://github.com/yangentao/#{prjName}"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangentao' => 'entaoyang@163.com' }
  s.source           = { :git => "https://github.com/yangentao/#{prjName}.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_versions = ["5.0", "5.1"]

  s.source_files = "#{prjName}/Classes/**/*"
  
  # s.resource_bundles = {
  #   prjName => ["#{prjName}/Assets/*.png"]
  # }

  # s.frameworks = 'UIKit', 'MapKit'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
