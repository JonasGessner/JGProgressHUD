//
//  JGMainViewController.m
//  JGProgressHUD Tests
//
//  Created by Jonas Gessner on 20.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGMainViewController.h"
#import "JGDetailViewController.h"

@import JGProgressHUD;

@interface JGMainViewController () <JGProgressHUDDelegate> {
    JGProgressHUDStyle _style;
    JGProgressHUDInteractionType _interaction;
    BOOL _zoom;
    BOOL _dim;
    BOOL _vibrancy;
    BOOL _shadow;
}

@end

@implementation JGMainViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _interaction = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    }
    return self;
}

#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    NSLog(@"HUD %p will present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    NSLog(@"HUD %p did present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    NSLog(@"HUD %p will dismiss from view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    NSLog(@"HUD %p did dismiss from view: %p", progressHUD, view);
}


#pragma mark -

- (JGProgressHUD *)prototypeHUD {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:_style];
    HUD.interactionType = _interaction;
    
    if (_zoom) {
        JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
        HUD.animation = an;
    }
    
    if (_dim) {
        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    }
    
    HUD.vibrancyEnabled = _vibrancy;
    
    if (_shadow) {
        HUD.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor blackColor] offset:CGSizeZero radius:5.0 opacity:0.3f];
    }
    
    HUD.delegate = self;
    
    return HUD;
}

- (void)showSuccessHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.textLabel.text = @"Success!";
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:4.0];
}

- (void)showErrorHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.textLabel.text = @"Error!";
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:4.0];
}

- (void)showSimpleHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    [HUD showInView:self.navigationController.view];

    [HUD dismissAfterDelay:4.0];
}

- (void)showCancellableHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.textLabel.text = @"Loading for a long time";
    
    __block BOOL confirmationAsked = NO;
    
    HUD.tapOnHUDViewBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            [h dismiss];
        }
        else {
            h.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            h.textLabel.text = @"Cancel?";
            confirmationAsked = YES;
            
            h.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor redColor] offset:CGSizeZero radius:8.0 opacity:0.0f];
            
            [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut animations:^{
                h.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor redColor] offset:CGSizeZero radius:8.0 opacity:0.5f];
            } completion:nil];
            
            __weak __typeof(h) wH = h;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wH && confirmationAsked) {
                    confirmationAsked = NO;
                    __strong __typeof(wH) sH = wH;
                    
                    sH.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
                    sH.textLabel.text = @"Loading for a long time";
                    
                    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        sH.shadow = nil;
                    } completion:nil];
                    
                    if (self->_shadow) {
                        sH.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor blackColor] offset:CGSizeZero radius:5.0 opacity:0.3f];
                    }
                }
            });
        }
    };
    
    HUD.tapOutsideBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            confirmationAsked = NO;
            h.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
            h.textLabel.text = @"Loading for a long time";
            
            [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                h.shadow = nil;
            } completion:nil];

            if (self->_shadow) {
                h.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor blackColor] offset:CGSizeZero radius:5.0 opacity:0.3f];
            }
        }
    };
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:120.0];
}

- (void)showHUDWithTransform {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.textLabel.text = @"Loading";
    
    HUD.layoutMargins = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            HUD.indicatorView = nil;
            
            HUD.textLabel.font = [UIFont systemFontOfSize:30.0f];
            
            HUD.textLabel.text = @"Done";
            
            HUD.position = JGProgressHUDPositionBottomCenter;
        }];
    });
    
    [HUD dismissAfterDelay:4.0];
}

- (void)showRingHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.indicatorView = [[JGProgressHUDRingIndicatorView alloc] init];
    
    HUD.detailTextLabel.text = @"0% Complete";
    
    HUD.textLabel.text = @"Downloading";
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self incrementHUD:HUD progress:0];
    });
}

- (void)showPieHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
    
    HUD.detailTextLabel.text = @"0% Complete";
    
    HUD.textLabel.text = @"Downloading";
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self incrementHUD:HUD progress:0];
    });
}

- (void)incrementHUD:(JGProgressHUD *)HUD progress:(int)progress {
    progress += 1;
    
    [HUD setProgress:progress/100.0f animated:NO];
    HUD.detailTextLabel.text = [NSString stringWithFormat:@"%i%% Complete", progress];
    
    if (progress == 100) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                HUD.textLabel.text = @"Success";
                HUD.detailTextLabel.text = nil;
                HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
        });
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self incrementHUD:HUD progress:progress];
        });
    }
}

- (void)showTextHUD {
    JGProgressHUD *HUD = self.prototypeHUD;
    
    HUD.indicatorView = nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Attributed" attributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" Text" attributes:@{NSForegroundColorAttributeName : [UIColor greenColor], NSFontAttributeName: [UIFont systemFontOfSize:11.0]}]];
    
    HUD.textLabel.attributedText = text;
    
    HUD.position = JGProgressHUDPositionBottomCenter;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:4.0];
}

- (void)setHUDStyle:(UISegmentedControl *)c {
    _style = c.selectedSegmentIndex;
}

- (void)setInteraction:(UISegmentedControl *)c {
    _interaction = c.selectedSegmentIndex;
}

- (void)setZoom:(UISegmentedControl *)c {
    _zoom = c.selectedSegmentIndex;
}

- (void)setVibrancy:(UISwitch *)s {
    _vibrancy = s.on;
}

- (void)setDim:(UISwitch *)s {
    _dim = s.on;
}

- (void)setShadow:(UISwitch *)s {
    _shadow = s.on;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Configure";
    }
    else {
        return @"Show a HUD";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    else {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Style";
            
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Extra Light", @"Light", @"Dark"]];
            segment.selectedSegmentIndex = _style;
            [segment addTarget:self action:@selector(setHUDStyle:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = segment;
            [segment sizeToFit];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Block Touches";
            
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"All", @"On HUD", @"None"]];
            segment.selectedSegmentIndex = _interaction;
            [segment addTarget:self action:@selector(setInteraction:) forControlEvents:UIControlEventValueChanged];
            [segment sizeToFit];
            
            CGRect f = segment.frame;
            f.size.width -= 30.0f;
            segment.frame = f;
            
            cell.accessoryView = segment;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Animation";
            
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Fade", @"Zoom"]];
            segment.selectedSegmentIndex = _zoom;
            [segment addTarget:self action:@selector(setZoom:) forControlEvents:UIControlEventValueChanged];
            [segment sizeToFit];
            
            cell.accessoryView = segment;
        }
        else if (indexPath.row == 3) {
            UITextField *t = [[UITextField alloc] init];
            t.returnKeyType = UIReturnKeyDone;
            [t addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
            t.borderStyle = UITextBorderStyleRoundedRect;
            [t sizeToFit];
            CGRect f = t.frame;
            f.size.width = 100.0f;
            t.frame = f;
            cell.accessoryView = t;
            cell.textLabel.text = @"Show a keyboard";
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = @"Use vibrancy effect";
            UISwitch *s = [[UISwitch alloc] init];
            s.tintColor = [UIColor whiteColor];
            s.on = _vibrancy;
            
            [s addTarget:self action:@selector(setVibrancy:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        else if (indexPath.row == 5) {
            cell.textLabel.text = @"Dim Background";
            UISwitch *s = [[UISwitch alloc] init];
            s.tintColor = [UIColor whiteColor];
            s.on = _dim;
            
            [s addTarget:self action:@selector(setDim:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        else if (indexPath.row == 6) {
            cell.textLabel.text = @"Apply Shadow";
            UISwitch *s = [[UISwitch alloc] init];
            s.tintColor = [UIColor whiteColor];
            s.on = _shadow;
            
            [s addTarget:self action:@selector(setShadow:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryView = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Activity Indicator";
                break;
            case 1:
                cell.textLabel.text = @"Activity Indicator & Text, Position Change";
                break;
            case 2:
                cell.textLabel.text = @"Pie Progress, Text & Detail Text";
                break;
            case 3:
                cell.textLabel.text = @"Ring Progress, Text & Detail Text";
                break;
            case 4:
                cell.textLabel.text = @"Attributed text, Bottom Position";
                break;
            case 5:
                cell.textLabel.text = @"Success, Square Shape";
                break;
            case 6:
                cell.textLabel.text = @"Error, Square Shape";
                break;
            case 7:
                cell.textLabel.text = @"Tap To Cancel";
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            [self showSimpleHUD];
            break;
        case 1:
            [self showHUDWithTransform];
            break;
        case 2:
            [self showPieHUD];
            break;
        case 3:
            [self showRingHUD];
            break;
        case 4:
            [self showTextHUD];
            break;
        case 5:
            [self showSuccessHUD];
            break;
        case 6:
            [self showErrorHUD];
            break;
        case 7:
            [self showCancellableHUD];
            break;
    }
}

- (void)dismissKeyboard:(UITextField *)t {
    [t resignFirstResponder];
}

- (void)pushDetailVC {
    JGDetailViewController *vc = [[JGDetailViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JGProgressHUD";
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push VC" style:UIBarButtonItemStylePlain target:self action:@selector(pushDetailVC)];
}

@end
