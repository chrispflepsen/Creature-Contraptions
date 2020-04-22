#
# Be sure to run `pod lib lint Creature-Contraptions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CreatureContraptions'
  s.version          = '0.1.3'
  s.summary          = 'A Collection of general purpose Views and Extensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris Pflepsen' => '' }
  s.source           = { :git => 'https://github.com/chrispflepsen/CreatureContraptions.git', :tag => s.version.to_s }
  s.homepage         = 'https://github.com/chrispflepsen/CreatureContraptions.git'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '13.0'
  s.source_files = 'CreatureContraptions/Classes/**/*'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
end
