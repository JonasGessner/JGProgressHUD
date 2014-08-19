//
//  JGViewController.m
//  JGProgressHUD Tests
//
//  Created by Jonas Gessner on 20.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"

@interface JGViewController () <JGProgressHUDDelegate> {
    BOOL _blockUserInteraction;
}

@end

@implementation JGViewController

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


- (void)success:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.delegate = self;
    HUD.textLabel.text = @"Success!";
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:3.0];
}

- (void)error:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.delegate = self;
    HUD.textLabel.text = @"Error!";
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:3.0];
}

- (void)simple:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.delegate = self;
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:3.0];
}

- (void)withText:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.textLabel.text = @"Loading...";
    HUD.delegate = self;
    HUD.userInteractionEnabled = _blockUserInteraction;
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HUD.indicatorView = nil;
        
        HUD.textLabel.font = [UIFont systemFontOfSize:30.0f];
        
        HUD.textLabel.text = @"Done";
        
        HUD.position = JGProgressHUDPositionBottomCenter;
    });
    
    HUD.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
    [HUD dismissAfterDelay:3];
}

- (void)progress:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.delegate = self;
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.textLabel.text = @"Uploading...";
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD dismiss];
    });
}

- (void)zoomAnimationWithRing:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.indicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.userInteractionEnabled = _blockUserInteraction;
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.delegate = self;
    HUD.textLabel.text = @"Downloading...";
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD dismiss];
    });
}

- (void)textOnly:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.indicatorView = nil;
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.textLabel.text = @"Hello, World!";
    HUD.delegate = self;
    HUD.position = JGProgressHUDPositionBottomCenter;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:2.0f];
}

- (void)switched:(UISwitch *)s {
    _blockUserInteraction = s.on;
    
    for (JGProgressHUD *visible in [JGProgressHUD allProgressHUDsInViewHierarchy:self.navigationController.view]) {
        visible.userInteractionEnabled = _blockUserInteraction;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    else if (section == 1) {
        return @"Extra Light Style";
    }
    else if (section == 2) {
        return @"Light Style";
    }
    else {
        return @"Dark Style";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else {
        return 7;
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
            cell.textLabel.text = @"Block User Interaction";
            UISwitch *s = [[UISwitch alloc] init];
            s.on = _blockUserInteraction;
            [s addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        else {
            UITextField *t = [[UITextField alloc] init];
            t.returnKeyType = UIReturnKeyDone;
            [t addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
            t.borderStyle = UITextBorderStyleRoundedRect;
            [t sizeToFit];
            CGRect f = t.frame;
            f.size.width = 55.0f;
            t.frame = f;
            cell.accessoryView = t;
            cell.textLabel.text = @"Show a keyboard ->";
        }
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryView = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Fade, Activity Indicator";
                break;
            case 1:
                cell.textLabel.text = @"Fade, Act. Ind. & Text, Transform";
                break;
            case 2:
                cell.textLabel.text = @"Fade, Pie Progress, Dim Background";
                break;
            case 3:
                cell.textLabel.text = @"Zoom, Ring Progress, Dim Background";
                break;
            case 4:
                cell.textLabel.text = @"Fade, Text Only, Bottom Position";
                break;
            case 5:
                cell.textLabel.text = @"Fade, Success, Square Shape";
                break;
            case 6:
                cell.textLabel.text = @"Fade, Error, Square Shape";
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
            [self simple:indexPath.section-1];
            break;
        case 1:
            [self withText:indexPath.section-1];
            break;
        case 2:
            [self progress:indexPath.section-1];
            break;
        case 3:
            [self zoomAnimationWithRing:indexPath.section-1];
            break;
        case 4:
            [self textOnly:indexPath.section-1];
            break;
        case 5:
            [self success:indexPath.section-1];
            break;
        case 6:
            [self error:indexPath.section-1];
            break;
    }
}

- (void)dismissKeyboard:(UITextField *)t {
    [t resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blockUserInteraction = YES;
    
    self.title = @"JGProgressHUD";
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
}


@end
