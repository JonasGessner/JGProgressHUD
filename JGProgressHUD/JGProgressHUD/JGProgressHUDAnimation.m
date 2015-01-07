//
//  JGProgressHUDAnimation.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDAnimation.h"
#import "JGProgressHUD.h"

@interface JGProgressHUD (Private)

- (void)animationDidFinish:(BOOL)presenting;

@end

@interface JGProgressHUDAnimation () {
    BOOL _presenting;
}

@property (nonatomic, weak) JGProgressHUD *progressHUD;

@end

@implementation JGProgressHUDAnimation

#pragma mark - Initializers

+ (instancetype)animation {
    return [[self alloc] init];
}

#pragma mark - Public methods

- (void)show {
    _presenting = YES;
}

- (void)hide {
    _presenting = NO;
}

- (void)animationFinished {
    [self.progressHUD animationDidFinish:_presenting];
}

@end
