Pod::Spec.new do |s|

  s.name         	= "JGProgressHUD"
  s.version      	= "1.4"
  s.summary      	= "Powerful and modern progress HUD for iOS."
  s.homepage     	= "https://github.com/JonasGessner/JGProgressHUD"
  s.license      	= { :type => "MIT", :file => "LICENSE.txt" }
  s.author             	= "Jonas Gessner"
  s.social_media_url   	= "http://twitter.com/JonasGessner"
  s.platform     	= :ios, "6.0"
  s.source       	= { :git => "https://github.com/JonasGessner/JGProgressHUD.git", :tag => "v1.4" }
  s.source_files 	= "JGProgressHUD/JGProgressHUD/*.{h,m}"
  s.resource	 	= "JGProgressHUD/JGProgressHUD/JGProgressHUD Resources.bundle"
  s.frameworks 	 	= "Foundation", "UIKit", "QuartzCore"
  s.requires_arc 	= true

end
