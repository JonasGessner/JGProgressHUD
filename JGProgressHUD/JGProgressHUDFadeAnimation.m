//
//  JGProgressHUDFadeAnimation.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDFadeAnimation.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDFadeAnimation

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.4;
        self.animationOptions = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

- (void)setAnimationOptions:(UIViewAnimationOptions)animationOptions {
    _animationOptions = (animationOptions | UIViewAnimationOptionBeginFromCurrentState);
}

#pragma mark - Showing

- (void)show {
    [super show];
    
    self.progressHUD.alpha = 0.0f;
    
    self.progressHUD.hidden = NO;
    
    [UIView animateWithDuration:self.duration delay:0.0 options:self.animationOptions animations:^{
        self.progressHUD.alpha = 1.0f;
    } completion:^(BOOL __unused finished) {
        [self animationFinished];
    }];
}

#pragma mark - Hiding

- (void)hide {
    [super hide];
    
    [UIView animateWithDuration:self.duration delay:0.0 options:self.animationOptions animations:^{
        self.progressHUD.alpha = 0.0f;
    } completion:^(BOOL __unused finished) {
        [self animationFinished];
    }];
}

@end
