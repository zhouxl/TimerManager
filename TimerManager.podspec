Pod::Spec.new do |s|
  s.name         = "TimerManager"
  s.version      = "0.0.1"
  s.summary      = "Manager timed task that interval is 1 seconds."
  s.homepage     = "http://github/zhouxl/TimerManager"
  s.license      = 'MIT'
  s.author       = { "小六" => "zhouxinglong72@gmail.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "http://github/zhouxl/TimerManager.git", :tag => "#{s.version}" }
  s.source_files  = "TimerManager/*.swift"
  s.requires_arc = true
  s.swift_version = '4.2'
end
