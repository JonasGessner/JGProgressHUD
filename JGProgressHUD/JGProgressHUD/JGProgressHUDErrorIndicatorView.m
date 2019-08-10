//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceBundleURL = [currentBundle URLForResource:@"JGProgressHUD" withExtension:@"bundle"];
    NSBundle *resourceBundle = currentBundle;
    if (resourceBundleURL) {
        resourceBundle = [NSBundle bundleWithURL:resourceBundleURL] ?: currentBundle;
    }

    NSString *imgPath = [resourceBundle pathForResource:@"jg_hud_error" ofType:@"png"];
    self = [super initWithImage:[[UIImage imageWithContentsOfFile:imgPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

@end
