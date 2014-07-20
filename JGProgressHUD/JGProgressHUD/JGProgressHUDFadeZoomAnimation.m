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
    self.progressHUD.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    //Unhide the HUD
    self.progressHUD.hidden = NO;
    
    //Now animate the presentation
    [UIView animateWithDuration:self.shrinkAnimationDuaration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.progressHUD.alpha = 0.5f;
        self.progressHUD.transform = CGAffineTransformMakeScale(self.expandScale.width, self.expandScale.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.expandAnimationDuaration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressHUD.alpha = 1.0f;
            self.progressHUD.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self animationFinished];
        }];
    }];
}

#pragma mark - Hiding

- (void)hide {
    [super hide];
    
    //Animate the dismissal
    [UIView animateWithDuration:self.expandAnimationDuaration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.progressHUD.alpha = 0.5f;
        self.progressHUD.transform = CGAffineTransformMakeScale(self.expandScale.width, self.expandScale.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.shrinkAnimationDuaration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressHUD.alpha = 0.0f;
            self.progressHUD.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            [self animationFinished];
            
            //HUD is now hidden, restore the transform
            self.progressHUD.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
