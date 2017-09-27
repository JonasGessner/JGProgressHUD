JGProgressHUD
---------------

Modern and extensive Apple-style progress HUD for iOS and tvOS.<br/>
<p align="center">
<img src="Presentation.png"/>
</p>

Overview
---------------

__The ultimate progress HUD for iOS and tvOS has arrived: JGProgressHUD!__

- Plug and play: Simple integration, easy setup, few lines of code required.
- Extensible and customizable (custom animations, indicator views and more).
- Uses `UIVisualEffectView` and `UIMotionEffect` for a native look.
- Uses AutoLayout to provide a fully dynamic layout.
- Detects and repositions when keyboard appears/disappears.
- Well documented and maintained.
- Voice Over/`UIAccessibility` support.
- And most importantly, it looks good!

Check out the <a href="Examples">Examples</a> project to see multiple uses and some of the awesome features of JGProgressHUD in action!
<br/>
<br/>

[![GitHub release](https://img.shields.io/github/release/JonasGessner/JGProgressHUD.svg)](https://github.com/JonasGessner/JGProgressHUD/releases)
[![GitHub license](https://img.shields.io/github/license/JonasGessner/JGProgressHUD.svg)](https://github.com/JonasGessner/JGProgressHUD/blob/master/LICENSE.txt)
[![CocoaPods](https://img.shields.io/cocoapods/v/JGProgressHUD.svg)](https://cocoapods.org/pods/JGProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Customization
-----------
### Styles:
JGProgressHUD can be displayed in 3 styles:

- __Extra Light__
- __Light__
- __Dark__

### Indicator Views:
By default a HUD will display an indeterminate progress indicator. You can not show an indicator view at all by setting the `indicatorView` property to nil. These indicator views are available:

- __Indeterminate progress indicator__
- __Pie progress indicator__
- __Ring progress indicator__
- __Success indicator__
- __Error indicator__
- __Image indicator__

By subclassing `JGProgressHUDIndicatorView` you can create a custom indicator view!<br/>


### Animations:
By default a HUD will use a fade animation. Several parameters can be altered such as animation duration or animation curve. A HUD can be displayed without animation and different animations can be used. By default there are the following animations built in:

- __Fade__
- __Zoom and Fade__

By subclassing `JGProgressHUDAnimation` you can create a custom animation!
<br/><br/>
To dim the content behind the HUD set your dim color as `backgroundColor` of your `JGProgressHUD` instance.

Requirements
------------

- Base SDK of iOS/tvOS 11 or higher.
- Deployment target of iOS/tvOS 8.0 or higher.

JGProgressHUD can also be used by projects written in Swift. See <a href="https://github.com/JonasGessner/JGProgressHUD#installation">Installation</a> for details.

Documentation
----------------
Detailed documentation can be found on <a href="http://cocoadocs.org/docsets/JGProgressHUD">CocoaDocs</a>.<br/><br/>
Each method is well documented, making it easy to quickly get a great overview of JGProgressHUD. To start, see <a href="JGProgressHUD/JGProgressHUD/JGProgressHUD.h">JGProgressHUD.h</a>.

Examples
--------------
##### Showing indeterminate progress:

```objc
JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
HUD.textLabel.text = @"Loading";
[HUD showInView:self.view];
[HUD dismissAfterDelay:3.0];
```

This displays a dark HUD with a spinner and the title "Loading", it is presented with a fade animation and is dismissed after 3 seconds with a fade animation.
<br/>
##### Showing an error message:

```objc
JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
HUD.textLabel.text = @"Error";
HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init]; //JGProgressHUDSuccessIndicatorView is also available
[HUD showInView:self.view];
[HUD dismissAfterDelay:3.0];
```

##### Showing a custom image:

```objc
JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
HUD.indicatorView = [[JGProgressHUDImageIndicatorView alloc] initWithImage:[UIImage imageNamed:@"my_image.png"]];
[HUD showInView:self.view];
[HUD dismissAfterDelay:3.0];
```

##### Showing determinate progress:

```objc
JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init]; //Or JGProgressHUDRingIndicatorView
[HUD showInView:self.view];
[HUD dismissAfterDelay:3.0];
```

<b>Important:</b> You should always show HUDs in a UIViewController's view.
<br/><br/>
See the <a href="Examples">Examples</a> project for more example implementations.

Installation
--------------
### CocoaPods:
In your `Podfile` add:

```
pod 'JGProgressHUD'
```

### Carthage:
In your `Cartfile` add:

```
github "JonasGessner/JGProgressHUD" >= 1.3.1
```

### Framework:

1. Drag the `JGProgressHUD.xcodeproj` file into your Xcode project.
2. Add `JGProgressHUD.framework` to "Embedded Binaries" in the "General" tab of your project's target.
3. Add the `-ObjC` flag to "Other Linker Flags" in the "Build Settings" tab of your project's target.

Then import the module where you want to use it:

```objc
@import JGProgressHUD;
```

Swift projects:

```swift
import JGProgressHUD
```

See the <a href="Examples">Examples</a> project for an example implementation of JGProgressHUD as framework.

Screenshots
-------------
<p align="center">
<img src="Examples/Screenshots/1.png" width="24%"/>&nbsp;
<img src="Examples/Screenshots/3.png" width="24%"/>&nbsp;
<img src="Examples/Screenshots/6.png" width="24%"/>&nbsp;
<img src="Examples/Screenshots/5.png" width="24%"/>
</p>

License
---------
MIT License.<br/>
© 2014-2017, Jonas Gessner.

Credits
----------
Created and maintained by Jonas Gessner, © 2014-2017.<br/>
