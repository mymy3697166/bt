//
//  BTPwdViewController.m
//  bt
//
//  Created by zjz on 2017/1/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTPwdViewController.h"

@interface BTPwdViewController () {
  __weak IBOutlet UITextField *tbPwd;
}
@end

@implementation BTPwdViewController
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [tbPwd becomeFirstResponder];
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
  if ([tbPwd.text isEqualToString:@""]) {
    [Common info:@"请输入密码"];
    return;
  }
  if (![tbPwd.text testByRegular:@"^.{6,20}$"]) {
    [Common info:@"您输入的密码位数有误"];
    return;
  }
  [Common showLoading];
  [BTUser registerWithMobilePhone:self.uid andPwd:tbPwd.text andVerifyCode:self.captcha andBlock:^(NSError *error) {
    [Common hideLoading];
    if (error) [self showError:error];
    else [self performSegueWithIdentifier:@"pwd_info" sender:nil];
  }];
}
@end
