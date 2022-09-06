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
  
  # 参考写法 https://github.com/microsoft/fluentui-apple/blob/main/MicrosoftFluentUI.podspec
  s.module_name = 'NKUtility'
  
  s.homepage         = 'https://github.com/wenghengcong/NKUtility'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenghengcong' => 'wenghengcong@icloud.com' }
  s.source           = { :git => 'https://github.com/wenghengcong/NKUtility.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wenghengcong'
  
  s.ios.deployment_target = '14.0'
  
  s.source_files = 'Source/*.{h,m,swift,xib,storyboard,md}','Source/Classes/**/*.{h,m,swift,xib,storyboard,md,xcassets,strings,stringsdict,md,css,html,js}'
  s.resource_bundle = { 'NKUtilityResource' => 'Source/Assets/**/*.{png,jpg,jpeg,json,storyboard,xib,xcassets,strings,stringsdict,md,css,html,js,ttf,txt}' }
#  s.resources =  'Source/Assets/**/*.{png,jpg,jpeg,json,storyboard,xib,xcassets,strings,stringsdict,md,css,html,js}'

  s.swift_version = '5.0'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'QuartzCore', 'AVFoundation'
  s.dependency 'SwiftTheme'
  s.dependency 'MicrosoftFluentUI'
  s.dependency 'SnapKit'
  s.dependency 'Kingfisher'
  s.dependency 'XCGLogger'
  s.dependency 'SwiftyJSON'
  s.dependency 'GCDWebServer'
  s.dependency 'SVGKit'
#  s.dependency 'GCDWebServer/WebUploader'
#  s.dependency 'GCDWebServer/WebDAV'
  # HTML Parser https://github.com/scinfu/SwiftSoup
  s.dependency 'SwiftSoup'
#  s.dependency 'Kanna'
  s.dependency 'SwiftyUserDefaults'
#  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/**' }
end
