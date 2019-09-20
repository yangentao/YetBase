#
# Be sure to run `pod lib lint Yson.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  prjName = 'YetBase'
  s.name             = prjName
  s.version          = '1.0.4'
  s.summary          = "#{prjName} is an iOS  library writen by swift."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "#{prjName} is an iOS library writen by swift. OK"

  s.homepage         = "https://github.com/yangentao/#{prjName}"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangentao' => 'entaoyang@163.com' }
  s.source           = { :git => "https://github.com/yangentao/#{prjName}.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_versions = ["5.0"]

  s.source_files = "#{prjName}/Classes/**/*"
  
  # s.resource_bundles = {
  #   prjName => ["#{prjName}/Assets/*.png"]
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  #s.frameworks = 'Foundation'
end
