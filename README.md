JGProgressHUD
=============

Simple but powerful and modern progress HUD for iOS.

<img src="JGProgressHUD%20Tests/Screenshots/1.png" width="18.9%" height="18.9%"/>&nbsp;
<img src="JGProgressHUD%20Tests/Screenshots/2.png" width="18.9%" height="18.9%"/>&nbsp;
<img src="JGProgressHUD%20Tests/Screenshots/3.png" width="18.9%" height="18.9%"/>&nbsp;
<img src="JGProgressHUD%20Tests/Screenshots/6.png" width="18.9%" height="18.9%"/>&nbsp;
<img src="JGProgressHUD%20Tests/Screenshots/5.png" width="18.9%" height="18.9%"/>

#####Current Version: 1.0.3

Why use JGProgressHUD?
==================
####There already are so many other open source progress HUD components!
While other progress HUD components are nice they all have their problems. MBProgressHUD is outdated and buggy, MMProgressHUD is totally over engineered and requires a long time to implement, SVProgressHUD and HTProgressHUD are not implemented in the right way and they all don't offer the extensibility of JGProgressHUD. JGProgressHUD was inspired by all of these components to create the ideal progress indicator.

<b>Here comes JGProgressHUD:</b><br>
• Super simple to implement<br>
• Feature rich<br>
• Easy extensibility and customization (custom animations and progress indicators)<br>
• Up to date, ex. using a blurred view on iOS 8<br>
• Backwards compatibility to iOS 5<br>
• Well documented<br>
• Detects and repositions when Keyboards appear/disappear<br>
• And most importantly, it looks good!

Overview
==========

###Styles:
JGProgressHUD can be displayed in 3 styles:<br>
• <b>Extra Light</b><br>
• <b>Light<br>
• <b>Dark<br>

###Progress and Status Indicators:
By default a HUD will display an indeterminate progress indicator. The progress indicator can be completely removed or a different progress indicator can be assigned to the HUD. By default there are the following indicators built in:<br>
• <b>Indeterminate progress indicator</b><br>
• <b>Pie progress indicator</b><br>
• <b>Ring progress indicator</b><br><br>
By subclassing `JGProgressHUDIndicatorView` you can create a custom indicator view!<br><br>
The <a href="JGProgressHUD%20Tests">JGProgressHUD Tests</a> project contains example implementations for:<br>
• <b>Success indicator</b><br>
• <b>Error indicator</b><br>

###Animations:
By default a HUD will use a fade animation. Several parameters can be altered such as animation duration or animation curve. A HUD can be displayed without animation and different animations can be used. By default there are the following animations built in:<br>
• <b>Fade</b><br>
• <b>Zoom and Fade</b><br><br>
By subclassing `JGProgressHUDAnimation` you can create a custom animation!


Requirements
=================

• iOS 5 or higher<br>
• ARC

Documentation
================
Each header file contains detailed documentation for each method call. To start, see <a href="JGProgressHUD/JGProgressHUD/JGProgressHUD.h">JGProgressHUD.h</a>.

Examples
=================
#####Simple example:
```objc
JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
HUD.textLabel.text = @"Loading";
[HUD showInView:self.view];
[HUD dismissAfterDelay:3.0];
```
This displays a dark HUD with a spinner and the title "Loading", it is presented with a fade animation and is dismissed after 3 seconds with a fade animation.
<br>

See the <a href="JGProgressHUD%20Tests">JGProgressHUD Tests</a> project for more example implementations.

Installation
================
<b>CocoaPods:</b><br>
Add this to your `Podfile`:
```
pod 'JGProgressHUD', '1.0.2'
```

<b>As static library:</b><br>
Ideally you should use JGProgressHUD as a static library. To do so, drag the JGProgressHUD project file into your Xcode project. Next add JGProgressHUD as Target Dependency in your projects Build Phases. Then add libJGProgressHUD.a in Link Binary With Library. Finally make sure you have set the `-ObjC` flag in Other Linker Flags.<br>
See the <a href="JGProgressHUD%20Tests">JGProgressHUD Tests</a> project for an example implementation of JGProgressHUD as static library.

<b>Using source files:</b><br>
Add all files from <a href="JGProgressHUD/JGProgressHUD">JGProgressHUD</a> apart from the `JGProgressHUD-Prefix.pch` file to your project.

After you have included JGProgressHUD as static library or source files simply import `JGProgressHUD.h`.

License
==========
MIT License.<br>
©2014 Jonas Gessner.

Credits
==========
Created by Jonas Gessner © 2014.<br>
Inspired by HTProgressHUD and other open source progress HUD components.
