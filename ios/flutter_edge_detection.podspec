#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint edge_detection.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_edge_detection'
  s.version          = '1.0.0'
  s.summary          = 'Plugin to detect edges of objects'
  s.description      = <<-DESC
A Flutter plugin for real-time edge detection and document scanning with advanced image processing capabilities.
                       DESC
  s.homepage         = 'https://github.com/jayfinava/flutter_edge_detection'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jay Finava' => 'jayfinava4505@gmail.com' }
  s.resources        = 'Assets/**/*'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'WeScan'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0',
    'SWIFT_VERSION' => '5.0'
  }
  s.swift_version = '5.0'
end 