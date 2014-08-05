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

#if !__has_feature(objc_arc)
#error "JGProgressHUD requires ARC!"
#endif

#ifndef __IPHONE_8_0
#define __IPHONE_8_0 80000
#endif

#define kBaseSDKiOS8 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)

#if kBaseSDKiOS8
#define iOS8ex(available, unavailable) \
if (iOS8) { \
available \
} \
else { \
unavailable \
}
#else
#define iOS8ex(available, unavailable) \
unavailable
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.00
#endif

#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)

#define iOS8 ([UIVisualEffectView class] != Nil)

#define CHECK_TRANSITIONING NSAssert(!_transitioning, @"HUD is currently transitioning")

@interface JGProgressHUD () {
    BOOL _transitioning;
    BOOL _dismissAfterTransitionFinished;
    BOOL _dismissAfterTransitionFinishedWithAnimation;
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

@dynamic visible;

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
        
        self.contentInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        self.marginInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        
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
    
    CGRect viewBounds = self.bounds;
    
    CGPoint center = CGPointMake(viewBounds.origin.x+viewBounds.size.width/2.0f, viewBounds.origin.y+viewBounds.size.height/2.0f);
    
    switch (self.position) {
        case JGProgressHUDPositionTopLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = self.marginInsets.top;
            break;
        case JGProgressHUDPositionTopCenter:
            frame.origin.x = center.x-frame.size.width/2.0f;
            frame.origin.y = self.marginInsets.top;
            break;
        case JGProgressHUDPositionTopRight:
            frame.origin.x = viewBounds.size.width-self.marginInsets.right-frame.size.width;
            frame.origin.y = self.marginInsets.top;
            break;
            
        case JGProgressHUDPositionCenterLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = center.y-frame.size.height/2.0f;
            break;
        case JGProgressHUDPositionCenter:
            frame.origin.x = center.x-frame.size.width/2.0f;
            frame.origin.y = center.y-frame.size.height/2.0f;
            break;
        case JGProgressHUDPositionCenterRight:
            frame.origin.x = viewBounds.size.width-self.marginInsets.right-frame.size.width;
            frame.origin.y = center.y-frame.size.height/2.0f;
            break;
            
        case JGProgressHUDPositionBottomLeft:
            frame.origin.x = self.marginInsets.left;
            frame.origin.y = viewBounds.size.height-self.marginInsets.bottom-frame.size.height;
            break;
        case JGProgressHUDPositionBottomCenter:
            frame.origin.x = center.x-frame.size.width/2.0f;
            frame.origin.y = viewBounds.size.height-self.marginInsets.bottom-frame.size.height;
            break;
        case JGProgressHUDPositionBottomRight:
            frame.origin.x = viewBounds.size.width-self.marginInsets.right-frame.size.width;
            frame.origin.y = viewBounds.size.height-self.marginInsets.bottom-frame.size.height;
            break;
    }
    
    _HUDView.frame = frame;
}

- (void)updateHUD:(BOOL)disableAnimations {
    if (!self.superview) {
        return;
    }
    
    void (^updates)(void) = ^{
        //Indicator size
        CGRect indicatorFrame = self.progressIndicatorView.frame;
        indicatorFrame.origin.y = self.contentInsets.top;
        
        CGFloat maxContentWidth = self.frame.size.width-self.marginInsets.left-self.marginInsets.right-self.contentInsets.left-self.contentInsets.right;
        CGFloat maxContentHeight = self.frame.size.height-self.marginInsets.top-self.marginInsets.bottom-self.contentInsets.top-self.contentInsets.bottom;
        
        CGSize maxContentSize = (CGSize){maxContentWidth, maxContentHeight};
        
        //Label size
        CGRect labelFrame = CGRectZero;
        
        if (iOS7) {
            NSDictionary *attributes = @{NSFontAttributeName : self.textLabel.font};
            labelFrame.size = [self.textLabel.text boundingRectWithSize:maxContentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            labelFrame.size = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:maxContentSize lineBreakMode:self.textLabel.lineBreakMode];
#pragma clang diagnostic pop
        }
        
        labelFrame.origin.y = CGRectGetMaxY(indicatorFrame);
        
        if (!CGRectIsEmpty(labelFrame) && !CGRectIsEmpty(indicatorFrame)) {
            labelFrame.origin.y += 10.0f;
        }
        
        //HUD size
        CGSize size = CGSizeZero;
        
        CGFloat width = MIN(self.contentInsets.left+MAX(indicatorFrame.size.width, labelFrame.size.width)+self.contentInsets.right, self.frame.size.width-self.marginInsets.left-self.marginInsets.right);
        
        CGFloat height = CGRectGetMaxY(labelFrame)+self.contentInsets.bottom;
        
        if (self.square) {
            CGFloat uniSize = MAX(width, height);
            
            size.width = uniSize;
            size.height = uniSize;
            
            CGFloat heightDelta = uniSize-height;
            
            labelFrame.origin.y += heightDelta/2.0f;
            indicatorFrame.origin.y += heightDelta/2.0f;
        }
        else {
            size.width = width;
            size.height = height;
        }
        
        CGPoint center = CGPointMake(size.width/2.0f, size.height/2.0f);
        
        indicatorFrame.origin.x = center.x-indicatorFrame.size.width/2.0f;
        labelFrame.origin.x = center.x-labelFrame.size.width/2.0f;
        
        
        [self setHUDViewFrameCenterWithSize:size];
        
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
    
    if (_dismissAfterTransitionFinished) {
        [self dismissAnimated:_dismissAfterTransitionFinishedWithAnimation];
        _dismissAfterTransitionFinished = NO;
        _dismissAfterTransitionFinishedWithAnimation = NO;
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
    _dismissAfterTransitionFinished = NO;
    _dismissAfterTransitionFinishedWithAnimation = NO;
    
    if ([self.delegate respondsToSelector:@selector(progressHUD:didDismissFromView:)]) {
        [self.delegate progressHUD:self didDismissFromView:self.targetView];
    }
    
    _targetView = nil;
}

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    if (_transitioning) {
        _dismissAfterTransitionFinished = YES;
        _dismissAfterTransitionFinishedWithAnimation = animated;
        return;
    }
    
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
    __weak __typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.visible) {
                [strongSelf dismissAnimated:animated];
            }
        }
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

- (BOOL)isVisible {
    return (self.superview != nil);
}

- (UIView *)HUDView {
    if (!_HUDView) {
        iOS8ex(
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
               ,
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
               );
        
        _HUDView.layer.cornerRadius = 10.0f;
        _HUDView.layer.masksToBounds = YES;
        
        [self addSubview:_HUDView];
    }
    
    iOS8ex(return ((UIVisualEffectView *)_HUDView).contentView;, return _HUDView;);
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.opaque = NO;
        _textLabel.textColor = (self.style == JGProgressHUDStyleDark ? [UIColor whiteColor] : [UIColor blackColor]);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _textLabel.numberOfLines = 0;
        [_textLabel addObserver:self forKeyPath:@"text" options:kNilOptions context:NULL];
        [_textLabel addObserver:self forKeyPath:@"font" options:kNilOptions context:NULL];
        
        [self.HUDView addSubview:_textLabel];
    }
    
    return _textLabel;
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

- (void)setAnimation:(JGProgressHUDAnimation *)animation {
    if (_animation == animation) {
        return;
    }
    
    _animation.progressHUD = nil;
    
    _animation = animation;
    
    _animation.progressHUD = self;
}

- (void)setPosition:(JGProgressHUDPosition)position {
    if (self.position == position) {
        return;
    }
    
    _position = position;
    [self updateHUD:NO];
}

- (void)setSquare:(BOOL)square {
    if (self.square == square) {
        return;
    }
    
    _square = square;
    
    [self updateHUD:NO];
}

- (void)setProgressIndicatorView:(JGProgressHUDIndicatorView *)indicatorView {
    if (self.progressIndicatorView == indicatorView) {
        return;
    }
    
    [_progressIndicatorView removeFromSuperview];
    _progressIndicatorView = indicatorView;
    
    [self.HUDView addSubview:indicatorView];
    
    [self updateHUD:NO];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.marginInsets, marginInsets)) {
        return;
    }
    
    _marginInsets = marginInsets;
    
    [self updateHUD:NO];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentInsets, contentInsets)) {
        return;
    }
    
    _contentInsets = contentInsets;
    
    [self updateHUD:NO];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (self.progress == progress) {
        return;
    }
    
    _progress = progress;
    
    [self.progressIndicatorView setProgress:progress animated:animated];
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