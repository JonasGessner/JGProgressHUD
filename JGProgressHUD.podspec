Pod::Spec.new do |s|

  s.name         = "JGProgressHUD"
  s.version      = "1.1"
  s.summary      = "Simple but powerful and modern progress HUD for iOS."
  s.description  = <<-DESC
<b>JGProgressHUD:</b>
• Super simple to implement
• Feature-rich
• Easy extensibility and customization (custom animations and progress indicators)
• Up to date, ex. using a blurred view on iOS 8
• Backwards compatibility to iOS 5
• Well documented
• And most importantly, it looks good!
DESC
  s.homepage     = "https://github.com/JonasGessner/JGProgressHUD"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author             = "Jonas Gessner"
  s.social_media_url   = "http://twitter.com/JonasGessner"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/JonasGessner/JGProgressHUD.git", :tag => "v1.1" }
  s.source_files  = "JGProgressHUD/JGProgressHUD/*.{h,m}"
  s.resources = "JGProgressHUD/JGProgressHUD/JGProgressHUD Resources.bundle"
  s.frameworks = "Foundation", "UIKit", "QuartzCore"
  s.requires_arc = true

end
