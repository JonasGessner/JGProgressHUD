//
//  JGProgressHUDFadeZoomAnimation.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDFadeZoomAnimation.h"

@implementation JGProgressHUDFadeZoomAnimation

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shrinkAnimationDuaration = 0.2;
        self.expandAnimationDuaration = 0.1;
        self.expandScale = CGSizeMake(1.1f, 1.1f);
    }
    return self;
}

#pragma mark - Showing

- (void)show {
    [super show];
    
    //Prepare the HUD
    self.progressHUD.alpha = 0.0f;
    self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    NSTimeInterval totalDuration = self.expandAnimationDuaration+self.shrinkAnimationDuaration;
    
    //Show the HUD
    self.progressHUD.hidden = NO;
    
    
    //Now animate the presentation
    [UIView animateWithDuration:totalDuration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.progressHUD.alpha = 1.0f;
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
    
    //Animate the dismissal
    [UIView animateWithDuration:totalDuration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.progressHUD.alpha = 0.0f;
    } completion:nil];
    
    [UIView animateWithDuration:self.expandAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(self.expandScale.width, self.expandScale.height);
    } completion:^(BOOL __unused _finished) {
        [UIView animateWithDuration:self.shrinkAnimationDuaration delay:0.0 options:(UIViewAnimationOptions)(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.progressHUD.HUDView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL __unused __finished) {
            //HUD is now hidden, restore the transform
            self.progressHUD.HUDView.transform = CGAffineTransformIdentity;
            
            //Alway call this last
            [self animationFinished];
        }];
    }];
}

@end
