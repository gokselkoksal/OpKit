Pod::Spec.new do |s|
  s.name         	= "OpKit"
  s.version      	= "0.0.1"
  s.summary      	= "A simple library to implement and execute operations with ease."
  s.description  	= "A simple library to implement and execute operations with ease using NSOperations."
  s.homepage     	= "https://github.com/gokselkoksal/OpKit"
  s.license      	= { :type => "MIT", :file => "LICENSE" }
  s.author         	= { "Goksel Koksal" => "gokselkoksal@gmail.com" }
  s.social_media_url = "http://twitter.com/gokselkk"
  s.platform     	= :ios, "8.0"
  s.source       	= { :git => "https://github.com/gokselkoksal/OpKit.git", :tag => "0.0.1" }
  s.source_files  	= "OpKit/Classes/**/*.{swift}"
end
