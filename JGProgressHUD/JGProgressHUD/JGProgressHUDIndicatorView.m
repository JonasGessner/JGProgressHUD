//
//  JGProgressHUDIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDIndicatorView.h"
#import "JGProgressHUD.h"

@interface JGProgressHUDIndicatorView () {
    BOOL _accessibilityUpdateScheduled;
}

+ (void)runBlock:(void (^)(void))block;

@end

NS_INLINE void runOnNextRunLoop(void (^block)(void)) {
    [[NSRunLoop currentRunLoop] performSelector:@selector(runBlock:) target:[JGProgressHUDIndicatorView class] argument:(id)block order:0 modes:@[NSRunLoopCommonModes]];
}

@implementation JGProgressHUDIndicatorView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect __unused)frame {
    return [self init];
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:(contentView ? contentView.frame : CGRectMake(0.0f, 0.0f, 50.0f, 50.0f))];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.isAccessibilityElement = YES;
        [self setNeedsAccessibilityUpdate];
        
        if (contentView) {
            _contentView = contentView;
            
            [self addSubview:self.contentView];
        }
    }
    return self;
}

#pragma mark - Accessibility

+ (void)runBlock:(void (^)(void))block {
    if (block != nil) {
        block();
    }
}

- (void)setNeedsAccessibilityUpdate {
    if (!_accessibilityUpdateScheduled) {
        _accessibilityUpdateScheduled = YES;
        
        runOnNextRunLoop(^{
            [self updateAccessibilityIfNeeded];
        });
    }
}

- (void)updateAccessibilityIfNeeded {
    if (_accessibilityUpdateScheduled) {
        [self updateAccessibility];
        _accessibilityUpdateScheduled = NO;
    }
}

- (void)updateAccessibility {
    self.accessibilityLabel = [NSLocalizedString(@"Loading",) stringByAppendingFormat:@" %.f %%", self.progress];
}

#pragma mark - Getters & Setters

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (fequal(self.progress, progress)) {
        return;
    }
    
    _progress = progress;
    
    [self setNeedsAccessibilityUpdate];
}

@end
