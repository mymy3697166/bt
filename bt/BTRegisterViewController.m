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
  [tbUid becomeFirstResponder];
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
//  if ([tbUid.text isEqualToString:@""]) {
//    [Common info:@"请输入手机号"];
//    return;
//  }
//  if (![Common regularTest:@"^1\\d{10}$" text:tbUid.text]) {
//    [Common info:@"您输入的手机号格式有误"];
//    return;
//  }
//  [Common asyncPost:URL_REGISTERCODE forms:@{@"mobile_no": tbUid.text} completion:^(NSDictionary *data) {
//    if (data == nil) return;
//    if ([data[@"status"] isEqual:@0]) {
//      [self performSegueWithIdentifier:@"register_captcha" sender:self];
//    } else [Common info:data[@"description"]];
//  }];
  [self performSegueWithIdentifier:@"register_captcha" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"register_captcha"]) {
    BTCaptchaViewController *cvc = segue.destinationViewController;
    cvc.uid = tbUid.text;
  }
}

- (IBAction)backClick:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
