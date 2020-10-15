//
//  JGProgressHUDRingIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#import "JGProgressHUDIndicatorView.h"
#pragma clang diagnostic pop

/**
 A ring shaped determinate progress indicator.
 */
@interface JGProgressHUDRingIndicatorView : JGProgressHUDIndicatorView

/**
 Background color of the ring.
 @attention Custom values need to be set after assigning the indicator view to @c JGProgressHUD's @c indicatorView property.
 
 @b Default: Black for JGProgressHUDStyleDark, light gray otherwise.
 */
@property (nonatomic, strong, nonnull) UIColor *ringBackgroundColor;

/**
 Progress color of the progress ring.
 @attention Custom values need to be set after assigning the indicator view to @c JGProgressHUD's @c indicatorView property.
 
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

