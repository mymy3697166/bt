//
//  BTRegisterViewController.m
//  bt
//
//  Created by zjz on 17/1/7.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTRegisterViewController.h"
#import "BTCaptchaViewController.h"

@interface BTRegisterViewController () {
  
  __weak IBOutlet UITextField *tbUid;
}
@end

@implementation BTRegisterViewController
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [tbUid becomeFirstResponder];
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
  if ([tbUid.text isEqualToString:@""]) {
    [Common info:@"请输入手机号"];
    return;
  }
  if (![tbUid.text testByRegular:@"^1\\d{10}$"]) {
    [Common info:@"您输入的手机号格式有误"];
    return;
  }
  [Common showLoading];
  [BTUser sendRegisterVerifyCodeToMobilePhone:tbUid.text andBlock:^(NSError *error) {
    [Common hideLoading];
    if (error) [self showError:error];
    else {
      [self performSegueWithIdentifier:@"register_captcha" sender:self];
    }
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"register_captcha"]) {
    BTCaptchaViewController *cvc = segue.destinationViewController;
    cvc.uid = tbUid.text;
  }
}
@end
