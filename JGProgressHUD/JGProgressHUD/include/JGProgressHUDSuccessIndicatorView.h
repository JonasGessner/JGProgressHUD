//
//  JGProgressHUDSuccessIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#if SWIFT_PACKAGE
#import "JGProgressHUDImageIndicatorView.h"
#else
#import <JGProgressHUD/JGProgressHUDImageIndicatorView.h>
#endif

/**
 An image indicator showing a checkmark, representing a failed operation.
 */
@interface JGProgressHUDSuccessIndicatorView : JGProgressHUDImageIndicatorView

/**
 Default initializer for this class.
 */
- (instancetype __nonnull)init;

@end
