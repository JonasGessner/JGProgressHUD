//
//  JGProgressHUDIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 You may subclass this class to create a custom progress indicator view.
 */
@interface JGProgressHUDIndicatorView : UIView

/**
 Ranges from 0.0 to 1.0.
 */
@property (nonatomic) float progress;

/**
 Designated initializer for this class.
 @param contentView The content view to place on the container view (the container is the JGProgressHUDIndicatorView).
 */
- (instancetype)initWithContentView:(UIView *)contentView;

/**
 The content view which displays the progress.
 */
@property (nonatomic, strong, readonly) UIView *contentView;

@end
