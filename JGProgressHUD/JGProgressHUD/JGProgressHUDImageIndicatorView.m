//
//  JGProgressHUDImageIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 05.08.15.
//  Copyright (c) 2015 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDImageIndicatorView.h"

@implementation JGProgressHUDImageIndicatorView

- (instancetype)initWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self = [super initWithContentView:imageView];
    
    return self;
}

@end
