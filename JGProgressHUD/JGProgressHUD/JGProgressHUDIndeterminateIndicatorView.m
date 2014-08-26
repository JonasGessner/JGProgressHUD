//
//  JGProgressHUDIndeterminateIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Hardtack. All rights reserved.
//

#import "JGProgressHUDIndeterminateIndicatorView.h"

@implementation JGProgressHUDIndeterminateIndicatorView

- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView startAnimating];
    self = [super initWithContentView:activityIndicatorView];
    
    if (self) {
        if (style != JGProgressHUDStyleDark) {
            self.color = [UIColor blackColor];
        }
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithHUDStyle:0];
}

- (void)setColor:(UIColor *)color {
    [(UIActivityIndicatorView *)self.contentView setColor:color];
}

@end
