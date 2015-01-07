//
//  JGProgressHUDAnimation.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JGProgressHUD;

/**
 You may subclass this class to create a custom progress indicator view.
 */
@interface JGProgressHUDAnimation : NSObject

/**
 Convenience method for initializing an animation.
 */
+ (instancetype)animation;


/**
 The HUD which uses this animation.
 */
@property (nonatomic, weak, readonly) JGProgressHUD *progressHUD;


/**
 The @c progressHUD is hidden from screen with @c alpha = 1 and @c hidden = @c YES. Ideally, you should prepare the HUD for presentation, then set @c hidden to @c NO on the @c progressHUD and then perform the animation.
  @post Call @c animationFinished.
 */
- (void)show NS_REQUIRES_SUPER;

/**
 The @c progressHUD wis visible on screen with @c alpha = 1 and @c hidden = @c NO. You should only perform the animation in this method, the @c progressHUD itself will take care of hiding itself and removing itself from superview.
 @post Call @c animationFinished.
 */
- (void)hide NS_REQUIRES_SUPER;

/**
 @pre This method should only be called at the end of a @c show or @c hide animaiton.
 @attention ALWAYS call this method after completing a @c show or @c hide animation.
 */
- (void)animationFinished NS_REQUIRES_SUPER;

@end
