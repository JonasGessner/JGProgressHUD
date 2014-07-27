//
//  JGProgressHUDRingIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDRingIndicatorView.h"


@interface JGProgressHUDRingIndicatorLayer : CALayer

@property (nonatomic, assign) float progress;

@property (nonatomic, weak) UIColor *ringColor;
@property (nonatomic, weak) UIColor *ringBackgroundColor;

@property (nonatomic, assign) BOOL roundProgressLine;

@property (nonatomic, assign) CGFloat ringWidth;

@end

@implementation JGProgressHUDRingIndicatorLayer

@dynamic progress, ringBackgroundColor, ringColor, ringWidth, roundProgressLine;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return ([key isEqualToString:@"progress"] || [key isEqualToString:@"ringColor"] || [key isEqualToString:@"ringBackgroundColor"] || [key isEqualToString:@"roundProgressLine"] || [key isEqualToString:@"ringWidth"] || [super needsDisplayForKey:key]);
}

- (id <CAAction>)actionForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        CABasicAnimation *progressAnimation = [CABasicAnimation animation];
        progressAnimation.fromValue = [self.presentationLayer valueForKey:key];
        
        progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        return progressAnimation;
    }
    
    return [super actionForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    
    CGRect rect = self.bounds;
    
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


@implementation JGProgressHUDRingIndicatorView

#pragma mark - Initializers

- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style {
    self = [super init];
    
    if (self) {
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer setNeedsDisplay];
        
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
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer setNeedsDisplay];
        
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
    
    [(JGProgressHUDRingIndicatorLayer *)self.layer setRoundProgressLine:self.roundProgressLine];
}

- (void)setRingColor:(UIColor *)tintColor {
    if ([tintColor isEqual:self.ringColor]) {
        return;
    }
    
    _ringColor = tintColor;
    
    [(JGProgressHUDRingIndicatorLayer *)self.layer setRingColor:self.ringColor];
}

- (void)setRingBackgroundColor:(UIColor *)backgroundTintColor {
    if ([backgroundTintColor isEqual:self.ringBackgroundColor]) {
        return;
    }
    
    _ringBackgroundColor = backgroundTintColor;
    
    [(JGProgressHUDRingIndicatorLayer *)self.layer setRingBackgroundColor:self.ringBackgroundColor];
}

- (void)setRingWidth:(CGFloat)ringWidth {
    if (ringWidth == self.ringWidth) {
        return;
    }
    
    _ringWidth = ringWidth;
    
    [(JGProgressHUDRingIndicatorLayer *)self.layer setRingWidth:self.ringWidth];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (self.progress == progress) {
        return;
    }
    
    [super setProgress:progress animated:animated];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:(animated ? 0.3 : 0.0)];
    [(JGProgressHUDRingIndicatorLayer *)self.layer setProgress:self.progress];
    [CATransaction commit];
}

#pragma mark - Overrides

+ (Class)layerClass {
    return [JGProgressHUDRingIndicatorLayer class];
}

@end
