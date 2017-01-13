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
  NSDictionary *forms = @{@"uid": tbUid.text, @"pwd": tbPwd.text};
  [Common showLoading];
  [Common asyncPost:URL_LOGIN forms:forms completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if ([data[@"status"] isEqual:@0]) {
      User.uid = data[@"data"][@"mid"];
      User.token = data[@"data"][@"access_token"];
      [self closeClick:nil];
    } else {
      [Common info:data[@"description"]];
    }
  }];
}

- (IBAction)closeClick:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
