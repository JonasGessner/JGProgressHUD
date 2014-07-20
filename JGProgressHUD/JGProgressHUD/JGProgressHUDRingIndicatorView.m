//
//  JGProgressHUDRingIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDRingIndicatorView.h"

@implementation JGProgressHUDRingIndicatorView

#pragma mark - Initializers

- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style {
    self = [super init];
    
    if (self) {
        if (style == JGProgressHUDStyleDark) {
            self.ringColor = [UIColor whiteColor];
            self.ringBackgroundColor = [UIColor blackColor];
        }
        else {
            self.ringColor = [UIColor blackColor];
            self.ringBackgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        }
    }
    
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithContentView:contentView];
    
    if (self) {
        self.ringColor = [UIColor whiteColor];
        self.ringBackgroundColor = [UIColor blackColor];
        self.ringWidth = 5.0f;
    }
    
    return self;
}

#pragma mark - Getters & Setters

- (void)setRoundProgressLine:(BOOL)roundProgressLine {
    if (roundProgressLine == self.roundProgressLine) {
        return;
    }
    
    _roundProgressLine = roundProgressLine;
    
    [self setNeedsDisplay];
}

- (void)setRingColor:(UIColor *)tintColor {
    if ([tintColor isEqual:self.ringColor]) {
        return;
    }
    
    _ringColor = tintColor;
    
    [self setNeedsDisplay];
}

- (void)setRingBackgroundColor:(UIColor *)backgroundTintColor {
    if ([backgroundTintColor isEqual:self.ringBackgroundColor]) {
        return;
    }
    
    _ringBackgroundColor = backgroundTintColor;
    
    [self setNeedsDisplay];
}

- (void)setRingWidth:(CGFloat)ringWidth {
    if (ringWidth == self.ringWidth) {
        return;
    }
    
    _ringWidth = ringWidth;
    
    [self setNeedsDisplay];
}

#pragma mark - Overrides

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint center = CGPointMake(rect.origin.x + floorf(rect.size.height / 2.0f), rect.origin.y + floorf(rect.size.height / 2.0f));
    CGFloat lineWidth = self.ringWidth;
    CGFloat radius = floorf(MIN(rect.size.width, rect.size.height) / 2.0f) - lineWidth;
    
    //Background
    [self.ringBackgroundColor setStroke];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0.0f endAngle:2*M_PI clockwise:NO];
    
    [borderPath setLineWidth:lineWidth];
    [borderPath stroke];
    
    //Progress
    [self.ringColor setStroke];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    
    [processPath setLineWidth:lineWidth];
    [borderPath setLineCapStyle:(self.roundProgressLine ? kCGLineCapRound : kCGLineCapSquare)];
    
    CGFloat startAngle = -(M_PI / 2.0f);
    CGFloat endAngle = startAngle + 2.0f * M_PI * self.progress;
    
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [processPath stroke];
}

@end
