//
//  JGProgressHUD.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JGProgressHUDIndicatorView;
@class JGProgressHUDAnimation;

/**
 Positions of the HUD.
 */
typedef NS_ENUM(NSUInteger, JGProgressHUDPosition) {
    JGProgressHUDPositionCenter = 0,
    JGProgressHUDPositionTopLeft,
    JGProgressHUDPositionTopCenter,
    JGProgressHUDPositionTopRight,
    JGProgressHUDPositionCenterLeft,
    JGProgressHUDPositionCenterRight,
    JGProgressHUDPositionBottomLeft,
    JGProgressHUDPositionBottomCenter,
    JGProgressHUDPositionBottomRight
};

/**
 Appearance styles of the HUD.
 */
typedef NS_ENUM(NSUInteger, JGProgressHUDStyle) {
    JGProgressHUDStyleExtraLight = 0,
    JGProgressHUDStyleLight,
    JGProgressHUDStyleDark
};


@class JGProgressHUD;

@protocol JGProgressHUDDelegate <NSObject>

@optional

/**
 Called before the HUD will appear.
 @param view The view in which the HUD is presented.
 */
- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view;

/**
 Called after the HUD appeared.
 @param view The view in which the HUD is presented.
 */
- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view;

/**
 Called before the HUD will disappear.
 @param view The view in which the HUD is presented and will be dismissed from.
 */
- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view;

/**
 Called after the HUD has disappeared.
 @param view The view in which the HUD was presented and was be dismissed from.
 */
- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view;

@end

/**
 A HUD view to indicate progress, success, error, warnings or other notifications to the user.
 @Note Remember to call every method from the main thread! UIKit = always main thread!
 @Attention This applies only to iOS 8 and higher: You may not add JGProgressHUD to a view which has an alpha value < 1.0 or to a view which is a subview of a view with an alpha value < 1.0.
 */
@interface JGProgressHUD : UIView

/**
 Always initialize JGProgressHUD using this method or it's convenience method @c progressHUDWithStyle:.
 @param style The appearance style of the HUD.
 */
- (instancetype)initWithStyle:(JGProgressHUDStyle)style;

/**
 Convenience method to initialize a new HUD.
 @param style The appearance style of the HUD.
 */
+ (instancetype)progressHUDWithStyle:(JGProgressHUDStyle)style;

/**
 The view in which the HUD is presented.
 */
@property (nonatomic, weak, readonly) UIView *targetView;

/**
 The delegate of the HUD.
 @sa JGProgressHUDDelegate.
 */
@property (nonatomic, weak) id <JGProgressHUDDelegate> delegate;

/**
 The actual HUD visible on screen.
 */
@property (nonatomic, strong, readonly) UIView *HUDView;

/**
 The label used to present text on the HUD. set the @c text property of this label to change the displayed text. You may not change the label's @c frame or @c bounds.
 */
@property (nonatomic, strong, readonly) UILabel *textLabel;

/**
 The progress indicator view. You can assign a custom subclass of JGProgressHUDIndicatorView to this property (if you do so, you should assign it before showing the HUD).
 
 
@b Default: JGProgressHUDIndeterminateIndicatorView.
 */
@property (nonatomic, strong) JGProgressHUDIndicatorView *progressIndicatorView;

/**
 Whether the progressIndicatorView should be displayed or not.
 @attention If you change this to @c NO the current @c progressIndicatorView will be destroyed and once this property is changed to @c YES again the default @c progressIndicatorView will be used again.
 
@b Default: YES.
 */
@property (nonatomic, assign) BOOL useProgressIndicatorView;

/**
 The appearance style of the HUD.
 
@b Default: JGProgressHUDStyleExtraLight.
 */
@property (nonatomic, assign, readonly) JGProgressHUDStyle style;


/**
 If the HUD should always have the same width and height.
 
@b Default: NO.
 */
@property (nonatomic, assign) BOOL square;

/**
 Insets the contents of the HUD.
 
@b Default: (20, 20, 20, 20).
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 Insets the HUD from the frame of the hosting view or from the specified frame to present the HUD from.
 
@b Default: (20, 20, 20, 20).
 */
@property (nonatomic, assign) UIEdgeInsets marginInsets;

/**
 The position of the HUD inside the hosting view's frame, or inside the specified frame.
 
@b Default: JGProgressHUDPositionCenter
 */
@property (nonatomic, assign) JGProgressHUDPosition position;

/**
 The animation used for showing and dismissing the HUD.
 
@b Default: JGProgressHUDFadeAnimation.
 */
@property (nonatomic, strong) JGProgressHUDAnimation *animation;

/**
 The animation duration for a layout change (ex. Changing the @c text, the @c position, the @c progressIndicatorView or the @c useProgressIndicatorView property).
 
@b Default: 0.3.
 */
@property (nonatomic, assign) NSTimeInterval layoutChangeAnimationDuration;

/**
 If the HUD is visible on screen.
 */
@property (nonatomic, assign, readonly, getter = isVisible) BOOL visible;

/**
 The progress to display using the @c progressIndicatorView. A change of this property is not animated. Use the @c setProgress:animated: method for an animated progress change.
 
@b Default: 0.0.
 */
@property (nonatomic, assign) float progress;

/**
 Adjusts the current progress shown by the receiver, optionally animating the change.
 
 The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
 
 @param progress The new progress value.
 @param animated YES if the change should be animated, NO if the change should happen immediately.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;


/////////////
// Showing //
/////////////


/**
 Shows the HUD animated.
 @param view The view to show the HUD in. The frame of the @c view will be used to calculate the position of the HUD.
 */
- (void)showInView:(UIView *)view;

/**
 Shows the HUD.
 @param view The view to show the HUD in. The frame of the @c view will be used to calculate the position of the HUD.
 @param If th HUD should show with an animation.
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 Shows the HUD animated.
 @param view The view to show the HUD in.
 @param rect The rect allocated in @c view for displaying the HUD.
 */
- (void)showInRect:(CGRect)rect inView:(UIView *)view;

/**
 Shows the HUD animated.
 @param view The view to show the HUD in.
 @param rect The rect allocated in @c view for displaying the HUD.
 @param If th HUD should show with an animation.
 */
- (void)showInRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;




////////////////
// Dismissing //
////////////////



/**
 Dismisses the HUD animated.
 */
- (void)dismiss;

/**
 Dismisses the HUD.
 @param animated If the HUD should dismiss with an animation.
 */
- (void)dismissAnimated:(BOOL)animated;

/**
 Dismisses the HUD animated after a delay.
 @param delay The delay until the HUD will be dismissed.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay;

/**
 Dismisses the HUD after a delay.
 @param delay The delay until the HUD will be dismissed.
 @param animated If the HUD should dismiss with an animation.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;


@end

@interface JGProgressHUD (HUDManagement)

/**
 @param view The view to return all visible progress HUDs for.
 @return All visible progress HUDs in the view.
 */
+ (NSArray *)allProgressHUDsInView:(UIView *)view;


/**
 @param view The view to return all visible progress HUDs for.
 @return All visible progress HUDs in the view and its subviews.
 */
+ (NSArray *)allProgressHUDsInViewHierarchy:(UIView *)view;

@end
