//
//  JGProgressHUDImageIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 05.08.15.
//  Copyright (c) 2015 Jonas Gessner. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#import "JGProgressHUDIndicatorView.h"
#pragma clang diagnostic pop

/**
 An indicator for displaying custom images. Supports animated images.
 
 You may subclass this class to create a custom image indicator view.
 */
@interface JGProgressHUDImageIndicatorView : JGProgressHUDIndicatorView

/**
 Initializes the indicator view with an UIImageView showing the @c image.
 
 @param image The image to show in the indicator view.
 */
- (instancetype __nonnull)initWithImage:(UIImage *__nonnull)image;

@end
