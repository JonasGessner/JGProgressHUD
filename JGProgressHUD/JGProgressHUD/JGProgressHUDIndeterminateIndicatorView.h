//
//  JGProgressHUDIndeterminateIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Hardtack. All rights reserved.
//

#import "JGProgressHUD-Defines.h"
#import "JGProgressHUDIndicatorView.h"

@interface JGProgressHUDIndeterminateIndicatorView : JGProgressHUDIndicatorView

/**
 Initializes the indicator view and sets the correct color to match the HUD style.
 */
- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style;

/**
 Set the color of the activity indicator view.
 @param color The color to apply to the activity indicator view.
 */
- (void)setColor:(UIColor *)color;

@end
