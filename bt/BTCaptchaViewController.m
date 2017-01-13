//
//  BTCaptchaViewController.m
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCaptchaViewController.h"
#import "BTPwdViewController.h"

@interface BTCaptchaViewController () {
  __weak IBOutlet UILabel *labUid;
  __weak IBOutlet UITextField *tbCaptcha;
  __weak IBOutlet UIButton *btnFetch;
}
@end

@implementation BTCaptchaViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  labUid.text = [labUid.text stringByAppendingString:self.uid];
  [self startCount];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [tbCaptcha becomeFirstResponder];
}

- (void)startCount {
  btnFetch.enabled = NO;
  [btnFetch setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
  __block int s = 60;
  __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *t) {
    s--;
    if (s == 0) {
      [timer invalidate];
      timer = nil;
      btnFetch.titleLabel.text = @"重新获取";
      btnFetch.enabled = YES;
      [btnFetch setTitle:@"重新获取" forState:UIControlStateNormal];
      [btnFetch setTitleColor:RGB(94, 94, 94) forState:UIControlStateNormal];
      return;
    }
    NSString *ss = [NSString stringWithFormat:@"重新获取（%dS）", s];
    btnFetch.titleLabel.text = ss;
    [btnFetch setTitle:ss forState:UIControlStateNormal];
  }];
  [timer fire];
}

- (IBAction)fetchClick:(UIButton *)sender {
  [Common asyncPost:URL_REGISTERCODE forms:@{@"mobile_no": self.uid} completion:^(NSDictionary *data) {
    if (data == nil) return;
    if ([data[@"status"] isEqual:@0]) {
      [self startCount];
    } else [Common info:data[@"description"]];
  }];
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
  if ([tbCaptcha.text isEqualToString:@""]) {
    [Common info:@"请输入验证码"];
    return;
  }
  [Common showLoading];
  [Common asyncPost:URL_VALIDATECODE forms:@{@"mobile_no": self.uid, @"code": tbCaptcha.text} completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if ([data[@"status"] isEqual:@0]) {
      [self performSegueWithIdentifier:@"captcha_pwd" sender:nil];
    } else [Common info:data[@"description"]];
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"captcha_pwd"]) {
    BTPwdViewController *vc = segue.destinationViewController;
    vc.uid = self.uid;
    vc.captcha = tbCaptcha.text;
  }
}
@end
