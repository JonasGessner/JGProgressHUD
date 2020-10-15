//
//  JGProgressHUDSuccessIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#import "JGProgressHUDImageIndicatorView.h"
#pragma clang diagnostic pop

/**
 An image indicator showing a checkmark, representing a failed operation.
 */
@interface JGProgressHUDSuccessIndicatorView : JGProgressHUDImageIndicatorView

/**
 Default initializer for this class.
 */
- (instancetype __nonnull)init;

@end
