Pod::Spec.new do |s|
  s.name  		= 'SafeOperation'
  s.version		= '1.0.0'
  s.summary		= 'SafeOperation,操作安全'
  s.homepage 		= 'https://github.com/LOLITA0164/SafeOperation'
  s.license		= 'Copyright © 2017年 LOLITA. All rights reserved.SafeOperation'
  s.platform		= :ios
  s.author		= {'LOLITA0164' => '476512340@qq.com'}
  s.ios.deployment_target = '8.0'
  s.source		= {:git => 'https://github.com/LOLITA0164/SafeOperation.git',:tag => s.version}
  s.source_files  = "SafeOperation/SafeHandle/*.{h,m}"
end
