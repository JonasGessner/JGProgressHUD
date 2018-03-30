//
//  JGProgressHUDShadow.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 25.09.17.
//  Copyright © 2017 Jonas Gessner. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A wrapper representing properties of a shadow.
 */
@interface JGProgressHUDShadow : NSObject

- (instancetype __nonnull)initWithColor:(UIColor *__nonnull)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(float)opacity;

/** Convenience initializer. */
+ (instancetype __nonnull)shadowWithColor:(UIColor *__nonnull)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(float)opacity;

/**
 The color of the shadow. Colors created from patterns are currently NOT supported.
 */
@property (nonatomic, strong, readonly, nonnull) UIColor *color;

/** The shadow offset. */
@property (nonatomic, assign, readonly) CGSize offset;

/** The blur radius used to create the shadow. */
@property (nonatomic, assign, readonly) CGFloat radius;

/**
 The opacity of the shadow. Specifying a value outside the  [0,1] range will give undefined results.
 */
@property (nonatomic, assign, readonly) float opacity;

@end
