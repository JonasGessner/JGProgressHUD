//
//  JGProgressHUDFadeAnimation.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#import "JGProgressHUDAnimation.h"
#pragma clang diagnostic pop

/**
 A simple fade animation that fades the HUD from alpha @c 0.0 to alpha @c 1.0.
 */
@interface JGProgressHUDFadeAnimation : JGProgressHUDAnimation

/**
 Duration of the animation.
 
 @b Default: 0.4.
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 Animation options
 
 @b Default: UIViewAnimationOptionCurveEaseInOut.
 */
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

@end
