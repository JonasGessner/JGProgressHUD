//
//  JGProgressHUD.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUD-Defines.h"
#import "JGProgressHUDShadow.h"
#import "JGProgressHUDAnimation.h"
#import "JGProgressHUDFadeAnimation.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDIndeterminateIndicatorView.h"

@protocol JGProgressHUDDelegate;

/**
 A HUD to indicate progress, success, error, warnings or other notifications to the user.
@discussion @c JGProgressHUD respects its @c layoutMargins when positioning the HUD view. Additionally, on iOS 11 if @c insetsLayoutMarginsFromSafeArea is set to @c YES (default) the @c layoutMargins additionally contain the @c safeAreaInsets.
 @note Remember to call every method from the main thread! UIKit => main thread!
 @attention You may not add JGProgressHUD to a view which has an alpha value < 1.0 or to a view which is a subview of a view with an alpha value < 1.0.
 */
@interface JGProgressHUD : UIView

/**
 Designated initializer.
 @param style The appearance style of the HUD.
 */
- (instancetype __nonnull)initWithStyle:(JGProgressHUDStyle)style;

/**
 Convenience initializer.
 @param style The appearance style of the HUD.
 */
+ (instancetype __nonnull)progressHUDWithStyle:(JGProgressHUDStyle)style;

/**
 The appearance style of the HUD.
 @b Default: JGProgressHUDStyleExtraLight.
 */
@property (nonatomic, assign, readonly) JGProgressHUDStyle style;

/** The view in which the HUD is presented. */
@property (nonatomic, weak, readonly, nullable) UIView *targetView;

/**
 The delegate of the HUD.
 @sa JGProgressHUDDelegate.
 */
@property (nonatomic, weak, nullable) id <JGProgressHUDDelegate> delegate;

/** The actual HUD view visible on screen. You may add animations to this view. */
@property (nonatomic, strong, readonly, nonnull) UIView *HUDView;

/**
 The content view inside the @c HUDView. If you want to add additional views to the HUD you should add them as subview to the @c contentView.
 */
@property (nonatomic, strong, readonly, nonnull) UIView *contentView;

/**
 The label used to present text on the HUD. Set the @c text or @c attributedText property of this label to change the displayed text. You may not change the label's @c frame or @c bounds.
 */
@property (nonatomic, strong, readonly, nonnull) UILabel *textLabel;

/**
 The label used to present detail text on the HUD. Set the @c text or @c attributedText property of this label to change the displayed text. You may not change the label's @c frame or @c bounds.
 */
@property (nonatomic, strong, readonly, nonnull) UILabel *detailTextLabel;

/**
 The indicator view. You can assign a custom subclass of @c JGProgressHUDIndicatorView to this property or one of the default indicator views (if you do so, you should assign it before showing the HUD). This value is optional.
 @b Default: JGProgressHUDIndeterminateIndicatorView.
 */
@property (nonatomic, strong, nullable) JGProgressHUDIndicatorView *indicatorView;

/**
 The shadow cast by the @c HUDView. This value is optional. Setting this to @c nil means no shadow is cast by the HUD.
 @b Default: nil.
 */
@property (nonatomic, strong, nullable) JGProgressHUDShadow *shadow;

/**
 The position of the HUD inside the hosting view's frame, or inside the specified frame.
 @b Default: JGProgressHUDPositionCenter
 */
@property (nonatomic, assign) JGProgressHUDPosition position;

/**
 The animation used for showing and dismissing the HUD.
 @b Default: JGProgressHUDFadeAnimation.
 */
@property (nonatomic, strong, nonnull) JGProgressHUDAnimation *animation;

#if TARGET_OS_IOS
/**
 Interaction type of the HUD. Determines whether touches should be let through to the views behind the HUD.
 @sa JGProgressHUDInteractionType.
 @b Default: JGProgressHUDInteractionTypeBlockAllTouches.
 */
@property (nonatomic, assign) JGProgressHUDInteractionType interactionType;
#endif

/**
 Parallax mode for the HUD. This setting determines whether the HUD should have a parallax (@c UIDeviceMotion) effect. This effect is controlled by device motion on iOS and remote touchpad panning gestures on tvOS.
 @sa JGProgressHUDParallaxMode.
 @b Default: JGProgressHUDParallaxModeDevice.
 */
@property (nonatomic, assign) JGProgressHUDParallaxMode parallaxMode;

#if TARGET_OS_TV
/**
 When this property is set to @c YES the HUD will try to become focused, which prevents interactions with the @c targetView. If set to @c NO the HUD will not become focused and interactions with @c targetView remain possible. Default: @c YES.
 */
@property (nonatomic, assign) BOOL wantsFocus;
#endif

/**
 If the HUD should always have the same width and height.
 @b Default: NO.
 */
@property (nonatomic, assign) BOOL square;

/**
 Internally @c JGProgressHUD uses an @c UIVisualEffectView with a @c UIBlurEffect. A second @c UIVisualEffectView can be added on top of that with a @c UIVibrancyEffect which amplifies and adjusts the color of content layered behind the view, allowing content placed inside the contentView to become more vivid. This flag sets whether the @c UIVibrancyEffect should be used. Using the vibrancy effect can sometimes, depending on the contents of the display, result in a weird look (especially on iOS < 9.3).
 @b Default: NO.
 */
@property (nonatomic, assign) BOOL vibrancyEnabled;

/**
 The radius used for rounding the four corners of the HUD view.
 @b Default: 10.0.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 Insets the contents of the HUD.
 @b Default: (20, 20, 20, 20).
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 Insets the HUD from the frame of the hosting view or from the specified frame to present the HUD from.
 @b Default: (20, 20, 20, 20).
 */
@property (nonatomic, assign) UIEdgeInsets marginInsets __attribute((deprecated(("Use layoutMargins instead."))));

/**
 @attention This property is deprecated and does nothing.
 */
@property (nonatomic, assign) NSTimeInterval layoutChangeAnimationDuration __attribute((deprecated(("Use UIView animation to animate layout changes. This allows setting a custom animation duration, animaiton curve and other options."))));

/**
 @return Whether the HUD is visible on screen.
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

/**
 Specifies a minimum time that the HUD will be on-screen. Useful to prevent the HUD from flashing quickly on the screen when indeterminate tasks complete more quickly than expected.
 @b Default: 0.0.
 */
@property (nonatomic, assign) NSTimeInterval minimumDisplayTime;

/**
 Determines whether Voice Over announcements should be made upon displaying the HUD (if Voice Over is active).
 @b Default: YES
 */
@property (nonatomic, assign) BOOL voiceOverEnabled;

#if TARGET_OS_IOS
/**
 A block to be invoked when the HUD view is tapped.
 @note The interaction type of the HUD must be @c JGProgressHUDInteractionTypeBlockTouchesOnHUDView or @c JGProgressHUDInteractionTypeBlockAllTouches, otherwise this block won't be fired.
 */
@property (nonatomic, copy, nullable) void (^tapOnHUDViewBlock)(JGProgressHUD *__nonnull HUD);

/**
 A block to be invoked when the area outside of the HUD view is tapped.
 @note The interaction type of the HUD must be @c JGProgressHUDInteractionTypeBlockAllTouches, otherwise this block won't be fired.
 */
@property (nonatomic, copy, nullable) void (^tapOutsideBlock)(JGProgressHUD *__nonnull HUD);
#endif

/**
 Shows the HUD animated. You should preferably show the HUD in a UIViewController's view. The HUD will be repositioned in response to rotation and keyboard show/hide notifications.
 @param view The view to show the HUD in. The frame of the @c view will be used to calculate the position of the HUD.
 */
- (void)showInView:(UIView *__nonnull)view;

/**
 Shows the HUD. You should preferably show the HUD in a UIViewController's view.  The HUD will be repositioned in response to rotation and keyboard show/hide notifications.
 @param view The view to show the HUD in. The frame of the @c view will be used to calculate the position of the HUD.
 @param animated If the HUD should show with an animation.
 */
- (void)showInView:(UIView *__nonnull)view animated:(BOOL)animated;

/** Dismisses the HUD animated. */
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
+ (NSArray<JGProgressHUD *> *__nonnull)allProgressHUDsInView:(UIView *__nonnull)view;

/**
 @param view The view to return all visible progress HUDs for.
 @return All visible progress HUDs in the view and its subviews.
 */
+ (NSArray<JGProgressHUD *> *__nonnull)allProgressHUDsInViewHierarchy:(UIView *__nonnull)view;

@end

@interface JGProgressHUD (Deprecated)

#define JG_PROGRESS_HUD_SHOW_IN_RECT_DEPRECATED __attribute((deprecated(("Showing a HUD in a specific frame is no longer supported. Use a blank UIView with the desired frame and present the HUD in that view to achieve this behaviour."))))

/**
 Shows the HUD animated. You should preferably show the HUD in a UIViewController's view.
 @param view The view to show the HUD in.
 @param rect The rect allocated in @c view for displaying the HUD.
 */
- (void)showInRect:(CGRect)rect inView:(UIView *__nonnull)view JG_PROGRESS_HUD_SHOW_IN_RECT_DEPRECATED;

/**
 Shows the HUD. You should preferably show the HUD in a UIViewController's view.
 @param view The view to show the HUD in.
 @param rect The rect allocated in @c view for displaying the HUD.
 @param animated If the HUD should show with an animation.
 */
- (void)showInRect:(CGRect)rect inView:(UIView *__nonnull)view animated:(BOOL)animated JG_PROGRESS_HUD_SHOW_IN_RECT_DEPRECATED;

@end

@protocol JGProgressHUDDelegate <NSObject>

@optional

/**
 Called before the HUD will appear.
 @param view The view in which the HUD is presented.
 */
- (void)progressHUD:(JGProgressHUD *__nonnull)progressHUD willPresentInView:(UIView *__nonnull)view;

/**
 Called after the HUD appeared.
 @param view The view in which the HUD is presented.
 */
- (void)progressHUD:(JGProgressHUD *__nonnull)progressHUD didPresentInView:(UIView *__nonnull)view;

/**
 Called before the HUD will disappear.
 @param view The view in which the HUD is presented and will be dismissed from.
 */
- (void)progressHUD:(JGProgressHUD *__nonnull)progressHUD willDismissFromView:(UIView *__nonnull)view;

/**
 Called after the HUD has disappeared.
 @param view The view in which the HUD was presented and was be dismissed from.
 */
- (void)progressHUD:(JGProgressHUD *__nonnull)progressHUD didDismissFromView:(UIView *__nonnull)view;

@end
