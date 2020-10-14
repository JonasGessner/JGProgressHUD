//
//  JGProgressHUDPieIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#if SWIFT_PACKAGE
#import "JGProgressHUD-Defines.h"
#import "JGProgressHUDIndicatorView.h"
#else
#import <JGProgressHUD/JGProgressHUD-Defines.h>
#import <JGProgressHUD/JGProgressHUDIndicatorView.h>
#endif

/**
 A pie shaped determinate progress indicator.
 */
@interface JGProgressHUDPieIndicatorView : JGProgressHUDIndicatorView

/**
 Tint color of the Pie.
 @attention Custom values need to be set after assigning the indicator view to @c JGProgressHUD's @c indicatorView property.
 
 @b Default: White for JGProgressHUDStyleDark, otherwise black.
 */
@property (nonatomic, strong, nonnull) UIColor *color;

/**
 The background fill color inside the pie.
 @attention Custom values need to be set after assigning the indicator view to @c JGProgressHUD's @c indicatorView property.
 
 @b Default: Dark gray for JGProgressHUDStyleDark, otherwise light gray.
 */
@property (nonatomic, strong, nonnull) UIColor *fillColor;

@end
