
Pod::Spec.new do |s|
  s.name             = "DateTime"
  s.version          = "1.0.0"
  s.summary          = "Better Date and Time handling using Swift."


  s.description      = <<-DESC
  DateTime is a library that simplifies Date and Time handling for iOS frameworks. It wraps some of the more cumbersome features of NSDate, NSCalendar, etc. and abstracts behind an easy-to-use, simple API for interacting with dates.
                       DESC

  s.homepage         = "https://github.com/Haud/DateTime"
  s.license          = 'MIT'
  s.author           = { "Christopher Jones" => "chris.jones@haud.co" }
  s.source           = { :git => "https://github.com/Haud/DateTime.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'src/*.swift'
  
end
