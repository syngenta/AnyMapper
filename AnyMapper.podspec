#
# Be sure to run `pod lib lint FieldCreator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AnyMapper'
  s.version          = `git describe --abbrev=0 --tags`
  s.summary          = 'Library for mappind Dictionary to struct'
  s.description      = 'Library for mappind Dictionary<String: Any> and NSDictionary to struct or class'
  s.homepage         = 'https://github.com/Lumyk/AnyMapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Kalashnikov' => 'lumyk@me.com' }
  s.source           = { :git => 'https://github.com/Lumyk/AnyMapper.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '11.0'
  s.watchos.deployment_target = '3.0'
  s.swift_versions = '5.3'

  s.source_files = 'Sources/AnyMapper/**/*.swift'

end
