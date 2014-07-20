//
//  JGProgressHUDFadeAnimation.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDAnimation.h"

@interface JGProgressHUDFadeAnimation : JGProgressHUDAnimation

/**
 Duration of the animation.
 */
@property (nonatomic) NSTimeInterval duration;

/**
 Animation options
 @b Default: UIViewAnimationOptionCurveEaseInOut.
 */
@property (nonatomic) UIViewAnimationOptions animationOptions;

@end
