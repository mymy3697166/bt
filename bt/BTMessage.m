//
//  BTAlert.m
//  bt
//
//  Created by zjz on 17/1/7.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTMessage.h"
#import "MBProgressHUD.h"

@implementation BTMessage

- (instancetype)init {
  return self;
}

- (void)info:(NSString *)message {
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
  hud.mode = MBProgressHUDModeText;
  hud.label.text = message;
  hud.label.textColor = [UIColor whiteColor];
  hud.bezelView.color = [UIColor blackColor];
  hud.removeFromSuperViewOnHide = YES;
  [hud hideAnimated:YES afterDelay:2];
}
@end
