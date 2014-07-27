//
//  JGProgressHUDPieIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Hardtack. All rights reserved.
//

#import "JGProgressHUD.h"
#import "JGProgressHUDIndicatorView.h"

@interface JGProgressHUDPieIndicatorView : JGProgressHUDIndicatorView

/**
 Initializes the indicator view and sets the correct color to match the HUD style.
 */
- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style;

/**
 Tint color of the Pie. 
 
@b Default: white.
 */
@property (nonatomic, strong) UIColor *color;

@end
