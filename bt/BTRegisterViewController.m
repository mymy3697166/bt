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
  if ([tbUid.text isEqualToString:@""]) {
    [self.message info:@"请输入您的手机号"];
    return;
  }
  [self performSegueWithIdentifier:@"register_captcha" sender:self];
}

- (IBAction)backClick:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"register_captcha"]) {
    BTCaptchaViewController *cvc = segue.destinationViewController;
    cvc.uid = tbUid.text;
  }
}
@end
