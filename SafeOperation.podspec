Pod::Spec.new do |s|
  s.name  		= 'SafeOperation'
  s.version		= '1.0.0'
  s.summary		= '安全操作数据'
  s.homepage 		= 'https://github.com/LOLITA0164/SafeOperation'
  s.license		= 'MIT'
  s.platform		= :ios
  s.author		= {'LOLITA0164' => '476512340@qq.com'}
  s.ios.deployment_target = '8.0'
  s.source		= {:git => 'https://github.com/LOLITA0164/SafeOperation.git',:tag => s.version}
  s.source_files  = "SafeOperation/*.{h,m}"
end
