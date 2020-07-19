#
# Be sure to run `pod lib lint AlertFactory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlertFactory'
  s.version          = '2.0.0'
  s.summary          = 'An declarative constructor for any AlertController'

  s.description      = <<-DESC
AlertFactory does everything you need to make more easy using any AlertController. With this, you can construct all alerts without nedding to call defaults methods that make more difficult to create an alert.
                       DESC

  s.homepage         = 'https://github.com/umobi/AlertFactory'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/AlertFactory.git', :tag => s.version.to_s }

  s.swift_version = '5.2'
  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.tvos.deployment_target = '13.0'
  s.macos.deployment_target = '10.15'

  s.source_files = 'Sources/AlertFactory/Classes/**/*'
end
