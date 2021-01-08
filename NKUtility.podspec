#
# Be sure to run `pod lib lint NKUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NKUtility'
  s.version          = '0.1.1'
  s.summary          = 'NKUtility is utility of NikiKit'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.module_name = 'NKUtility'
  
  s.homepage         = 'https://github.com/wenghengcong/NKUtility'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenghengcong' => 'wenghengcong@icloud.com' }
  s.source           = { :git => 'https://github.com/wenghengcong/NKUtility.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wenghengcong'
  
  s.ios.deployment_target = '10.0'
  
  s.source_files = 'Source/Classes/**/*.{swift,xib,storyboard}'
  s.resource_bundle = { 'NKUtility' => 'Source/Assets/**/*.{png,jpg,jpeg,json,storyboard,xib,xcassets,strings,stringsdict}' }
  s.swift_version = '5.0'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'QuartzCore', 'AVFoundation'
  s.dependency 'L10n-swift'
  
end
