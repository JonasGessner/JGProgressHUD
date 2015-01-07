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

#ifndef iPad
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#ifndef NSFoundationVersionNumber_iOS_7_0
#define NSFoundationVersionNumber_iOS_7_0 1047.20
#endif

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_iOS_8_0 1134.10
#endif

#ifndef iOS7
#define iOS7 (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
#endif

#ifndef iOS8
#define iOS8 (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0)
#endif

@interface JGProgressHUD () {
    BOOL _transitioning;
    BOOL _updateAfterAppear;
    
    BOOL _dismissAfterTransitionFinished;
    BOOL _dismissAfterTransitionFinishedWithAnimation;
    
    JGProgressHUDIndicatorView *_indicatorViewAfterTransitioning;
}

@end

@interface JGProgressHUDAnimation (Private)

@property (nonatomic, weak) JGProgressHUD *progressHUD;

@end

@implementation JGProgressHUD

@synthesize HUDView = _HUDView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize indicatorView = _indicatorView;
@synthesize animation = _animation;

@dynamic visible, contentView;

#pragma mark - Keyboard

static CGRect keyboardFrame = (CGRect){{0.0f, 0.0f}, {0.0f, 0.0f}};

+ (void)keyboardFrameWillChange:(NSNotification *)notification {
    keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (CGRectIsEmpty(keyboardFrame)) {
        keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    }
}

+ (void)keyboardFrameDidChange:(NSNotification *)notification {
    keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

+ (CGRect)currentKeyboardFrame {
    return keyboardFrame;
}

+ (void)load {
    [super load];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark - Initializers

- (instancetype)init {
    return [self initWithStyle:JGProgressHUDStyleExtraLight];
}

- (instancetype)initWithFrame:(CGRect __unused)frame {
    return [self initWithStyle:JGProgressHUDStyleExtraLight];
}

- (instancetype)initWithStyle:(JGProgressHUDStyle)style {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _style = style;
        
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        self.marginInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
        
        self.layoutChangeAnimationDuration = 0.3;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
        
        _indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:self.style];
        
        _cornerRadius = 10.0f;
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
    
    self.HUDView.frame = frame;
}

- (void)updateHUDAnimated:(BOOL)animated animateIndicatorViewFrame:(BOOL)animateIndicator {
    if (_transitioning) {
        _updateAfterAppear = YES;
        return;
    }
    
    if (!self.superview) {
        return;
    }
    
    CGRect indicatorFrame = self.indicatorView.frame;
    indicatorFrame.origin.y = self.contentInsets.top;
    
    CGFloat maxContentWidth = self.frame.size.width-self.marginInsets.left-self.marginInsets.right-self.contentInsets.left-self.contentInsets.right;
    CGFloat maxContentHeight = self.frame.size.height-self.marginInsets.top-self.marginInsets.bottom-self.contentInsets.top-self.contentInsets.bottom;
    
    CGSize maxContentSize = (CGSize){maxContentWidth, maxContentHeight};
    
    //Label size
    CGRect labelFrame = CGRectZero;
    CGRect detailFrame = CGRectZero;
    
    if (_textLabel) {
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
    }
    
    if (_detailTextLabel) {
        if (iOS7) {
            NSDictionary *attributes = @{NSFontAttributeName : self.detailTextLabel.font};
            detailFrame.size = [self.detailTextLabel.text boundingRectWithSize:maxContentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }
        else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            detailFrame.size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:maxContentSize lineBreakMode:self.detailTextLabel.lineBreakMode];
#pragma clang diagnostic pop
        }
        
        detailFrame.origin.y = CGRectGetMaxY(labelFrame)+5.0f;
        
        if (!CGRectIsEmpty(detailFrame) && !CGRectIsEmpty(indicatorFrame) && CGRectIsEmpty(labelFrame)) {
            detailFrame.origin.y += 5.0f;
        }
    }
    
    //HUD size
    CGSize size = CGSizeZero;
    
    CGFloat width = MIN(self.contentInsets.left+MAX(indicatorFrame.size.width, MAX(labelFrame.size.width, detailFrame.size.width))+self.contentInsets.right, self.frame.size.width-self.marginInsets.left-self.marginInsets.right);
    
    CGFloat height = MAX(CGRectGetMaxY(labelFrame), MAX(CGRectGetMaxY(detailFrame), CGRectGetMaxY(indicatorFrame)))+self.contentInsets.bottom;
    
    if (self.square) {
        CGFloat uniSize = MAX(width, height);
        
        size.width = uniSize;
        size.height = uniSize;
        
        CGFloat heightDelta = (uniSize-height)/2.0f;
        
        labelFrame.origin.y += heightDelta;
        detailFrame.origin.y += heightDelta;
        indicatorFrame.origin.y += heightDelta;
    }
    else {
        size.width = width;
        size.height = height;
    }
    
    CGPoint center = CGPointMake(size.width/2.0f, size.height/2.0f);
    
    indicatorFrame.origin.x = center.x-indicatorFrame.size.width/2.0f;
    labelFrame.origin.x = center.x-labelFrame.size.width/2.0f;
    detailFrame.origin.x = center.x-detailFrame.size.width/2.0f;
    
    void (^updates)(void) = ^{
        [self setHUDViewFrameCenterWithSize:size];
        
        if (animateIndicator) {
            self.indicatorView.frame = indicatorFrame;
        }
        
        _textLabel.frame = labelFrame;
        _detailTextLabel.frame = detailFrame;
    };
    
    if (!animateIndicator) {
        self.indicatorView.frame = indicatorFrame;
    }
    
    if (self.layoutChangeAnimationDuration > 0.0f && animated && !_transitioning) {
        [UIView animateWithDuration:self.layoutChangeAnimationDuration delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut animations:updates completion:nil];
    }
    else {
        updates();
    }
}

- (CGRect)fullFrameInView:(UIView *)view {
    CGRect _keyboardFrame = [view convertRect:[[self class] currentKeyboardFrame] fromView:nil];
    CGRect frame = view.bounds;
    
    if (!CGRectIsEmpty(_keyboardFrame) && CGRectIntersectsRect(frame, _keyboardFrame)) {
        frame.size.height = MIN(frame.size.height, CGRectGetMinY(_keyboardFrame));
    }
    
    return frame;
}

- (void)applyCornerRadius {
    self.HUDView.layer.cornerRadius = self.cornerRadius;
    if (iOS8) {
        for (UIView *sub in self.HUDView.subviews) {
            sub.layer.cornerRadius = self.cornerRadius;
        }
    };
}

#pragma mark - Showing

- (void)cleanUpAfterPresentation {
    self.hidden = NO;
    
    _transitioning = NO;
    
    if (_indicatorViewAfterTransitioning) {
        self.indicatorView = _indicatorViewAfterTransitioning;
        _indicatorViewAfterTransitioning = nil;
        _updateAfterAppear = NO;
    }
    else if (_updateAfterAppear) {
        [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
        _updateAfterAppear = NO;
    }
    
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
    CGRect frame = [self fullFrameInView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [self showInRect:frame inView:view animated:animated];
}

- (void)showInRect:(CGRect)rect inView:(UIView *)view {
    [self showInRect:rect inView:view animated:YES];
}

- (void)showInRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    if (_transitioning) {
        return;
    }
    else if (self.targetView != nil) {
#if DEBUG
        NSLog(@"[Warning] The HUD is already visible! Ignoring.");
#endif
        return;
    }
    
    _targetView = view;
    
    self.frame = rect;
    [view addSubview:self];
    
    [self updateHUDAnimated:NO animateIndicatorViewFrame:YES];
    
    _transitioning = YES;
    
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
    
    [self removeObservers];
    
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
    
    if (self.targetView == nil) {
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

#pragma mark - Callbacks

- (void)tapped:(UITapGestureRecognizer *)t {
    if (CGRectContainsPoint(self.contentView.bounds, [t locationInView:self.contentView])) {
        if (self.tapOnHUDViewBlock) {
            self.tapOnHUDViewBlock(self);
        }
    }
    else if (self.tapOutsideBlock) {
        self.tapOutsideBlock(self);
    }
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
    CGRect frame = [self fullFrameInView:self.targetView];
    
    if (CGRectEqualToRect(self.frame, frame)) {
        return;
    }
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView beginAnimations:@"de.j-gessner.jgprogresshud.keyboardframechange" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    
    self.frame = frame;
    [self updateHUDAnimated:NO animateIndicatorViewFrame:YES];
    
    [UIView commitAnimations];
}

- (void)orientationChanged {
    if (self.targetView && !CGRectEqualToRect(self.bounds, self.targetView.bounds)) {
        [UIView animateWithDuration:(iPad ? 0.4 : 0.3) delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = [self fullFrameInView:self.targetView];
            [self updateHUDAnimated:NO animateIndicatorViewFrame:YES];
        } completion:nil];
    }
}

- (void)animationDidFinish:(BOOL)presenting {
    if (presenting) {
        [self cleanUpAfterPresentation];
    }
    else {
        [self cleanUpAfterDismissal];
    }
}

#pragma mark - Getters

- (BOOL)isVisible {
    return (self.superview != nil);
}

- (UIView *)HUDView {
    if (!_HUDView) {
        if (iOS8) {
            UIBlurEffectStyle effect = 0;
            
            if (self.style == JGProgressHUDStyleDark) {
                effect = UIBlurEffectStyleDark;
            }
            else if (self.style == JGProgressHUDStyleLight) {
                effect = UIBlurEffectStyleLight;
            }
            else {
                effect = UIBlurEffectStyleExtraLight;
            }
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:effect];
            
            _HUDView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
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
        }
        
        if (iOS7) {
            UIInterpolatingMotionEffect *x = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            
            CGFloat maxMovement = 20.0f;
            
            x.minimumRelativeValue = @(-maxMovement);
            x.maximumRelativeValue = @(maxMovement);
            
            UIInterpolatingMotionEffect *y = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            
            y.minimumRelativeValue = @(-maxMovement);
            y.maximumRelativeValue = @(maxMovement);
            
            _HUDView.motionEffects = @[x, y];
        }
        
        [self applyCornerRadius];
        
        [self addSubview:_HUDView];
        
        if (self.indicatorView) {
            [self.contentView addSubview:self.indicatorView];
        }
        
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
    }
    
    return _HUDView;
}

- (UIView *)contentView {
    if (iOS8) {
        return ((UIVisualEffectView *)self.HUDView).contentView;
    }
    else {
        return self.HUDView;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = (self.style == JGProgressHUDStyleDark ? [UIColor whiteColor] : [UIColor blackColor]);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _textLabel.numberOfLines = 0;
        [_textLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptions)kNilOptions context:NULL];
        [_textLabel addObserver:self forKeyPath:@"font" options:(NSKeyValueObservingOptions)kNilOptions context:NULL];
        
        [self.contentView addSubview:_textLabel];
    }
    
    return _textLabel;
}

- (UILabel *)detailTextLabel {
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        _detailTextLabel.textColor = (self.style == JGProgressHUDStyleDark ? [UIColor whiteColor] : [UIColor blackColor]);
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        _detailTextLabel.numberOfLines = 0;
        [_detailTextLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptions)kNilOptions context:NULL];
        [_detailTextLabel addObserver:self forKeyPath:@"font" options:(NSKeyValueObservingOptions)kNilOptions context:NULL];
        
        [self.contentView addSubview:_detailTextLabel];
    }
    
    return _detailTextLabel;
}

- (JGProgressHUDAnimation *)animation {
    if (!_animation) {
        self.animation = [JGProgressHUDFadeAnimation animation];
    }
    
    return _animation;
}

#pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (fequal(self.cornerRadius, cornerRadius)) {
        return;
    }
    
    _cornerRadius = cornerRadius;
    
    [self applyCornerRadius];
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
    [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
}

- (void)setSquare:(BOOL)square {
    if (self.square == square) {
        return;
    }
    
    _square = square;
    
    [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
}

- (void)setIndicatorView:(JGProgressHUDIndicatorView *)indicatorView {
    if (self.indicatorView == indicatorView) {
        return;
    }
    
    if (_transitioning) {
        _indicatorViewAfterTransitioning = indicatorView;
        return;
    }
    
    [_indicatorView removeFromSuperview];
    _indicatorView = indicatorView;
    
    if (self.indicatorView) {
        [self.contentView addSubview:self.indicatorView];
    }
    
    [self updateHUDAnimated:YES animateIndicatorViewFrame:NO];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.marginInsets, marginInsets)) {
        return;
    }
    
    _marginInsets = marginInsets;
    
    [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentInsets, contentInsets)) {
        return;
    }
    
    _contentInsets = contentInsets;
    
    [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (fequal(self.progress, progress)) {
        return;
    }
    
    _progress = progress;
    
    [self.indicatorView setProgress:progress animated:animated];
}

#pragma mark - Overrides

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.interactionType == JGProgressHUDInteractionTypeBlockNoTouches) {
        return nil;
    }
    else {
        UIView *view = [super hitTest:point withEvent:event];
        
        if (self.interactionType == JGProgressHUDInteractionTypeBlockAllTouches) {
            return view;
        }
        else if (self.interactionType == JGProgressHUDInteractionTypeBlockTouchesOnHUDView && view != self) {
            return view;
        }
        
        return nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _textLabel || object == _detailTextLabel) {
        [self updateHUDAnimated:YES animateIndicatorViewFrame:YES];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self removeObservers];
    
    [_textLabel removeObserver:self forKeyPath:@"text"];
    [_textLabel removeObserver:self forKeyPath:@"font"];
    
    [_detailTextLabel removeObserver:self forKeyPath:@"text"];
    [_detailTextLabel removeObserver:self forKeyPath:@"font"];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
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


@implementation JGProgressHUD (Deprecated)

@dynamic progressIndicatorView, useProgressIndicatorView;

- (void)setProgressIndicatorView:(JGProgressHUDIndicatorView *)progressIndicatorView {
    [self setIndicatorView:progressIndicatorView];
}

- (JGProgressHUDIndicatorView *)progressIndicatorView {
    return [self indicatorView];
}

@end
