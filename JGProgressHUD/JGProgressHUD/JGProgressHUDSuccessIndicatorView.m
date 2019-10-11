//
//  JGProgressHUDSuccessIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUD.h"

static UIBezierPath *successBezierPath() {
    static UIBezierPath *path;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(1.5, 18)];
        [path addLineToPoint:CGPointMake(11, 28)];
        [path addLineToPoint:CGPointMake(31.5, 5.5)];
        
        [path setLineWidth:3];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineCapStyle:kCGLineCapRound];
    });

    return path;
}

@implementation JGProgressHUDSuccessIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    UIBezierPath *path = successBezierPath();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(33, 33), NO, 0.0);
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    UIImage *img = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIGraphicsEndImageContext();
    
    self = [super initWithImage:img];

    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Success",);
}

@end
