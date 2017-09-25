Pod::Spec.new do |s|

  s.name         	= "JGProgressHUD"
  s.version      	= "1.5"
  s.summary      	= "Powerful and modern progress HUD for iOS."
  s.homepage     	= "https://github.com/JonasGessner/JGProgressHUD"
  s.license      	= { :type => "MIT", :file => "LICENSE.txt" }
  s.author             	= "Jonas Gessner"
  s.social_media_url   	= "https://twitter.com/JonasGessner"
  s.platform     	= :ios, "8.0"
  s.source       	= { :git => "https://github.com/JonasGessner/JGProgressHUD.git", :tag => "v1.5" }
  s.source_files 	= "JGProgressHUD/JGProgressHUD/*.{h,m}"
  s.resource	 	= "JGProgressHUD/Resources/*.png"
  s.frameworks 	 	= "Foundation", "UIKit", "QuartzCore"
  s.requires_arc 	= true

end
