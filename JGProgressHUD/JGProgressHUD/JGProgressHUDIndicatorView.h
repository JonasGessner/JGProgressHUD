//
//  JGProgressHUDIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JGProgressHUD-Defines.h"

/** You may subclass this class to create a custom progress indicator view. */
@interface JGProgressHUDIndicatorView : UIView

/**
 Designated initializer for this class.
 
 @param contentView The content view to place on the container view (the container is the JGProgressHUDIndicatorView).
 */
- (instancetype __nonnull)initWithContentView:(UIView *__nullable)contentView;

/** Use this method to set up the indicator view to fit the HUD style and vibrancy setting. This method is called by @c JGProgressHUD when the indicator view is added to the HUD and when the HUD's @c vibrancyEnabled property changes. This method may be called multiple times with different values. The default implementation does nothing. */
- (void)setUpForHUDStyle:(JGProgressHUDStyle)style vibrancyEnabled:(BOOL)vibrancyEnabled;

/** Ranges from 0.0 to 1.0. */
@property (nonatomic, assign) float progress;

/**
 Adjusts the current progress shown by the receiver, optionally animating the change.
 
 The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
 
 @param progress The new progress value.
 @param animated YES if the change should be animated, NO if the change should happen immediately.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 The content view which displays the progress.
 */
@property (nonatomic, strong, readonly, nullable) UIView *contentView;

/** Schedules an accessibility update on the next run loop. */
- (void)setNeedsAccessibilityUpdate;

/**
 Runs @c updateAccessibility immediately if an accessibility update has been scheduled (through @c setNeedsAccessibilityUpdate) but has not executed yet.
 */
- (void)updateAccessibilityIfNeeded;

/**
 Override to set custom accessibility properties. This method gets called once when initializing the view and after calling @c setNeedsAccessibilityUpdate.
 */
- (void)updateAccessibility;

@end
