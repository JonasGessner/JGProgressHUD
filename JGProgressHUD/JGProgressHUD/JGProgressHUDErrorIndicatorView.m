//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"jg_hud_error.png"]]];
    
    self = [super initWithContentView:imageView];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

@end
