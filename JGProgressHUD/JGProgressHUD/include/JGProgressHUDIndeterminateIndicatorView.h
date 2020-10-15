//
//  JGProgressHUDIndeterminateIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#import "JGProgressHUDIndicatorView.h"
#pragma clang diagnostic pop

/**
 An indeterminate progress indicator showing a @c UIActivityIndicatorView.
 */
@interface JGProgressHUDIndeterminateIndicatorView : JGProgressHUDIndicatorView

/**
 Set the color of the activity indicator view.
 @param color The color to apply to the activity indicator view.
 */
- (void)setColor:(UIColor *__nonnull)color;

@end
