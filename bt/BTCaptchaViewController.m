//
//  BTCaptchaViewController.m
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCaptchaViewController.h"

@interface BTCaptchaViewController () {
  __weak IBOutlet UILabel *labUid;
  __weak IBOutlet UITextField *tbCaptcha;
  __weak IBOutlet UIButton *btnFetch;
}
@end

@implementation BTCaptchaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [tbCaptcha becomeFirstResponder];
  labUid.text = [labUid.text stringByAppendingString:self.uid];
  [self startCount];
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
  
}

- (IBAction)backClick:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
