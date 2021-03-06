Pod::Spec.new do |s|
  s.name             = 'WZPresentationController'
  s.version          = '0.1.0'
  s.summary          = 'A short description of WZPresentationController.'
  s.homepage         = 'https://github.com/arcangelw/WZPresentationController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'arcangelw' => 'wuzhezmc@gmail.com' }
  s.source           = { :git => 'https://github.com/arcangelw/WZPresentationController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WZPresentationController/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation', 'Accelerate'
end
