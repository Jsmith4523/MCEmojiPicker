Pod::Spec.new do |s|
  s.name = 'MCEmojiPicker'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Test framework'
  s.homepage = 'https://github.com/izyumkin/MCEmojiPicker'
  s.authors = { 'Ivan Izyumkin' => 'izzyumkin@gmail.com' }
  
  s.source = { :git => 'https://github.com/izyumkin/MCEmojiPicker.git', :tag => s.version.to_s }
  s.source_files = 'Sources/MCEmojiPicker/**/*.swift'
  s.swift_version = '4.2'
  s.platform = :ios, '11.1'

end