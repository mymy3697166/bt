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

- (IBAction)nextClick:(UIBarButtonItem *)sender {
//  if ([tbPwd.text isEqualToString:@""]) {
//    [Common info:@"请输入密码"];
//    return;
//  }
//  if (![Common regularTest:@"^.{6,20}$" text:tbPwd.text]) {
//    [Common info:@"您输入的密码位数有误"];
//    return;
//  }
//  [Common asyncPost:URL_REGISTER forms:@{@"uid": self.uid, @"pwd": tbPwd.text, @"code": self.captcha} completion:^(NSDictionary *data) {
//    if (data == nil) return;
//    if ([data[@"status"] isEqual:@0]) {
//      User.uid = data[@"data"][@"mid"];
//      User.token = data[@"data"][@"mtoken"];
//      [self.navigationController performSegueWithIdentifier:@"pwd_info" sender:nil];
//    } else [Common info:data[@"description"]];
//  }];
  [self performSegueWithIdentifier:@"pwd_info" sender:nil];
}

- (IBAction)backClick:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
