//
//  JGProgressHUDFadeZoomAnimation.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDFadeZoomAnimation

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shrinkAnimationDuaration = 0.2;
        self.expandAnimationDuaration = 0.1;
        self.expandScale = CGSizeMake(1.1, 1.1);
    }
    return self;
}

#pragma mark - Showing

- (void)show {
    [super show];
    
    self.progressHUD.alpha = 0.0;
    self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    NSTimeInterval totalDuration = self.expandAnimationDuaration+self.shrinkAnimationDuaration;
    
    self.progressHUD.hidden = NO;
    
    [UIView animateWithDuration:totalDuration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.progressHUD.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:self.shrinkAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(self.expandScale.width, self.expandScale.height);
    } completion:^(BOOL __unused _finished) {
        [UIView animateWithDuration:self.expandAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.progressHUD.HUDView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL __unused __finished) {
            [self animationFinished];
        }];
    }];
}

#pragma mark - Hiding

- (void)hide {
    [super hide];
    
    NSTimeInterval totalDuration = self.expandAnimationDuaration+self.shrinkAnimationDuaration;
    
    [UIView animateWithDuration:totalDuration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.progressHUD.alpha = 0.0;
    } completion:nil];
    
    [UIView animateWithDuration:self.expandAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(self.expandScale.width, self.expandScale.height);
    } completion:^(BOOL __unused _finished) {
        [UIView animateWithDuration:self.shrinkAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL __unused __finished) {
            self.progressHUD.HUDView.transform = CGAffineTransformIdentity;
            
            [self animationFinished];
        }];
    }];
}

@end
