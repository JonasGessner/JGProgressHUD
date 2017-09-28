//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    NSBundle *resourceBundle = [NSBundle bundleForClass:[self class]];
    
    NSString *imgPath = [resourceBundle pathForResource:@"jg_hud_error" ofType:@"png"];
    
    self = [super initWithImage:[[UIImage imageWithContentsOfFile:imgPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

- (void)setUpForHUDStyle:(JGProgressHUDStyle)style vibrancyEnabled:(BOOL)vibrancyEnabled {
    [super setUpForHUDStyle:style vibrancyEnabled:vibrancyEnabled];
    
    if (style == JGProgressHUDStyleDark) {
        self.contentView.tintColor = [UIColor whiteColor];
    }
    else {
        self.contentView.tintColor = [UIColor blackColor];
    }
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.contentView.tintColor = self.tintColor;
}

@end
