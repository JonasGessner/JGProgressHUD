//
//  JGDetailViewController.m
//  JGProgressHUD Tests
//
//  Created by Jonas Gessner on 06.08.16.
//  Copyright © 2016 Jonas Gessner. All rights reserved.
//

#import "JGDetailViewController.h"

@implementation JGDetailViewController {
    UITextField *_textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"Text field";
    
    [self.view addSubview:_textField];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _textField.frame = CGRectMake(30.0, (self.view.frame.size.height-25.0)/2.0, self.view.frame.size.width-60.0, 25.0);
}

@end
