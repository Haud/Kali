
Pod::Spec.new do |s|
  s.name             = "Kali"
  s.version          = "1.0.3"
  s.summary          = "Better Date and Time handling using Swift."


  s.description      = <<-DESC
  Kali is a library that simplifies Date and Time handling for iOS frameworks. It wraps some of the more cumbersome features of NSDate, NSCalendar, etc. and abstracts it behind an easy-to-use, simple API for interacting with dates.
                       DESC

  s.homepage         = "https://github.com/Haud/Kali"
  s.license          = 'MIT'
  s.author           = { "Christopher Jones" => "chris.jones@haud.co" }
  s.source           = { :git => "https://github.com/Haud/DateTime.git", :tag => s.version.to_s }

s.platforms     = { :ios => '8.0', :tvos => '9.0', :watchos => '2.0' }
  s.requires_arc = true

  s.source_files = 'src/*.swift'
  
end
