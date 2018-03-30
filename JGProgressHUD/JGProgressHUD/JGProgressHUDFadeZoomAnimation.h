//
//  JGProgressHUDFadeZoomAnimation.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDAnimation.h"

/**
 An animation that fades in the HUD and expands the HUD from scale @c (0, 0) to a customizable scale, and finally to scale @c (1, 1), creating a bouncing effect.
 */
@interface JGProgressHUDFadeZoomAnimation : JGProgressHUDAnimation

/**
 Duration of the animation from or to the shrinked state.
 
 @b Default: 0.2.
 */
@property (nonatomic, assign) NSTimeInterval shrinkAnimationDuaration;

/**
 Duration of the animation from or to the expanded state.
 
 @b Default: 0.1.
 */
@property (nonatomic, assign) NSTimeInterval expandAnimationDuaration;

/**
 The scale to apply to the HUD when expanding.
 
 @b Default: (1.1, 1.1).
 */
@property (nonatomic, assign) CGSize expandScale;

@end
