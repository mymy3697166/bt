//
//  BTLoginViewController.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTLoginViewController.h"

@interface BTLoginViewController () {
  __weak IBOutlet UIButton *btnLogin;
  __weak IBOutlet UITextField *tbUid;
  __weak IBOutlet UITextField *tbPwd;
}
@end

@implementation BTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  btnLogin.clipsToBounds = YES;
  btnLogin.layer.cornerRadius = 23;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
  [tbUid resignFirstResponder];
  [tbPwd resignFirstResponder];
}

- (IBAction)loginClick:(UIButton *)sender {
  if ([tbUid.text isEqualToString:@""]) {
    [self.message info:@"请输入手机号"];
    return;
  }
  if ([tbPwd.text isEqualToString:@""]) {
    [self.message info:@"请输入密码"];
    return;
  }
  
}

- (IBAction)closeClick:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
