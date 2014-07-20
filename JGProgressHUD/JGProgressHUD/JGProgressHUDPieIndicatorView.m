//
//  JGProgressHUDPieIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Hardtack. All rights reserved.
//

#import "JGProgressHUDPieIndicatorView.h"

@implementation JGProgressHUDPieIndicatorView

#pragma mark - Initializers

- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style {
    self = [super init];
    
    if (self) {
        if (style == JGProgressHUDStyleDark) {
            self.color = [UIColor whiteColor];
        }
        else {
            self.color = [UIColor blackColor];
        }
    }
    
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithContentView:contentView];
    
    if (self) {
        self.color = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - Getters & Setters

- (void)setColor:(UIColor *)tintColor {
    if ([tintColor isEqual:self.color]) {
        return;
    }
    
    _color = tintColor;
    
    [self setNeedsDisplay];
}

#pragma mark - Overrides

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint center = CGPointMake(rect.origin.x + floorf(rect.size.height / 2.0f), rect.origin.y + floorf(rect.size.height / 2.0f));
    CGFloat lineWidth = 2.0f;
    CGFloat radius = floorf(MIN(rect.size.width, rect.size.height) / 2.0f) -lineWidth;
    
    [self.color setStroke];
    
    //Border
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0.0f endAngle:2*M_PI clockwise:NO];
    
    [borderPath setLineWidth:lineWidth];
    [borderPath stroke];
    
    //Progress
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    
    [processPath setLineWidth:radius];
    
    CGFloat startAngle = -(M_PI / 2.0f);
    CGFloat endAngle = startAngle + 2.0f * M_PI * self.progress;
    
    [processPath addArcWithCenter:center radius:radius/2.0f startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [processPath stroke];
}

@end
