//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"

static UIBezierPath *errorBezierPath() {
    static UIBezierPath *path;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(3, 3)];
        [path addLineToPoint:CGPointMake(30, 30)];
        [path moveToPoint:CGPointMake(30, 3)];
        [path addLineToPoint:CGPointMake(3, 30)];
        
        [path setLineWidth:3];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineCapStyle:kCGLineCapRound];
    });
    
    return path;
}

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    UIBezierPath *path = errorBezierPath();

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
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

@end
