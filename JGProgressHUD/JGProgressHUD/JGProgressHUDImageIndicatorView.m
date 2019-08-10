//
//  JGProgressHUDImageIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 05.08.15.
//  Copyright (c) 2015 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDImageIndicatorView.h"

@implementation JGProgressHUDImageIndicatorView {
    BOOL _customizedTintColor;
}

- (instancetype)initWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self = [super initWithContentView:imageView];
    
    return self;
}

- (void)setUpForHUDStyle:(JGProgressHUDStyle)style vibrancyEnabled:(BOOL)vibrancyEnabled {
    [super setUpForHUDStyle:style vibrancyEnabled:vibrancyEnabled];

    if (!_customizedTintColor) {
        if (style == JGProgressHUDStyleDark) {
            self.tintColor = [UIColor whiteColor];
        }
        else {
            self.tintColor = [UIColor blackColor];
        }
        _customizedTintColor = NO;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _customizedTintColor = YES;
}

@end
