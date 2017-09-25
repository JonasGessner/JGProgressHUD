//
//  JGProgressHUDRingIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUD-Defines.h"
#import "JGProgressHUDIndicatorView.h"

@interface JGProgressHUDRingIndicatorView : JGProgressHUDIndicatorView

/**
 Initializes the indicator view and sets the correct color to match the HUD style.
 */
- (instancetype __nonnull)initWithHUDStyle:(JGProgressHUDStyle)style;

/**
 Background color of the ring.
 
 @b Default: Black for JGProgressHUDStyleDark, light gray otherwise.
 */
@property (nonatomic, strong, nonnull) UIColor *ringBackgroundColor;

/**
 Progress color of the progress ring.
 
 @b Default: White for JGProgressHUDStyleDark, otherwise black.
 */
@property (nonatomic, strong, nonnull) UIColor *ringColor;

/**
 Sets if the progress ring should have a rounded line cap.
 
 @b Default: NO.
 */
@property (nonatomic, assign) BOOL roundProgressLine;

/**
 Width of the ring.
 
 @b Default: 3.0.
 */
@property (nonatomic, assign) CGFloat ringWidth;

@end
