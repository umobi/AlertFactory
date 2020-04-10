#
# Be sure to run `pod lib lint AlertFactory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlertFactory'
  s.version          = '1.1.3'
  s.summary          = 'An declarative constructor for any AlertController'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
AlertFactory does everything you need to make more easy using any AlertController. With this, you can construct all alerts without nedding to call defaults methods that make more difficult to create an alert.
                       DESC

  s.homepage         = 'https://github.com/umobi/AlertFactory'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/AlertFactory.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.1'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/AlertFactory/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AlertFactory' => ['AlertFactory/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
