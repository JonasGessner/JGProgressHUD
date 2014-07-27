//
//  JGProgressHUDPieIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.07.14.
//  Copyright (c) 2014 Hardtack. All rights reserved.
//

#import "JGProgressHUDPieIndicatorView.h"

@interface JGProgressHUDPieIndicatorLayer : CALayer

@property (nonatomic, assign) float progress;

@property (nonatomic, weak) UIColor *color;

@end

@implementation JGProgressHUDPieIndicatorLayer

@dynamic progress, color;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return ([key isEqualToString:@"progress"] || [key isEqualToString:@"color"] || [super needsDisplayForKey:key]);
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
    
    UIGraphicsPopContext();
}

@end


@implementation JGProgressHUDPieIndicatorView

#pragma mark - Initializers

- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style {
    self = [super init];
    
    if (self) {
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer setNeedsDisplay];
        
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
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer setNeedsDisplay];
        
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
    
    [(JGProgressHUDPieIndicatorLayer *)self.layer setColor:self.color];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (self.progress == progress) {
        return;
    }
    
    [super setProgress:progress animated:animated];
    
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:(animated ? 0.3 : 0.0)];
    
    [(JGProgressHUDPieIndicatorLayer *)self.layer setProgress:progress];
    
    [CATransaction commit];
}

#pragma mark - Overrides

+ (Class)layerClass {
    return [JGProgressHUDPieIndicatorLayer class];
}

@end
