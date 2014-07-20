//
//  JGProgressHUD.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "JGProgressHUDFadeAnimation.h"
#import "JGProgressHUDIndeterminateIndicatorView.h"

#ifndef __IPHONE_8_0
#define __IPHONE_8_0 80000
#endif

#define CHECK_TRANSITIONING NSAssert(!_transitioning, @"HUD is currently transitioning")

@interface JGProgressHUD () {
    BOOL _transitioning;
    BOOL _previousUserInteractionState;
}

@end

@interface JGProgressHUDAnimation (Private)

@property (nonatomic, weak) JGProgressHUD *progressHUD;

@end

@implementation JGProgressHUD

@synthesize HUDView = _HUDView;
@synthesize textLabel = _textLabel;
@synthesize progressIndicatorView = _progressIndicatorView;
@synthesize animation = _animation;

#pragma mark - Initializers

- (instancetype)init {
    return [self initWithStyle:JGProgressHUDStyleExtraLight];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithStyle:JGProgressHUDStyleExtraLight];
}

- (instancetype)initWithStyle:(JGProgressHUDStyle)style {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _useProgressIndicatorView = YES;
        _style = style;
        
        self.hidden = YES;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //Layout
        self.contentInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        
        //Animation
        self.layoutChangeAnimationDuration = 0.3;
    }
    
    return self;
}

+ (instancetype)progressHUDWithStyle:(JGProgressHUDStyle)style {
    return [(JGProgressHUD *)[self alloc] initWithStyle:style];
}

#pragma mark - Layout

- (void)setHUDViewFrameCenterWithSize:(CGSize)size {
    CGRect frame = CGRectZero;
    
    frame.size = size;
    
    CGRect viewBounds = [self bounds];
    
    CGPoint center = CGPointMake(viewBounds.origin.x + floorf(viewBounds.size.width / 2.0f), viewBounds.origin.y + floorf(viewBounds.size.height / 2.0f));
    
    switch (self.position) {
        case JGProgressHUDPositionTopLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = self.marginInsets.top;
            break;
        case JGProgressHUDPositionTopCenter:
            frame.origin.x = center.x - floorf(frame.size.width / 2.0f);
            frame.origin.y = self.marginInsets.top;
            break;
        case JGProgressHUDPositionTopRight:
            frame.origin.x = viewBounds.size.width - self.marginInsets.right - frame.size.width;
            frame.origin.y = self.marginInsets.top;
            break;
            
        case JGProgressHUDPositionCenterLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = center.y - floorf(frame.size.height / 2.0f);
            break;
        case JGProgressHUDPositionCenter:
            frame.origin.x = center.x - floorf(frame.size.width / 2.0f);
            frame.origin.y = center.y - floorf(frame.size.height / 2.0f);
            break;
        case JGProgressHUDPositionCenterRight:
            frame.origin.x = viewBounds.size.width - self.marginInsets.right - frame.size.width;
            frame.origin.y = center.y - floorf(frame.size.height / 2.0f);
            break;
            
        case JGProgressHUDPositionBottomLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = viewBounds.size.height - self.marginInsets.bottom - frame.size.height;
            break;
        case JGProgressHUDPositionBottomCenter:
            frame.origin.x = center.x - floorf(frame.size.width / 2.0f);
            frame.origin.y = viewBounds.size.height - self.marginInsets.bottom - frame.size.height;
            break;
        case JGProgressHUDPositionBottomRight:
            frame.origin.x = viewBounds.size.width - self.marginInsets.right - frame.size.width;
            frame.origin.y = viewBounds.size.height - self.marginInsets.bottom - frame.size.height;
            break;
    }
    
    self.HUDView.frame = frame;
}

- (void)updateHUD:(BOOL)disableAnimations {
    if (!self.superview) {
        return;
    }
    
    void (^updates)(void) = ^{
        //Indicator size
        CGRect indicatorFrame = self.progressIndicatorView.frame;
        indicatorFrame.origin.y = self.contentInsets.top;
        
        //Label size
        [self.textLabel sizeToFit];
        CGRect labelFrame = self.textLabel.frame;
        labelFrame.origin.y = CGRectGetMaxY(indicatorFrame);
        
        if (!CGRectIsEmpty(labelFrame) && !CGRectIsEmpty(indicatorFrame)) {
            labelFrame.origin.y += 10.0f;
        }
        
        //HUD size
        CGSize size = CGSizeZero;
        size.width = self.contentInsets.left+MAX(indicatorFrame.size.width, labelFrame.size.width)+self.contentInsets.right;
        size.height = CGRectGetMaxY(labelFrame)+self.contentInsets.bottom;
        
        [self setHUDViewFrameCenterWithSize:size];
        
        CGPoint center = CGPointMake(floorf(size.width / 2.0f), floorf(size.height / 2.0f));
        indicatorFrame.origin.x = center.x - floorf(indicatorFrame.size.width / 2.0f);
        labelFrame.origin.x = center.x - floorf(labelFrame.size.width / 2.0f);
        
        self.progressIndicatorView.frame = indicatorFrame;
        self.textLabel.frame = labelFrame;
    };
    
    if (self.layoutChangeAnimationDuration > 0.0f && !disableAnimations && !_transitioning) {
        [UIView animateWithDuration:self.layoutChangeAnimationDuration delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:updates completion:nil];
    }
    else {
        updates();
    }
}

#pragma mark - Showing

- (void)cleanUpAfterPresentation {
    self.hidden = NO;
    
    _transitioning = NO;
    
    if ([self.delegate respondsToSelector:@selector(progressHUD:didPresentInView:)]){
        [self.delegate progressHUD:self didPresentInView:self.targetView];
    }
}

- (void)showInView:(UIView *)view {
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    [self showInRect:view.bounds inView:view animated:animated];
}

- (void)showInRect:(CGRect)rect inView:(UIView *)view {
    [self showInRect:rect inView:view animated:YES];
}

- (void)showInRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    CHECK_TRANSITIONING;
    
    _transitioning = YES;
    
    _targetView = view;
    _previousUserInteractionState = self.targetView.userInteractionEnabled;
    
    self.targetView.userInteractionEnabled = !self.userInteractionEnabled;
    
    self.frame = rect;
    [view addSubview:self];
    
    [self updateHUD:YES];
    
    if ([self.delegate respondsToSelector:@selector(progressHUD:willPresentInView:)]) {
        [self.delegate progressHUD:self willPresentInView:view];
    }
    
    if (animated && self.animation) {
        [self.animation show];
    }
    else {
        [self cleanUpAfterPresentation];
    }
}

#pragma mark - Hiding

- (void)cleanUpAfterDismissal {
    self.hidden = YES;
    [self removeFromSuperview];
    
    self.targetView.userInteractionEnabled = _previousUserInteractionState;
    
    _previousUserInteractionState = NO;
    
    _transitioning = NO;
    
    if ([self.delegate respondsToSelector:@selector(progressHUD:didDismissFromView:)]) {
        [self.delegate progressHUD:self didDismissFromView:self.targetView];
    }
    
    _targetView = nil;
}

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    CHECK_TRANSITIONING;
    
    _transitioning = YES;
    
    if ([self.delegate respondsToSelector:@selector(progressHUD:willDismissFromView:)]) {
        [self.delegate progressHUD:self willDismissFromView:self.targetView];
    }
    
    if (animated && self.animation) {
        [self.animation hide];
    }
    else {
        [self cleanUpAfterDismissal];
    }
}

- (void)dismissAfterDelay:(NSTimeInterval)delay {
    [self dismissAfterDelay:delay animated:YES];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAnimated:animated];
    });
}

#pragma mark - Animation Callback

- (void)animationDidFinish:(BOOL)presenting {
    if (presenting) {
        [self cleanUpAfterPresentation];
    }
    else {
        [self cleanUpAfterDismissal];
    }
}

#pragma mark - Getters & Setters

- (UIView *)HUDView {
    if (!_HUDView) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        if ([UIVisualEffectView class] != Nil) {
            UIBlurEffectStyle effect;
            
            if (self.style == JGProgressHUDStyleDark) {
                effect = UIBlurEffectStyleDark;
            }
            else if (self.style == JGProgressHUDStyleLight) {
                effect = UIBlurEffectStyleLight;
            }
            else {
                effect = UIBlurEffectStyleExtraLight;
            }
            
            _HUDView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
        }
        else {
            _HUDView = [[UIView alloc] init];
            
            if (self.style == JGProgressHUDStyleDark) {
                _HUDView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
            }
            else if (self.style == JGProgressHUDStyleLight) {
                _HUDView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
            }
            else {
                _HUDView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
            }
            
            _HUDView.opaque = NO;
            _HUDView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            _HUDView.layer.shouldRasterize = YES;
        }
#else
        _HUDView = [[UIView alloc] init];
        if (self.style == JGProgressHUDStyleDark) {
            _HUDView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        }
        else if (self.style == JGProgressHUDStyleLight) {
            _HUDView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
        }
        else {
            _HUDView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
        }
        
        _HUDView.opaque = NO;
        _HUDView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _HUDView.layer.shouldRasterize = YES;
#endif
        
        _HUDView.layer.cornerRadius = 10.0f;
        _HUDView.layer.masksToBounds = YES;
        
        [self addSubview:_HUDView];
    }
    
    return _HUDView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.opaque = NO;
        _textLabel.textColor = (self.style == JGProgressHUDStyleDark ? [UIColor whiteColor] : [UIColor blackColor]);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _textLabel.numberOfLines = 1;
        [_textLabel addObserver:self forKeyPath:@"text" options:kNilOptions context:NULL];
        [_textLabel addObserver:self forKeyPath:@"font" options:kNilOptions context:NULL];
        
        [self.HUDView addSubview:_textLabel];
    }
    
    return _textLabel;
}

- (void)setUseProgressIndicatorView:(BOOL)useProgressIndicatorView {
    if (useProgressIndicatorView == self.useProgressIndicatorView) {
        return;
    }
    
    _useProgressIndicatorView = useProgressIndicatorView;
    
    if (!_useProgressIndicatorView) {
        [_progressIndicatorView removeFromSuperview];
        _progressIndicatorView = nil;
    }
    
    if (self.superview) {
        [self updateHUD:NO];
    }
}

- (JGProgressHUDIndicatorView *)progressIndicatorView {
    if (!_useProgressIndicatorView) {
        return nil;
    }
    
    if (!_progressIndicatorView) {
        _progressIndicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:self.style];
        [self.HUDView addSubview:_progressIndicatorView];
    }
    
    return _progressIndicatorView;
}

- (JGProgressHUDAnimation *)animation {
    if (!_animation) {
       self.animation = [JGProgressHUDFadeAnimation animation];
    }
    
    return _animation;
}

- (void)setAnimation:(JGProgressHUDAnimation *)animation {
    _animation.progressHUD = nil;
    
    _animation = animation;
    
    _animation.progressHUD = self;
}

- (void)setPosition:(JGProgressHUDPosition)position {
    _position = position;
    [self updateHUD:NO];
}

- (void)setProgressIndicatorView:(JGProgressHUDIndicatorView *)indicatorView {
    [_progressIndicatorView removeFromSuperview];
    _progressIndicatorView = indicatorView;
    [self.HUDView addSubview:indicatorView];
    [self updateHUD:NO];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    _marginInsets = marginInsets;
    [self updateHUD:NO];
}

- (void)setContentInsets:(UIEdgeInsets)paddingInsets {
    _contentInsets = paddingInsets;
    [self updateHUD:NO];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    self.progressIndicatorView.progress = progress;
}

#pragma mark - Overrides

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.textLabel) {
        [self updateHUD:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (self.targetView) {
        self.targetView.userInteractionEnabled = !self.userInteractionEnabled;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateHUD:NO];
}

- (void)dealloc {
    [_textLabel removeObserver:self forKeyPath:@"text"];
    [_textLabel removeObserver:self forKeyPath:@"font"];
}

@end

@implementation JGProgressHUD (HUDManagement)


+ (NSArray *)allProgressHUDsInView:(UIView *)view {
    NSMutableArray *HUDs = [NSMutableArray array];
    
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[JGProgressHUD class]]) {
            [HUDs addObject:v];
        }
    }
    
    return HUDs.copy;
}


+ (NSMutableArray *)_allProgressHUDsInViewHierarchy:(UIView *)view {
    NSMutableArray *HUDs = [NSMutableArray array];
    
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[JGProgressHUD class]]) {
            [HUDs addObject:v];
        }
        else {
            [HUDs addObjectsFromArray:[self _allProgressHUDsInViewHierarchy:v]];
        }
    }
    
    return HUDs;
}

+ (NSArray *)allProgressHUDsInViewHierarchy:(UIView *)view {
    return [self _allProgressHUDsInViewHierarchy:view].copy;
}

@end