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
  btnLogin.layer.cornerRadius = 23;
  
  [N addObserver:self selector:@selector(closeClick:) name:@"NLOGINCOMPLETE" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
  [tbUid resignFirstResponder];
  [tbPwd resignFirstResponder];
}

- (IBAction)loginClick:(UIButton *)sender {
  if ([tbUid.text isEqualToString:@""]) {
    [Common info:@"请输入手机号"];
    return;
  }
  if ([tbPwd.text isEqualToString:@""]) {
    [Common info:@"请输入密码"];
    return;
  }
  [Common showLoading];
  [BTUser loginWithMobilePhone:tbUid.text andPwd:tbPwd.text andBlock:^(NSError *error) {
    [Common hideLoading];
    if (error) [self showError:error];
    else {
      [N postNotificationName:@"N_LOGIN_SUCCESS" object:nil];
      [self dismissViewControllerAnimated:YES completion:nil];
    }
  }];
}

- (IBAction)closeClick:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
