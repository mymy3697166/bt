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
  [Common asyncPost:URL_REGISTER forms:@{@"uid": self.uid, @"pwd": tbPwd.text, @"code": self.captcha} completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if ([data[@"status"] isEqual:@0]) {
      U.mid = data[@"data"][@"mid"];
      U.token = data[@"data"][@"access_token"];
      [self performSegueWithIdentifier:@"pwd_info" sender:nil];
    } else [Common info:data[@"description"]];
  }];
}
@end
