//
//  JGProgressHUD-Defines.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 28.04.15.
//  Copyright (c) 2015 Jonas Gessner. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Positions of the HUD.
 */
typedef NS_ENUM(NSUInteger, JGProgressHUDPosition) {
    /** Center position. */
    JGProgressHUDPositionCenter = 0,
    /** Top left position. */
    JGProgressHUDPositionTopLeft,
    /** Top center position. */
    JGProgressHUDPositionTopCenter,
    /** Top right position. */
    JGProgressHUDPositionTopRight,
    /** Center left position. */
    JGProgressHUDPositionCenterLeft,
    /** Center right position. */
    JGProgressHUDPositionCenterRight,
    /** Bottom left position. */
    JGProgressHUDPositionBottomLeft,
    /** Bottom center position. */
    JGProgressHUDPositionBottomCenter,
    /** Bottom right position. */
    JGProgressHUDPositionBottomRight
};

/**
 Appearance styles of the HUD.
 */
typedef NS_ENUM(NSUInteger, JGProgressHUDStyle) {
    /** Extra light HUD with dark elements. */
    JGProgressHUDStyleExtraLight = 0,
    /** Light HUD with dark elemets. */
    JGProgressHUDStyleLight,
    /** Dark HUD with light elements. */
    JGProgressHUDStyleDark
};

/**
 Interaction types.
 */
typedef NS_ENUM(NSUInteger, JGProgressHUDInteractionType) {
    /** Block all touches. No interaction behin the HUD is possible. */
    JGProgressHUDInteractionTypeBlockAllTouches = 0,
    /** Block touches on the HUD view. */
    JGProgressHUDInteractionTypeBlockTouchesOnHUDView,
    /** Block no touches. */
    JGProgressHUDInteractionTypeBlockNoTouches
};

/**
 Macro for safe floating point comparison (for internal use in JGProgressHUD).
 */
#ifndef fequal
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#endif
