//
//  JGProgressHUDSuccessIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDSuccessIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JGProgressHUD class]] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"]];
    
    NSString *imgPath = [resourceBundle pathForResource:@"jg_hud_success" ofType:@"png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    self = [super initWithContentView:imageView];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Success",);
}

@end
